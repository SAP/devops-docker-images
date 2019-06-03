import groovy.transform.Field

import hudson.model.*
import hudson.ProxyConfiguration
import jenkins.model.*
import jenkins.plugins.git.GitSCMSource
import org.jenkinsci.plugins.workflow.libs.*
import java.net.URLDecoder
import java.util.logging.Logger

@Field
Jenkins instance = Jenkins.instance

@Field
Logger logger = Logger.getLogger("com.sap.piper.init")

try {
    // Migrate old setups by deleting old init files
    // TODO: Remove after Q2 2019 and assert that files are deleted
    deleteOldInitFiles()

    initProxy()
    initExecutors()
    initLibraries()
}
catch(Throwable t) {
    throw new Error("Failed to properly initialize Piper Jenkins. Please check the logs for more details.", t);
}



def initExecutors(){
    int numberOfExecutors = 6
    if(instance.getNumExecutors() < numberOfExecutors) {
        logger.info("Initializing ${numberOfExecutors} executors")
        instance.setNumExecutors(numberOfExecutors)
    }
}

def initLibraries(){
    def env = System.getenv()

    String piperLibraryOsUrl = env.PIPER_LIBRARY_OS_URL ?: "https://github.com/SAP/jenkins-library.git"
    String piperLibraryOsBranch = env.PIPER_LIBRARY_OS_BRANCH ?: "master"
    createLibIfMissing("piper-lib-os", piperLibraryOsUrl, piperLibraryOsBranch)
    
    String s4sdkLibraryUrl = env.S4SDK_LIBRARY_URL ?: "https://github.com/SAP/cloud-s4-sdk-pipeline-lib.git"
    String s4sdkLibraryBranch = env.S4SDK_LIBRARY_BRANCH ?: "master"
    createLibIfMissing("s4sdk-pipeline-library", s4sdkLibraryUrl, s4sdkLibraryBranch)
}

def createLibIfMissing(String libName, String gitUrl, String defaultBranch) {
    GitSCMSource gitScmSource = new GitSCMSource(null, gitUrl, "", "origin", "+refs/heads/*:refs/remotes/origin/*", "*", "", true)
    LibraryConfiguration lib = new LibraryConfiguration(libName, new SCMSourceRetriever(gitScmSource))
    lib.defaultVersion = defaultBranch
    lib.implicit = false
    lib.allowVersionOverride = true

    GlobalLibraries globalLibraries = GlobalLibraries.get()
    List libs = globalLibraries.getLibraries()

    boolean exists = false
    for (LibraryConfiguration libConfig : libs) {
        if (libConfig.getName() == libName) {
            exists = true
            break
        }
    }

    if (!exists) {
        logger.info("Initializing pipline library ${libName} (${gitUrl}:${defaultBranch})")
        List newLibs = new ArrayList(libs)
        newLibs.add(lib)
        globalLibraries.setLibraries(newLibs)
    }
}

def initProxy() {
    String httpProxyEnv = System.getenv("http_proxy")
    String httpsProxyEnv = System.getenv("https_proxy")
    String noProxyEnv = System.getenv("no_proxy")

    // delete potentially existing proxy.xml (we only use transient values derived from env vars)
    File proxyFile = new File(instance.getRootDir(), "proxy.xml")
    if(proxyFile.exists()) {
        logger.warning("Unexpected proxy.xml file detected. Trying to delete it...")
        deleteOrFail(proxyFile)
    }

    URL proxyUrl = null;
    if (httpsProxyEnv?.trim()) {
        proxyUrl = new URL(httpsProxyEnv)
    }

    // prefer https_proxy server over http_proxy
    if (!proxyUrl && httpProxyEnv?.trim()) {
        proxyUrl = new URL(httpProxyEnv)
    }

    String[] nonProxyHosts = null
    if ( noProxyEnv?.trim() && proxyUrl )  {
        /*
        Insert wildcards to have a rough conversion between the unix-like no-proxy list and the java notation.
        For example, `localhost,.corp,.maven.apache.org,x.y.,myhost` will be transformed to
        `[*localhost,*.corp,*.maven.apache.org,*x.y,*myhost]`.
        */

        nonProxyHosts = noProxyEnv.split(',')
                .collect { it.replaceFirst('\\.$', '')}
                .collect { "*${it}" };
    }

    if(proxyUrl) {
        Map credentials = extractCredentials(proxyUrl)
        String host = proxyUrl.getHost()
        int port = proxyUrl.getPort()

        logger.info("Setting Jenkins network proxy to ${host}:${port} ${!credentials ? "without" : ""} using credentials. No proxy patterns: ${nonProxyHosts}")
        instance.proxy = new ProxyConfiguration(host, port, credentials?.username, credentials?.password, nonProxyHosts.join("\n"))
    }
    else {
        logger.fine("No network proxy configured.")
        instance.proxy = null
    }
}

def extractCredentials(URL proxyURL) {
    def userInfo = proxyURL.getUserInfo()
    if(!userInfo) {
        return null
    }

    String[] splitted = userInfo.split(":")
    if(splitted.length != 2) {
        throw new Error("Failed to extract network proxy credentials. Expected format: 'http://myuser:mypass@myproxy.corp:8080'")
    }

    return [ username: URLDecoder.decode(splitted[0], "UTF-8"), password: URLDecoder.decode(splitted[1], "UTF-8") ]
}

def deleteOldInitFiles(){
    List oldFiles= [
        'init_s4sdk_library.groovy',
        'init_executors.groovy',
        'init_proxy.groovy'
    ]

    String initDirectory = "${System.getenv("JENKINS_HOME")}/init.groovy.d/"
    for (String fileName: oldFiles){
        File fileToDelete = new File(initDirectory, fileName)
        if(fileToDelete.exists()){
            logger.warning("Found old init file ${fileToDelete}, trying to delete file.")
            deleteOrFail(fileToDelete)
        }
    }
}

def deleteOrFail(File fileToDelete) {
    boolean success = fileToDelete.delete()
    if(success) {
        logger.info("Successfully deleted ${fileToDelete}")
    }
    else {
        throw new Error("Failed to delete ${fileToDelete}")
    }
}
