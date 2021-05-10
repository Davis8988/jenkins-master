#!/bin/bash
# ^ Tells the shell to interpret this script using /bin/bash app

# This script start jenkins-master container with mapped plugins dir 
#  to local plugins dir in the host

# Defaults
jenkinsImage=nteptartifact:5014/jenkins/master
jenkinsTag=no_plugins
containerPluginsDir=/var/jenkins_home/plugins
containerJobsDir=/var/jenkins_home/jobs


# Assign mandatory arguments
jenkinsAccessPort=$1
slaveAccessPort=$2
localPluginsDir=$3
localJobsDir=$4


# Check received args:
checkReceivedArgs() {
	echo -e  "[Checking] - Received arguments.."
	[ -z $jenkinsAccessPort ] && echo -e "[Error] First arg: jenkinsAccessPort - is missing.\n\n${usageStr}" && exit 1
	[ -z $slaveAccessPort ] && echo -e "[Error] Second arg: slaveAccessPort - is missing.\n\n${usageStr}" && exit 1
	[ -z $localPluginsDir ] && echo -e "[Error] Third arg: localPluginsDir - is missing.\n\n${usageStr}" && exit 1
	
	# If plugins dir doesn't exist - print error and exit the script
	if ! (dirExists $localPluginsDir); then echo -e "\nLocal plugins directory '${localPluginsDir}' DOES NOT exists.\n" && exit 1; fi
	if [ ! -z $localJobsDir ]; then if ! (dirExists $localJobsDir); then echo -e "\nLocal jobs directory '${localPluginsDir}' DOES NOT exists.\n" && exit 1; fi; fi
	
	echo -e  "[Success] - Finished checking. Received arguments are ok"
}


prepareEnv() {
	# For errors nad usage:
	usageStr="[Info] - Usage:\n Run this script with 3 mandatory arguments\n"
	usageStr+="  1 - Jenkins access port (8080)\n"
	usageStr+="  2 - Slave access port (50000)\n"
	usageStr+="  3 - Local Plugins dir path (/var/dir2/plugins)\n"
	usageStr+="  4 - [OPTIONAL] Local Jobs dir path (/var/dir2/jobs)\n"
	usageStr+=" Example 1 - start_jenkins_master_no_plugins.sh 8080 50000 /var/dir2/plugins\n"
	usageStr+=" Example 2 - start_jenkins_master_no_plugins.sh 8080 50000 /var/dir2/plugins /var/dir2/jobs\n"

}


# Print Args:
printReceivedArgs() {
	receivedArgsStr="[Info] - Received Arguments:\n"
	receivedArgsStr+=" - jenkinsAccessPort='${jenkinsAccessPort}'\n"
	receivedArgsStr+=" - slaveAccessPort='${slaveAccessPort}'\n"
	receivedArgsStr+=" - localPluginsDir='${localPluginsDir}'\n"
	if [ ! -z $localJobsDir ]; then receivedArgsStr+=" - localJobsDir='${localJobsDir}'\n"; fi
	echo -e "$receivedArgsStr"
}

dirExists() {
  echo -e "[Checking] - Dir '$1' exists"
  if [ -d "$1" ]
  then
    # 0 = true
    return 0 
  else
    # 1 = false
    return 1
  fi
}

startJenkinsMasterWithMappedPluginsDir() {
	echo -e "[Info] - Starting jenkins-master container in background..."
	# Check if 4th argument is empty:
	if [ -z $localJobsDir ]
	then 
		echo -e "[Info] - Running Command: \ndocker run -d -p $jenkinsAccessPort:8080 -p $slaveAccessPort:$slaveAccessPort -v $localPluginsDir:$containerPluginsDir $jenkinsImage:$jenkinsTag"
		docker run -d --restart unless-stopped -p $jenkinsAccessPort:8080 -p $slaveAccessPort:$slaveAccessPort -v $localPluginsDir:$containerPluginsDir $jenkinsImage:$jenkinsTag
	else 
		echo -e "[Info] - Running Command: \ndocker run -d -p $jenkinsAccessPort:8080 -p $slaveAccessPort:$slaveAccessPort -v $localPluginsDir:$containerPluginsDir -v $localJobsDir:$localJobsDir $jenkinsImage:$jenkinsTag"
		docker run -d --restart unless-stopped -p $jenkinsAccessPort:8080 -p $slaveAccessPort:$slaveAccessPort -v $localPluginsDir:$containerPluginsDir -v $localJobsDir:$containerJobsDir $jenkinsImage:$jenkinsTag
	fi
	sleep 3
}


main() {
	echo -e "[Info] - Main Started"
	
	prepareEnv
	printReceivedArgs
	checkReceivedArgs
	startJenkinsMasterWithMappedPluginsDir
	
	echo -e "[Info] - Main Finished"
}

# Start Main
main


