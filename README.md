# EVM Node Monitoring

A simple monitoring application for an EVM (Ethereum Virtual Machine) blockchain node. This application monitors the node's block number and checks the time passed since the last block. It also gathers system metrics such as free disk space, free memory, and CPU usage. The monitoring data is saved to a JSON file, and an Express server is set up to serve the monitoring data at the `/monitoring` endpoint.

## Prerequisites

- Node.js (version 12 or higher)
- npm

## Installation

1. Clone the repository:

  
    git clone https://github.com/yourusername/evm-node-monitor.git

2. Navigate to the project directory:
 

    cd evm-node-monitor

3. Install the required dependencies:


    npm install

4. Update the app.js file with the appropriate values for your EVM node:
* Replace your-node-url with the URL of your EVM node.
* Replace port with the desired port for the monitoring server.
* Replace your-upgrade-command with the command to upgrade your EVM node.

## Usage
Start the monitoring application:
    
    npm start

The monitoring application will start an Express server on the specified port (default is 3000) and perform monitoring every 10 seconds.

Access the monitoring data at the /monitoring endpoint:

    http://localhost:3000/monitoring

##Testing
Run the tests using the following command:

    npm test

This will run the tests using Jest and Supertest to ensure the /monitoring endpoint returns the correct monitoring data and status.

## License
This project is licensed under the MIT License.

