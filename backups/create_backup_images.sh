
# This backs-up all jenkins-master container images by building an image with already created content of the jenkins images
# 
# To get a list of all container names:
#  docker inspect -f '{{ .Name }}' $(docker ps -aq)
# 

echo Creating backup images of all jenkins-master containers
export CLEAN_DOCKER_IMAGES=$1
export jenkinsCommonPluginDir=/jenkins-common/plugins

function backup_jenkins_master_container() {
		container_name=$1
		dockerTag=$2
		echo "----------------------------------------------------------"
		
		echo container_name=$container_name
		echo dockerTag=$dockerTag
		
		if [ ! "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then echo Error - Container $container_name is not running!; echo Aborting..; exit 1; fi
		
		echo Backing up container: $container_name
		
		# Remove old _data if exist
		[ -d _data ] && echo Removing old _data dir && rm -rf _data/*
		[ ! -d _data ] && echo Re-creating _data dir && mkdir -p _data
				
		# Get mapped volumes:
		for vol_path in $(docker inspect -f '{{ json .Mounts }}' $container_name | jq .[].Source); do
			if [[ ! $vol_path == *"var/lib/docker/volumes"* ]]; then continue; fi
			# Removing quotes "
			vol_path="${vol_path%\"}"
			vol_path="${vol_path#\"}"
			
			echo Copying volume: $vol_path/* to: _data/*
			rsync -aqm --stats --exclude 'builds' --exclude 'nextBuildNumber' $vol_path/* _data/
			if [ "$?" != "0" ]; then echo Error - Failed to copy $vol_path; echo Aborting..; exit 1; fi
			break
		done
		
		if [ -d "$jenkinsCommonPluginDir" ]; then
			echo Copying plugins: $jenkinsCommonPluginDir/* to: _data/plugins/	
			rsync -aqm --stats --include '*.jpi' --include '*.hpi' --include '*.bak' $jenkinsCommonPluginDir/* _data/plugins/
			if [ "$?" != "0" ]; then echo Error - Failed to copy $jenkinsCommonPluginDir/* to: _data/plugins/; echo Aborting..; exit 1; fi
		fi
		
		echo Giving permissions
		chmod 777 -R _data
		
		echo Building jenkins-master docker image 
		docker build --pull -t "$dockerTag" --build-arg PROJECT_NAME=$container_name --build-arg BACKUP_DATE=$(date +'%Y-%m-%d') -f "jenkins_backup_dockerfile" _data
		if [ "$?" != "0" ]; then echo Error - Failed building image: $dockerTag; echo Aborting..; exit 1; fi
		echo ""
		
		echo Pushing..
		docker push $dockerTag
		if [ "$?" != "0" ]; then echo Error - Failed to push image: $dockerTag; echo Aborting..; exit 1; fi
		
		if [ "$CLEAN_DOCKER_IMAGES" == "CleanDockerImages" ]; then
			echo Cleaning docker image
			docker rmi $dockerTag
		fi
		
		echo Finished backing up container: $container_name
		echo ""
}

backup_jenkins_master_container "JENKINS-IOS"             "nteptartifact:5014/jenkins/master:ios" 
backup_jenkins_master_container "JENKINS-InterOp"         "nteptartifact:5014/jenkins/master:interop"
backup_jenkins_master_container "JENKINS-IG-WINDOWS"      "nteptartifact:5014/jenkins/master:ig"
backup_jenkins_master_container "JENKINS-Grafana-MongoDB" "nteptartifact:5014/jenkins/master:grafana-mongodb"
backup_jenkins_master_container "JENKINS-OneSIM-Lab-Conf" "nteptartifact:5014/jenkins/master:onesim-lab"
backup_jenkins_master_container "JENKINS-embedded"        "nteptartifact:5014/jenkins/master:embedded"
backup_jenkins_master_container "JENKINS-SiteManagement"  "nteptartifact:5014/jenkins/master:site-management"
backup_jenkins_master_container "JENKINS-SimEngine"       "nteptartifact:5014/jenkins/master:simengine"
backup_jenkins_master_container "JENKINS-DEVOPS_TESTBED"  "nteptartifact:5014/jenkins/master:devops-testbed"
backup_jenkins_master_container "ONECGF_JENKINS"          "nteptartifact:5014/jenkins/master:onecgf"

# Remove old _data if exist
echo Cleaning up
[ -d _data ] && echo Removing _data dir && rm -rf _data/*

	

echo Done backing up