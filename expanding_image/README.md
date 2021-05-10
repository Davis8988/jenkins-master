# An example of how to set up Jenkins in a fully automated way

This project builds a Docker image that contains a fully configured Jenkins by completely automating the configuration of Jenkins:

## How to start

```sh
docker run \
  --name auto-jenkins \
  --publish 8080:8080 \
  --detach \
  --restart always \
  nteptartifact:5014/jenkins:configured
```

In its default state, auto-jenkins has a single job called `seed-job` that creates the other jobs listed in the file
`job.groovy.override`. Simply run the seed job to initialize the other jobs.

Once it is completed, you should see all jobs listed on auto-jenkins' dashboard. auto-jenkins should be ready to be used:
run your newly added job and ensure Jenkins is behaving correctly.

See https://github.com/jenkinsci/docker#usage for more information and options.


## How to configure Jenkins

All configuration is done using Groovy scripts located in `src/main/resources/docker/init.groovy.d`. Use the
[Jenkins Javadoc](http://javadoc.jenkins.io/) as a reference.


### Environment variables

Some Groovy scripts use environment variables to make it easy to **configure** the container. The following table lists the
most common environment variables.

Environment variable | Description
--- | ---
JENKINS_NAME | Will appear in System Message
JENKINS_ADMIN_PASSWORD | The admin's password
JENKINS_ADMIN_EMAIL | The admin's e-mail address
JENKINS_PROXY_HOST | Proxy host 
JENKINS_PROXY_PORT | Proxy port 
JENKINS_NO_PROXY_HOSTS | No proxy hosts
JENKINS_BASE_URL | The base URL of Jenkins
JENKINS_MASTER_EXECUTORS | The number of executors for the master
JENKINS_SLAVEPORT | Port for slaves to connect to
SMTP_HOST | SMTP server hostname
SMTP_PORT | SMTP server port number
MAIL_CHARSET | Charset of mailing. Default 'UTF-8'
JENKINS_GITLAB_USER_NAME | gitlab username
JENKINS_GITLAB_USER_PASS | gitlab password
JENKINS_GITLAB_USER_PRIVATE_KEY | gitlab private key
SONAR_SERVER_NAME | Name of SonarQube server installation
SONAR_SERVER_URL | Example: http://sonarqube:9000
SONAR_SERVER_TOKEN | Name of secret-text credentials type. Used as server authentication token


## How to add a new job

1. Clone the repository
   ```sh
   git clone git@github.com:depositsolutions/jenkins-automation.git
   ```
2. Locate the file `job.groovy.override` and add your repository to the list of `projectDefinitions`.


## How to add a plugins

1. Just modify the file `plugins.txt` file. See also https://github.com/jenkinsci/docker#preinstalling-plugins for more
information.

2. Another way:  
	Download all matching plugins:  
	
	* Execute this groovy script at 'http://jenkinsServer:8080/script'  
	```groovy
	import jenkins.model.Jenkins
	def instance = Jenkins.instance
	instance.setCrumbIssuer(null)
	```
	* Then write your plugins to a file: `plugins.txt` with content in the format of: '{pluginName}@current' in each line. Example:  
	```text
	ant@current
	antisamy-markup-formatter@current
	bouncycastle-api@current
	build-metrics@current
```
	
	* Then start your jenkins master server with the desired version and execute this script to tell it to download the plugins:  
	```bat
	for /f %%a in (plugins.txt) do (
		echo Executing: curl --verbose --location --insecure --request POST --data "<jenkins><install plugin='%%a' /></jenkins>" --user "admin":"admin" --header "Content-Type: text/xml" --url "http://localhost:8080/pluginManager/installNecessaryPlugins"
		curl --verbose --location --insecure --request POST --data "<jenkins><install plugin='%%a' /></jenkins>" --user "admin":"admin" --header "Content-Type: text/xml" --url "http://localhost:8080/pluginManager/installNecessaryPlugins"
	)
	```

### 


## Literature

* [Jenkins Job DSL API](https://jenkinsci.github.io/job-dsl-plugin/)
* [Pipeline Steps Reference](https://jenkins.io/doc/pipeline/steps/)
* [Jenkins Javadoc](http://javadoc.jenkins.io/)

