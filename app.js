require('dotenv').config(); // Add this line at the top of the file
const fetch = require('node-fetch');
const cors = require('cors');
const express = require('express');
const os = require('os');

const app = express();
app.use(cors());
const fs = require('fs').promises;

const NETWORK = process.env.NETWORK;
const MONITORING_INTERVAL = process.env.MONITORING_INTERVAL || 10000;
const EVM_NODE_URL = process.env.EVM_NODE_URL;
const BLOCK_STALENESS_THRESHOLD = process.env.BLOCK_STALENESS_THRESHOLD || 30000;
const MONITORING_PORT = process.env.MONITORING_PORT || 3000;
const UPGRADE_COMMAND = process.env.UPGRADE_COMMAND
const UPGRADE_INTERVAL = process.env.UPGRADE_INTERVAL || 86400000;
const NODE_INFO_CMD = process.env.NODE_INFO_CMD
const NODE_GIT_RELEASE_URL = process.env.NODE_GIT_RELEASE_URL
const EXTRACT_VERSION_REGEXP = process.env.EXTRACT_VERSION_REGEXP
const ATTEMPT_COMMON_GH_UPGRADE = process.env.ATTEMPT_COMMON_GH_UPGRADE === 'true'

const {exec} = require('child_process');

let isUpgrading = false;
let lastBlockNumber = -1;
let lastBlockTime = 0;
let timeSinceUpgrade = 0;

async function fetchBlockNumber() {
    try {
        const response = await fetch(EVM_NODE_URL, {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({
                jsonrpc: '2.0',
                method: 'eth_blockNumber',
                params: [],
                id: 1,
            }),
        });

        const jsonResponse = await response.json();
        const currentBlockNumber = parseInt(jsonResponse.result, 16);
        const currentTime = Date.now();

        if (currentBlockNumber && currentBlockNumber !== lastBlockNumber) {
            lastBlockTime = currentTime;
            lastBlockNumber = currentBlockNumber;
        }

        return currentTime - lastBlockTime;

    } catch (e) {

        console.error(e)
        return BLOCK_STALENESS_THRESHOLD + 1

    }
}

async function getCurrentNodeVersion() {
    const getNodeVersionOutput = await new Promise((resolve, reject) => {
        exec(
            NODE_INFO_CMD,
            (error, stdout) => {
                if (error) {
                    reject(error);
                    return;
                }
                resolve(stdout);
            }
        );
    });

    const platformVersionRegex = new RegExp(EXTRACT_VERSION_REGEXP);
    const match = getNodeVersionOutput.match(platformVersionRegex);

    if (match && match[1]) {
        return match[1];
    } else {
        throw new Error('Could not extract platform version from the output');
    }
}


async function getLatestReleaseVersion() {
    const response = await fetch(NODE_GIT_RELEASE_URL);
    const jsonResponse = await response.json();
    return jsonResponse.tag_name;
}


async function getSystemMetrics() {
    const freeDiskSpace = await new Promise((resolve) =>
        exec('df --output=avail /', (error, stdout) => resolve(parseInt(stdout.split('\n')[1])))
    );

    const freeMemory = await new Promise((resolve) =>
        exec('free -m | awk \'NR==2{print $7}\'', (error, stdout) => resolve(parseInt(stdout.trim())))
    );

    const cpuUsage = await new Promise((resolve) =>
        exec('top -bn1 | grep "Cpu(s)" | sed "s/.*, *\\([0-9.]*\\)%* id.*/\\1/" | awk \'{print 100 - $1"%"}\'', (error, stdout) =>
            resolve(parseFloat(stdout.trim()))
        )
    );

    return {freeDiskSpace, freeMemory, cpuUsage};
}


async function runUpgradeCommand() {
    isUpgrading = true; // Set the flag to true before running the upgrade

    // Ensure the script is executable
    await new Promise((resolve) => {
        exec(`chmod +x ${UPGRADE_COMMAND}`, (chmodError) => {
            if (chmodError) {
                console.error(`Error setting script permissions: ${chmodError.message}`);
                resolve();
                return;
            }
            console.log(`Permissions set for upgrade script.`);
            resolve();
        });
    });

    // Run the upgrade command
    await new Promise((resolve) =>
        exec(UPGRADE_COMMAND, (error, stdout, stderr) => {
            if (error) {
                console.error(`Error running upgrade command: ${error.message}`);
            }
            if (stderr) {
                console.error(`Error output from upgrade command: ${stderr}`);
            }
            console.log(`Upgrade command output: ${stdout}`);
            resolve();
        })
    );

    isUpgrading = false; // Set the flag back to false after the upgrade is complete
}

async function performMonitoring() {
    const timeSinceLastBlock = await fetchBlockNumber();
    const {freeDiskSpace, freeMemory, cpuUsage} = await getSystemMetrics();

    let status = 'OK';
    if (timeSinceLastBlock > BLOCK_STALENESS_THRESHOLD) {
        status = 'ERROR - block is too old!';
    }

    if (timeSinceUpgrade >= UPGRADE_INTERVAL) {

        if (UPGRADE_COMMAND && ATTEMPT_COMMON_GH_UPGRADE) {

            const currentNodeVersion = await getCurrentNodeVersion();
            const latestReleaseVersion = await getLatestReleaseVersion();

            if (currentNodeVersion !== latestReleaseVersion) {

                await runUpgradeCommand();
                console.log('Node upgraded');

            }

        } else if (UPGRADE_COMMAND) {

            await runUpgradeCommand();
            console.log('Node upgraded');

        }

        timeSinceUpgrade = 0;

    } else {
        timeSinceUpgrade += MONITORING_INTERVAL;
    }

    const monitoringData = {
        network: NETWORK,
        lastBlockNumber,
        timeSinceLastBlock,
        timeSinceUpgrade,
        freeDiskSpace,
        freeMemory,
        cpuUsage,
        uptime: process.uptime(),
        status,
    };

    // Save monitoring data to disk
    const monitoringDataWithTimestamp = {...monitoringData, timestamp: new Date().toISOString()};

    console.log(monitoringDataWithTimestamp)

    await fs.writeFile('monitoring_data.json', JSON.stringify(monitoringDataWithTimestamp, null, 2));

    return monitoringData;
}


app.get('/', async (req, res) => {
    try {
        const monitoringDataFromFile = await fs.readFile('monitoring_data.json', 'utf-8');
        const monitoringData = JSON.parse(monitoringDataFromFile);
        const currentTime = new Date();
        const savedTimestamp = new Date(monitoringData.timestamp);
        const elapsedTime = currentTime - savedTimestamp;

        if (elapsedTime > MONITORING_INTERVAL * 2) {
            monitoringData.status = 'ERROR - stale data!';
        }

        res.json(monitoringData);
    } catch (error) {
        console.error(`Error while performing monitoring: ${error.message}`);
        res.status(500).json({error: 'An error occurred while performing monitoring.'});
    }
});

// ... (rest of the code)

app.listen(MONITORING_PORT, async () => {

    console.log(`EVM Node Monitor listening at http://localhost:${MONITORING_PORT}`);

    await performMonitoring();

    setInterval(async () => {
        if (!isUpgrading) { // Check if an upgrade is in progress before performing monitoring
            await performMonitoring();
        }
    }, MONITORING_INTERVAL);
});

module.exports = app; // Add this line to export the app variable
