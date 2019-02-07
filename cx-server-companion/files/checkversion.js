#!/usr/bin/env node
'use strict';

/***
 * This script consumes a docker image name in the form of ppiper/jenkins-master:v2 (where the tag is optional)
 * and checks whether a higher version is available on Docker Hub. If yes, it returns with exit code 3 and prints the
 * currently highest version to STDOUT. If the supplied value is the newest version, 0 is returned.
 */

const request = require('request');

const RETURN_CODES = {
    "GENERAL_ERROR": 1,
    "INVALID_IMAGE_NAME": 2,
    "NEWER_VERSION_AVAILABLE": 3
};

if (!process.argv[2]) {
    exit("Missing parameter: Docker image name not specified");
}

const dockerImageInfo = parseDockerImageInfo(process.argv[2]);

const tagListUrl = `https://registry.hub.docker.com/v2/repositories/${dockerImageInfo.name}/tags`;

request(tagListUrl, function (error, response, body) {
    if (!error && response && (response.statusCode !== 200)) {
        error = "HTTP status code " + response.statusCode;
        if (body) {
            error += '\n' + body;
        }
    }
    if (error) {
        exit(`Error while retrieving list of tags from '${tagListUrl}'. Original error message: ${error}`);
    }

    const aTagsWithVersionNumbers = extractVersionNumbers(JSON.parse(body).results);

    aTagsWithVersionNumbers.sort(sortNumberDescending);

    if (aTagsWithVersionNumbers.length == 0) {
        exit("List of tags is empty");
    }

    const currentVersionNumber = getVersionNumberFromTagName(dockerImageInfo.tag);
    const newestAvailableTag = aTagsWithVersionNumbers[0];
    if (currentVersionNumber && (currentVersionNumber < newestAvailableTag.cdToolkitVersionNumber)) {
        console.log(dockerImageInfo.name + ":" + newestAvailableTag.name);
        process.exit(RETURN_CODES.NEWER_VERSION_AVAILABLE)
    }
    else {
        console.log(`Docker image '${dockerImageInfo.name}:${dockerImageInfo.tag}' is up to date`);
        process.exit(0);
    }
});

function sortNumberDescending(a, b) {
    return b.cdToolkitVersionNumber - a.cdToolkitVersionNumber
}

/***
 * Extracts the tag and image name from the supplied docker image name. If the image name contains a URL, it fails.
 * @param strDockerImage
 * @returns Name and tag of docker image
 */
function parseDockerImageInfo(strDockerImage) {
    // image string might contain docker registry url
    const urlMatch = strDockerImage.match(/\//g);
    if (!urlMatch || (urlMatch.length > 1)) {
        exit(`Invalid image name: '${strDockerImage}'. Expected format: 'ppiper/jenkins-master:tag'`, RETURN_CODES.INVALID_IMAGE_NAME);
    }

    const match = strDockerImage.match(/(.*\/.*):(.*)/);
    if (!match) {
        return {
            "name": strDockerImage,
            "tag": "latest"
        }
    }
    else {
        return {
            "name": match[1],
            "tag": match[2]
        }
    }
}

/***
 * Filters out tags whose names do not follow the schema 'v' followed by a natural number, e.g., 'v123'.
 * Furthermore, extracts the version number and stores it as the property 'cdToolkitVersionNumber'.
 * @param aTags The list of tags from Docker Hub
 */
function extractVersionNumbers(aTags) {
    const aFilteredResult = [];
    aTags.forEach(function (tag) {
        const versionNumber = getVersionNumberFromTagName(tag.name);
        if (versionNumber) {
            tag.cdToolkitVersionNumber = versionNumber;
            aFilteredResult.push(tag)
        }
    });

    return aFilteredResult;
}

/***
 * Extracts version number from tag or returns null if no version number is present (e.g. if tag is 'latest')
 * @param strTag The tag name, for example "v10"
 * @returns version number, or null if not present
 */
function getVersionNumberFromTagName(strTag) {
    const match = strTag.match(/^v(\d+)$/);
    if (match) {
        const versionNumber = Number.parseInt(match[1]);
        if (!(versionNumber.toString().length == strTag.length - 1)) {
            exit(`Sanity check failed. Expected ${versionNumber} to be one character shorter than ${strTag}.`)
        }
        return versionNumber;
    }
    else {
        return null;
    }
}

function exit(strErrorMessage, exitCode = RETURN_CODES.GENERAL_ERROR) {
    console.log(strErrorMessage);
    process.exit(exitCode);
}
