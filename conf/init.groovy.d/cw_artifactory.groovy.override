import java.lang.System
import hudson.model.*
import jenkins.model.*
import org.jfrog.*
import org.jfrog.hudson.*
import org.jfrog.hudson.util.Credentials;

def env = System.getenv()
def inst = Jenkins.getInstance()
def artifactoryDesc = inst.getDescriptor("org.jfrog.hudson.ArtifactoryBuilder")


println "--> Configuring Artifactory... "

def getServerDeployerCredentials(String userId) {
	if (userId) {
		return new CredentialsConfig("", "", userId, false)
	}
	return new CredentialsConfig("", "", "", false)
}

def getServerResolverCredentials(String userId) {
	if (userId) {
		return new CredentialsConfig("", "", userId, false)
	}
	return new CredentialsConfig("", "", "", false)
}


println "Artifactory Params:\n" +
		" ARTIFACTORY_SERVER_ID=" + env.ARTIFACTORY_SERVER_ID +"\n" +
		" ARTIFACTORY_SERVER_URL=" + env.ARTIFACTORY_SERVER_URL +"\n" +
		" ARTIFACTORY_SERVER_TIMEOUT_SEC=" + env.ARTIFACTORY_SERVER_TIMEOUT_SEC +"\n" +
		" ARTIFACTORY_SERVER_BYPASS_PROXY=" + env.ARTIFACTORY_SERVER_BYPASS_PROXY +"\n" +
		" ARTIFACTORY_SERVER_CONNECTION_RETRY=" + env.ARTIFACTORY_SERVER_CONNECTION_RETRY +"\n" +
		" ARTIFACTORY_SERVER_DEPLOYER_USER_ID=" + env.ARTIFACTORY_SERVER_DEPLOYER_USER_ID +"\n" +
		" ARTIFACTORY_SERVER_RESOLVER_USER_ID=" + env.ARTIFACTORY_SERVER_RESOLVER_USER_ID


String artiServ_ID                              = env.ARTIFACTORY_SERVER_ID                   ? env.ARTIFACTORY_SERVER_ID                               : "my-artifactiory"
String artiServ_Url                             = env.ARTIFACTORY_SERVER_URL                  ? env.ARTIFACTORY_SERVER_URL                              : "https://servername:8443/artifactory"
Integer artiServ_timeoutSec                     = env.ARTIFACTORY_SERVER_TIMEOUT_SEC          ? env.ARTIFACTORY_SERVER_TIMEOUT_SEC.toInteger()          : 20
Boolean artiServ_bypassProxy                    = env.ARTIFACTORY_SERVER_BYPASS_PROXY         ? env.ARTIFACTORY_SERVER_BYPASS_PROXY.toBoolean()         : false
Integer artiServ_connectionRetry                = env.ARTIFACTORY_SERVER_CONNECTION_RETRY     ? env.ARTIFACTORY_SERVER_CONNECTION_RETRY.toString().toInteger()     : 3
Integer artiServ_deployThreadsCount             = env.ARTIFACTORY_SERVER_DEPLOY_THREADS_COUNT ? env.ARTIFACTORY_SERVER_DEPLOY_THREADS_COUNT.toInteger() : 10
CredentialsConfig artiServ_deployerCredentials  = getServerDeployerCredentials(env.ARTIFACTORY_SERVER_DEPLOYER_USER_ID)
CredentialsConfig artiServ_resolverCredentials  = getServerDeployerCredentials(env.ARTIFACTORY_SERVER_RESOLVER_USER_ID)



def ArtInst = [new ArtifactoryServer(
   artiServ_ID,
   artiServ_Url,
   artiServ_deployerCredentials,
   artiServ_resolverCredentials,
   artiServ_timeoutSec,
   artiServ_bypassProxy,
   artiServ_connectionRetry, 
   artiServ_deployThreadsCount)
]

artifactoryDesc.setArtifactoryServers(ArtInst)
artifactoryDesc.setUseCredentialsPlugin(true)
artifactoryDesc.save()
println "--> Configuring Artifactory... done"