import com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl

def updatePassword(username, new_password) {
    def creds = com.cloudbees.plugins.credentials.CredentialsProvider.lookupCredentials(
            com.cloudbees.plugins.credentials.common.StandardUsernameCredentials.class,
            Jenkins.instance
    )

    def firstEncounteredCred = creds.findResult { it.username == username ? it : null }

    if ( firstEncounteredCred ) {
        println "found credential ${firstEncounteredCred.id} for username ${firstEncounteredCred.username}"

        def credentials_store = Jenkins.instance.getExtensionList(
                'com.cloudbees.plugins.credentials.SystemCredentialsProvider'
        )[0].getStore()

        def result = credentials_store.updateCredentials(
                com.cloudbees.plugins.credentials.domains.Domain.global(),
                firstEncounteredCred,
                new UsernamePasswordCredentialsImpl(firstEncounteredCred.scope, firstEncounteredCred.id, firstEncounteredCred.description, firstEncounteredCred.username, new_password)
        )

        if (result) {
            println "password changed for ${username}"
        } else {
            println "failed to change password for ${username}"
        }
    } else {
        println "could not find credential for ${username}"
    }
}

// Example usage: updatePassword('dp99662', 'asd')