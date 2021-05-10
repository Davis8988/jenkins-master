# Jenkins-Master

Start bunch of Jenkins Masters configured using docker-compose

## Getting Started
* Clone this repo
* Configure docker-compose.yml
* login to Artifactory: ```docker login nteptartifact:5014```


## Run 
Create directory and then execute start_stack.sh
```
mkdir -p /jenkins-common/shared  
chmod +x start_stack.sh && ./start_stack.sh
```

## Backup/Rebuild Jenkins Master Stack docker images
To re-build the Jenkins-Master docker images clone this repo to a machine that runs the Jenkins-Master stack and then execute:  
```
cd backups  
chmod +x ./create_backup_images.sh && ./create_backup_images.sh  
```


## Build Configured Image
To build a new configured image edit the following:
* Configuration scripts are at: expanding_image/init.groovy.d
* Plugins list: expanding_image/jenkins_plugins/plugins.txt  
* Define KEYTOOL_PASSWORD variable  

CD into repo root dir and execute:
```
./build_jenkins_master_docker_image.sh "--build-arg KEYTOOL_PASSWORD=$KEYTOOL_PASSWORD"
```


