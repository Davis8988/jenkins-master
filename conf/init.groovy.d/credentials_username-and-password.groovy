#!groovy

// imports
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.domains.Domain
import com.cloudbees.plugins.credentials.impl.*
import hudson.util.Secret
import jenkins.model.Jenkins


// parameters
credentialsObj = [
  description:  'Description here',
  id:           'key-id-here2',
  password:     '12345678901234567890',
  username:     'yess'
]

// func:
checkCredentialsExist = { user_id_or_name -> 
	
	// Get all creds obj
	def creds = com.cloudbees.plugins.credentials.CredentialsProvider.lookupCredentials(
        com.cloudbees.plugins.credentials.common.StandardUsernameCredentials.class,
        Jenkins.instance
    )
	
	def c = null
	// Check by id
	println "Checking if credentials with id: '$user_id_or_name exist' in Jenkins server"
	c = creds.findResult { it.id == user_id_or_name ? it : null }
	if (c) {return c}
	// println "Could not find credentials with id: '${user_id_or_name}'"
	
	println "Checking if credentials with username: '$user_id_or_name' exist in Jenkins server"
	c = creds.findResult { it.username == user_id_or_name ? it : null }
	if (c) {return c}
	// println "Could not find credentials with name: '${user_id_or_name}'"
	
	return null
}

// func:
updateCredentials = {cred, updateArr -> 
	def credentials_store = jenkins.model.Jenkins.instance.getExtensionList(
		'com.cloudbees.plugins.credentials.SystemCredentialsProvider'
		)[0].getStore()

	def result = credentials_store.updateCredentials(
		com.cloudbees.plugins.credentials.domains.Domain.global(), 
		cred, 
		new UsernamePasswordCredentialsImpl(cred.scope, updateArr.id, updateArr.description, updateArr.username, updateArr.password)
		)

	if (result) {
		println "Success - Updated credetials with username: '${updateArr.username}' and id: '${updateArr.id}'" 
	} else {
		println "Error - Failed to update credetials with username: '${updateArr.username}' and id: '${updateArr.id}'" 
	}
	
}


def createNewCreds = { credsArr ->
	// get Jenkins instance
	Jenkins jenkins = Jenkins.getInstance()

	// get credentials domain
	def domain = Domain.global()

	// get credentials store
	def store = jenkins.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

	// define cred object
	def jenkinsKeyUsernameWithPassword = new UsernamePasswordCredentialsImpl(
	  CredentialsScope.GLOBAL,
	  credsArr.id,
	  credsArr.description,
	  credsArr.username,
	  credsArr.secret
	)

	// add credential to store
	def result = store.addCredentials(domain, jenkinsKeyUsernameWithPassword)

	// save to disk
	jenkins.save()
}

def main() {
	def credExist = checkCredentialsExist('your-username-here')
	if (credExist) {
		println "Found credential with id: '${credExist.id}' and username: '${credExist.username}'"
		println "Updating it.."
		updateCredentials(credExist, credentialsObj)
		return
	} else {
		println "No credentials found with username: '${credentialsObj.userName}' and id: '${credentialsObj.id}'"
		println "Adding new ones.."
	}
}

// Start 
main()

