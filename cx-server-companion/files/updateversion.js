#!/usr/bin/env node
'use strict';

/***
 * This script consumes an old value and new value for the config parameter docker_image.
 * It then updates all occurrences in the provided server.cfg file.
 */

const fs = require('fs');
const escapeRegex = require('escape-string-regexp');

const RETURN_CODES = {
    "GENERAL_ERROR": 1,
    "DOCKER_IMAGE_NOT_FOUND": 2,
    "CURRENT_DOCKER_IMAGE_NOT_SPECIFIED": 3,
    "NEW_DOCKER_IMAGE_NOT_SPECIFIED": 4
};

if (!process.argv[2]) {
    exit("Missing parameter: Current docker image is not specified", RETURN_CODES.CURRENT_DOCKER_IMAGE_NOT_SPECIFIED)
}

if (!process.argv[3]) {
    exit("Missing parameter: New docker image is not specified", RETURN_CODES.NEW_DOCKER_IMAGE_NOT_SPECIFIED)
}

const currentImage = process.argv[2];
const newImage = process.argv[3];

const matches = [];

const serverCfgPath = '/cx-server/mount/server.cfg';
fs.readFile(serverCfgPath, 'utf8', function (err, data) {
    if (err) {
        exit("Failed to read server.cfg file")
    }
    else {
        const strInitialFile = data;


        const regex = new RegExp(`docker_image=(\"|'|)${escapeRegex(currentImage)}(\"|'|)`, 'gm');
        const strNewFile = strInitialFile.replace(regex, function (match, p1, p2, offset) {
            const newDockerImage = `docker_image="${newImage}"`;

            matches.push(offset);

            return newDockerImage
        });

        if (matches.length === 0) {
            exit("Failed to find docker_image attribute in server.cfg file", RETURN_CODES.DOCKER_IMAGE_NOT_FOUND)
        }

        fs.writeFileSync(serverCfgPath, strNewFile);

        console.log("Replaced", matches.length, "occurences of docker_image at offsets", matches)
    }
});


function exit(strErrorMessage, exitCode = RETURN_CODES.GENERAL_ERROR) {
    console.log(strErrorMessage);
    process.exit(exitCode);
}
