#!groovy

// imports
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.domains.Domain
import com.cloudbees.plugins.credentials.impl.*
import hudson.util.Secret
import jenkins.model.Jenkins


// parameters
def jenkinsKeyUsernameWithPasswordParameters = [
  description:  'Rebuilder user',
  id:           'rebuilder',
  pass:         '12345678',
  userName:     'rebuilder'
]

// get Jenkins instance
Jenkins jenkins = Jenkins.getInstance()

// get credentials domain
def domain = Domain.global()

// get credentials store
def store = jenkins.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

// define cred object
def jenkinsKeyUsernameWithPassword = new UsernamePasswordCredentialsImpl(
  CredentialsScope.GLOBAL,
  jenkinsKeyUsernameWithPasswordParameters.id,
  jenkinsKeyUsernameWithPasswordParameters.description,
  jenkinsKeyUsernameWithPasswordParameters.userName,
  jenkinsKeyUsernameWithPasswordParameters.secret
)

// add credential to store
def result = store.addCredentials(domain, jenkinsKeyUsernameWithPassword)
if (result.toBoolean()) {
	print "Success - Added user: " + jenkinsKeyUsernameWithPasswordParameters.userName
} else {
	print "Error - Failed to add user: " + jenkinsKeyUsernameWithPasswordParameters.userName
}

// save to disk
jenkins.save()