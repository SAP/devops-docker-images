import jenkins.model.*

def instance = Jenkins.instance

if(instance.getNumExecutors() < 6) {
    instance.setNumExecutors(6)
}
