import jenkins.model.*
import java.util.logging.Logger

// Init
def instance = Jenkins.getInstance()
def logger = Logger.getLogger("")
def env = System.getenv()
String jenkinsName = env.JENKINS_NAME
if (jenkinsName) {
    String msg = "<h1>Jenkins $jenkinsName</h1>"

    logger.info("Setting System Message: Jenkins $jenkinsName")
    instance.setMarkupFormatter(new hudson.markup.RawHtmlMarkupFormatter(false))
    instance.setSystemMessage(msg)
    instance.save()
}

