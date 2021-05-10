
# This script builds Jenkins Master Configured Docker Image

DOCKER_IMAGE_TAG=artifactory.esl.corp.elbit.co.il/aerospace-simulators-devops-docker/jenkins/master:2.213-centos7-configured
BUILD_COMMAND_OPTS=$1
DOCKER_FILE=dockerfile

echo Building Jenkins Master Docker Image

echo Executing: 
echo  docker build . -t $DOCKER_IMAGE_TAG -f $DOCKER_FILE --add-host=artifactory.esl.corp.elbit.co.il:10.0.50.35 --add-host=updates.jenkins-ci.org:10.0.50.49 $BUILD_COMMAND_OPTS
echo ''

docker build . -t $DOCKER_IMAGE_TAG -f $DOCKER_FILE --add-host=artifactory.esl.corp.elbit.co.il:10.0.50.35 --add-host=updates.jenkins-ci.org:10.0.50.49 $BUILD_COMMAND_OPTS
if [ "$?" != "0" ]; then echo '' && echo Error - Failed building jenkins master docker image && exit 1; fi

echo Done