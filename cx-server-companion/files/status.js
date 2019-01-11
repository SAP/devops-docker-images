#!/usr/bin/env node

'use strict';

if (!process.argv[2]) {
    console.error("Missing parameter: Configuration object is not specified");
    process.exit(-1);
}

const configString = process.argv[2];
const appConfig = JSON.parse(configString);

const expectDownloadCacheIsRunning = (appConfig.cache_enabled === true) || (appConfig.cache_enabled === 'true') || (appConfig.cache_enabled === '');

const {
    spawnSync
} = require('child_process');
const ps = spawnSync('docker', ['ps', '--no-trunc', '--format', '{{ json . }}', '--filter', 'name=cx']);

const containers = ps.stdout.toString().split('\n').filter(line => line.length > 3).map(jsonLine => JSON.parse(jsonLine))

if (containers.length === 0) {
    console.log('Cx Server is not running.')
} else {
    if (expectDownloadCacheIsRunning) {
        if (containers.filter(c => c.Names.includes("cx-nexus")).length === 0) {
            console.error("⚠️ Expected Download cache to be running, but it is not. Most likely, this is caused by low memory in Docker." +
            "To fix this, please ensure that Docker has at least 4 GB memory, and restart Cx Server.")
        }
    }
    console.log('Running Cx Server containers:')
    console.log(spawnSync('docker', ['ps', '--filter', 'name=cx']).stdout.toString())
}
