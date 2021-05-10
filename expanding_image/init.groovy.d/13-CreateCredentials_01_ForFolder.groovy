/*
* Configures single (username & password) credentials for a folder in global domain
*  if already exists a credentials with defined username - it will update it
*  if more than one exists - the first one it encounters will be updated
*/

import java.util.logging.Logger
import jenkins.model.*
import com.cloudbees.hudson.plugins.folder.*;
import com.cloudbees.hudson.plugins.folder.properties.*;
import com.cloudbees.hudson.plugins.folder.properties.FolderCredentialsProvider.FolderCredentialsProperty;
import com.cloudbees.plugins.credentials.impl.*;
import com.cloudbees.plugins.credentials.*;
import com.cloudbees.plugins.credentials.domains.*;

// Init
def logger = Logger.getLogger("")
jenkins = Jenkins.instance

String user_name = "ELBIT_NT\\evaint"
String user_pass = "407Nev1"
String description = "my desc"
String folderName = "Projects"


String id = java.util.UUID.randomUUID().toString()
Credentials cred = new UsernamePasswordCredentialsImpl(CredentialsScope.GLOBAL, id, "description: "+id, user_name, user_pass)

logger.info("Configuring domain credentials for folder: $folderName")
for (folder in jenkins.getAllItems(Folder.class)) {
    if(folder.name.equals(folderName)) {
        AbstractFolder<?> folderAbs = AbstractFolder.class.cast(folder)
        FolderCredentialsProperty property = folderAbs.getProperties().get(FolderCredentialsProperty.class)

        // If not defined FolderCredentialsProperty yet - define and finish
        if(property == null) {
            logger.info("Initializing folder credentials store and add credentials with username: $user_name in global store")
            property = new FolderCredentialsProperty([cred])
            folderAbs.addProperty(property)
            jenkins.save()
            return
        }

        // Check for existing credentials - and update their password & description
        //   will update the first credentials it encounters
        def credentials_store = property.getStore()
        List<com.cloudbees.plugins.credentials.Credentials> folderCredentialsList = property.getCredentials()
        for (creds in folderCredentialsList) {
            logger.info("Checking existing credentials of folder: $folderName for user: $user_name")
            if (creds.username.equals(user_name)) {
                // Found username - updating it
                //  Try to update the creds of the folder:
                def updateResult = credentials_store.updateCredentials(
                        com.cloudbees.plugins.credentials.domains.Domain.global(),
                        creds,
                        new UsernamePasswordCredentialsImpl(creds.scope, creds.id, description, creds.username, user_pass)
                )
                if (updateResult) {
                    logger.info("Updated credentials with username: $user_name")
                } else {
                    logger.warning("Failed to update credentials with username: $user_name")
                }
                jenkins.save()
                return
            }

        }

        logger.info("Didn't find credntials with username: $user_name - adding new one")

        // If got here - then:
        //  1. There is already a FolderCredentials property defined for folder: folderName
        //  2. didn't find any credentials(of username & password type) with username == user_name
        // so just add the new credentials
        property.getStore().addCredentials(Domain.global(), cred)
        jenkins.save()
        return
    }
}