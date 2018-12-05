import hudson.model.*
import jenkins.model.*
import jenkins.plugins.git.GitSCMSource
import org.jenkinsci.plugins.workflow.libs.*

deleteOldInitFiles()
setupExecutors()
initLibraries()

def deleteOldInitFiles(){
    List oldFiles= [
        'init_s4sdk_library.groovy',
        'init_executors.groovy'
    ]

    String initDirectory = "${System.getenv("JENKINS_HOME")}/init.groovy.d/"
    for (String fileName: oldFiles){
        File fileToDelete = new File("${initDirectory}/${fileName}")
        if(fileToDelete.exists()){
            fileToDelete.delete()
        }
    }

}

def setupExecutors(){
    def instance = Jenkins.instance

    if(instance.getNumExecutors() < 6) {
        instance.setNumExecutors(6)
    }
}

def initLibraries(){
    def env = System.getenv()

    String piperLibraryOsUrl = env.PIPER_LIBRARY_OS_URL ?: "https://github.com/SAP/jenkins-library.git"
    String piperLibraryOsBranch = env.PIPER_LIBRARY_OS_BRANCH ?: "master"
    createIfMissing("piper-lib-os", piperLibraryOsUrl, piperLibraryOsBranch)
    
    String s4sdkLibraryUrl = env.S4SDK_LIBRARY_URL ?: "https://github.com/SAP/cloud-s4-sdk-pipeline-lib.git"
    String s4sdkLibraryBranch = env.S4SDK_LIBRARY_BRANCH ?: "master"
    createIfMissing("s4sdk-pipeline-library", s4sdkLibraryUrl, s4sdkLibraryBranch)
}

def createIfMissing(String libName, String gitUrl, String defaultBranch) {
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
        newLibs = new ArrayList(libs)
        newLibs.add(lib)
        globalLibraries.setLibraries(newLibs)
    }
}
