## Standalone Jenkins Server

Starts a single Jenkins Master container without plugins
Plugins dir would be mapped to a plugins dir on the host 
that would contain the plugins

## Getting Started
* Clone this repo and CD into it


## Run 
Pass parameters to the script:
1. User Access Port
2. Slave Access Port
3. `Absolute path` to local-**plugins-dir**  to map to 
4. `Absolute path` to local-**jobs-dir**  to map to [OPTIONAL] <br>

Start a jenkins-master container with your host plugin dir mapped:

```
./start_jenkins_master_no_plugins.sh 8080 50000 /var/home/myJenkinsPlugins
```

Start another container, with the same plugins directory:

```
./start_jenkins_master_no_plugins.sh 8081 50001 /var/home/myJenkinsPlugins
```

Start container, with a plugins directory and a jobs dir:

```
./start_jenkins_master_no_plugins.sh 8082 50002 /var/home/myJenkinsPlugins /var/home/my_jobs
```

## Troubleshooting 

1. If getting error `Unable to find image 'nteptartifact:5014/jenkins/master:no_plugins' locally
docker: Error response from daemon: Get http://nteptartifact:5014/v2/jenkins/manifests/no_plugins: unauthorized: BAD_CREDENTIAL.`
then you need to login to elbit artifactory docker image registery: 
```
docker login nteptartifact:5014
``` 
enter your username and password and wait for message `Login Succeeded`