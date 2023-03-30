require('dotenv').config(); // Add this line at the top of the file
const fetch = require('node-fetch');
const express = require('express');
const app = express();
const fs = require('fs').promises;

const MONITORING_INTERVAL = 10000;

const EVM_NODE_URL = process.env.EVM_NODE_URL;
const MONITORING_PORT = process.env.MONITORING_PORT || 3000;
const UPGRADE_COMMAND = process.env.UPGRADE_COMMAND;
const UPGRADE_INTERVAL = process.env.UPGRADE_INTERVAL;

const {exec} = require('child_process');

let lastBlockNumber = -1;
let lastBlockTime = 0;
let timeSinceUpgrade = 0;

async function fetchBlockNumber() {
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

    if (currentBlockNumber !== lastBlockNumber) {
        lastBlockTime = currentTime;
        lastBlockNumber = currentBlockNumber;
    }

    return currentTime - lastBlockTime;
}


async function getSystemMetrics() {
    const freeDiskSpace = await new Promise((resolve) =>
        exec('df --output=avail /', (error, stdout) => resolve(stdout.split('\n')[1]))
    );

    const freeMemory = await new Promise((resolve) =>
        exec('free -m | awk \'NR==2{print $4}\'', (error, stdout) => resolve(parseInt(stdout.trim())))
    );

    const cpuUsage = await new Promise((resolve) =>
        exec('top -bn1 | grep "Cpu(s)" | sed "s/.*, *\\([0-9.]*\\)%* id.*/\\1/" | awk \'{print 100 - $1"%"}\'', (error, stdout) =>
            resolve(parseFloat(stdout.trim()))
        )
    );

    return {freeDiskSpace, freeMemory, cpuUsage};
}

async function runUpgradeCommand() {
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
}


async function performMonitoring() {
    const timeSinceLastBlock = await fetchBlockNumber();
    const {freeDiskSpace, freeMemory, cpuUsage} = await getSystemMetrics();

    let status = 'OK';
    if (timeSinceLastBlock > 60000) {
        status = 'ERROR';
    }

    if (timeSinceUpgrade >= UPGRADE_INTERVAL) {
        await runUpgradeCommand();
        console.log('Node upgraded');
        timeSinceUpgrade = 0;
    } else {
        timeSinceUpgrade += MONITORING_INTERVAL;
    }

    const monitoringData = {
        lastBlockNumber,
        timeSinceLastBlock,
        timeSinceUpgrade,
        freeDiskSpace,
        freeMemory,
        cpuUsage,
        status,
    };

    // Save monitoring data to disk
    const monitoringDataWithTimestamp = {...monitoringData, timestamp: new Date().toISOString()};
    await fs.writeFile('monitoring_data.json', JSON.stringify(monitoringDataWithTimestamp, null, 2));

    return monitoringData;
}


app.get('/monitoring', async (req, res) => {
    try {
        const monitoringDataFromFile = await fs.readFile('monitoring_data.json', 'utf-8');
        const monitoringData = JSON.parse(monitoringDataFromFile);
        const currentTime = new Date();
        const savedTimestamp = new Date(monitoringData.timestamp);
        const elapsedTime = currentTime - savedTimestamp;

        if (elapsedTime > MONITORING_INTERVAL * 2) {
            monitoringData.status = 'ERROR - stale data';
        }

        res.json(monitoringData);
    } catch (error) {
        console.error(`Error while performing monitoring: ${error.message}`);
        res.status(500).json({error: 'An error occurred while performing monitoring.'});
    }
});

// ... (rest of the code)

app.listen(MONITORING_PORT, () => {

    console.log(`EVM Node Monitor listening at http://localhost:${MONITORING_PORT}`);

    performMonitoring();

    setInterval(async () => {
        await performMonitoring();
    }, MONITORING_INTERVAL);
});

module.exports = app; // Add this line to export the app variable
