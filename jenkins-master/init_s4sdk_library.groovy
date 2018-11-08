import hudson.model.*
import jenkins.model.*
import jenkins.plugins.git.GitSCMSource
import org.jenkinsci.plugins.workflow.libs.*

createIfMissing("s4sdk-pipeline-library", "https://github.com/SAP/cloud-s4-sdk-pipeline-lib.git")
createIfMissing("piper-library-os", "https://github.com/SAP/jenkins-library.git")

def createIfMissing(String libName, String gitUrl) {
    GitSCMSource gitScmSource = new GitSCMSource(null, gitUrl, "", "origin", "+refs/heads/*:refs/remotes/origin/*", "*", "", true)
    LibraryConfiguration lib = new LibraryConfiguration(libName, new SCMSourceRetriever(gitScmSource))
    lib.defaultVersion = "master"
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
        libs.add(lib)
        globalLibraries.setLibraries(libs)
    }
}
