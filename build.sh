
shouldPush=$1

echo [Info] Building jenkins-master image

echo [Info] Getting new code:
git pull
 
echo [Info] Building image:
docker build -t davis8988/jenkins-master . 

echo [Info] Tagging:
docker tag davis8988/jenkins-master davis8988/jenkins-master:configured-2.194-lts 

if [ ! -z "$shouldPush" ]; then echo [Info] Pushing:; docker push davis8988/jenkins-master:configured-2.194-lts; fi

echo [Info] Running container: jenkins-master
docker-compose up -d

echo [Info] Reading logs:
docker logs -f jenkins-master

echo [Info]
Finished
