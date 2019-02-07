#!/usr/bin/env node

'use strict';

/*
 * Run initialization script on nexus.
 * The actual script is in `nexus-init-repos.groovy`.
 */

const request = require('request')
const fs = require('fs')
const _ = require('underscore')

if (process.argv.length < 3) {
    throw new Error("Usage: node init-nexus.js template-values-object [application-configuration-object]")
}

const templateValues = JSON.parse(process.argv[2])
let appConfig = {}
if (!_.isUndefined(process.argv[3])) {
    appConfig = JSON.parse(process.argv[3])
}

function verboseLog() {
    if (appConfig.verbose) {
        console.log.apply(null, arguments)
    }
}

verboseLog(templateValues)

//The URL is accessible only by other containers that are connected to the same docker network
let baseUrl = 'http://cx-nexus:8081/'
let scriptTemplateFilePath = '/cx-server/nexus-init-repos.groovy'
if (appConfig.runLocally) {
    baseUrl = 'http://localhost:8081/'
    scriptTemplateFilePath = appConfig.scriptTemplateFilePath
}

/*
 * The base64 encoded authorization is a default Nexus credentials.
 * The URL is accessible only by other containers that are connected to the same docker network
 */
const nexusRequest = request.defaults({
    headers: {
        'Authorization': 'Basic YWRtaW46YWRtaW4xMjM=',
        'Content-Type': 'application/json'
    }
})

const scriptTemplate = fs.readFileSync(scriptTemplateFilePath).toString()
verboseLog("Script Template:", scriptTemplate)
const compiled = _.template(scriptTemplate)
const script = compiled(templateValues)
verboseLog("Compiled Script:", script)

const scriptRequestBody = {
    "name": "init-repos",
    "type": "groovy",
    "content": script
}

nexusRequest
    .get(`${baseUrl}service/rest/v1/script/init-repos`)
    .on('response', function (response) {
        if (response.statusCode !== 200) {
            console.log('Creating nexus initialization script...')
            nexusRequest
                .post(`${baseUrl}service/rest/v1/script`)
                .json(scriptRequestBody)
                .on('response', function (response) {
                    if (isInSuccessFamily(response.statusCode)) {
                        runScript()
                    } else {
                        console.log(`Unexpected status ${response.statusMessage} when creating nexus initialization script. Can't run script.`)
                    }
                })
        } else {
            console.log('Updating nexus initialization script...')
            nexusRequest
                .put(`${baseUrl}service/rest/v1/script/init-repos`)
                .json(scriptRequestBody)
                .on('response', function (response) {
                    if (isInSuccessFamily(response.statusCode)) {
                        runScript()
                    } else {
                        console.log(`Unexpected status ${response.statusMessage} when updating nexus initialization script. Can't run script.`)
                    }
                })
        }
    })

function runScript() {
    /*
     * The base64 encoded authorization is a default Nexus credentials.
     * The URL is accessible only by other containers that are connected to the same docker network
     */
    request(`${baseUrl}service/rest/v1/script/init-repos/run`, {
            method: 'POST',
            headers: {
                'Authorization': 'Basic YWRtaW46YWRtaW4xMjM=',
                'Content-Type': 'text/plain'
            }
        })
        .on('response', function (response) {
            console.log(`Run nexus initialization script, response: ${response.statusMessage}`)
        })
}

function isInSuccessFamily(statusCode) {
    return statusCode.toString().startsWith("2")
}
