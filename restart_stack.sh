
# This script restarts Jenkins Master stack


echo Restarting Jenkins Master stack

echo Creating required dirs:
for i in /jenkins-common/shared $(pwd)/containers-data; do echo Creating dir: $i && mkdir -p $i && chmod -R 777 $i; done

echo Executing: docker-compose restart
docker-compose restart

echo Done