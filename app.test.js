const request = require('supertest');
const app = require('./app');
const fs = require('fs').promises;

describe('GET /monitoring', () => {

    beforeEach(async () => {
        // Create a sample monitoring data file
        const monitoringData = {
            lastBlockNumber: 123,
            timeSinceLastBlock: 1000,
            timeSinceUpgrade: 5000,
            freeDiskSpace: 100000,
            freeMemory: 8000,
            cpuUsage: 10.5,
            status: 'OK',
            timestamp: new Date().toISOString(),
        };
        await fs.writeFile('monitoring_data.json', JSON.stringify(monitoringData, null, 2));
    });

    afterEach(async () => {
        // Clean up the sample monitoring data file
        await fs.unlink('monitoring_data.json');
    });

    test('should return monitoring data with status OK', async () => {
        const res = await request(app).get('/monitoring');
        expect(res.statusCode).toEqual(200);
        expect(res.body.status).toEqual('OK');
    });

    test('should return monitoring data with status ERROR - stale data', async () => {

        // Update the timestamp in the monitoring data file to make it stale

        const monitoringData = JSON.parse(await fs.readFile('monitoring_data.json', 'utf-8'));
        monitoringData.timestamp = new Date(Date.now() - 30000).toISOString();
        await fs.writeFile('monitoring_data.json', JSON.stringify(monitoringData, null, 2));

        const res = await request(app).get('/monitoring');
        expect(res.statusCode).toEqual(200);
        expect(res.body.status).toEqual('ERROR - stale data');

    });
});
