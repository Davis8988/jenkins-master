def creds_types_arr = [com.cloudbees.plugins.credentials.common.CertificateCredentials.class,
                       com.cloudbees.plugins.credentials.common.IdCredentials.class,
                       com.cloudbees.plugins.credentials.common.PasswordCredentials.class,
                       com.cloudbees.plugins.credentials.common.StandardCertificateCredentials.class,
                       com.cloudbees.plugins.credentials.common.StandardCredentials.class,
                       com.cloudbees.plugins.credentials.common.StandardUsernameCredentials.class,
                       com.cloudbees.plugins.credentials.common.StandardUsernamePasswordCredentials.class,
                       com.cloudbees.plugins.credentials.common.UsernameCredentials.class,
                       com.cloudbees.plugins.credentials.common.UsernamePasswordCredentials.class,
]
creds_types_arr.each { creds_type ->
    println "Creds of type: $creds_type"
    def creds = com.cloudbees.plugins.credentials.CredentialsProvider.lookupCredentials(
            creds_type,
            Jenkins.instance,
            null,
            null
    );
    for (c in creds) {
        println(c.id + ": " + c.description)
    }
    println "-------"
}
