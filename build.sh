
shouldPush=$1

echo [Info] Building jenkins-master image

echo [Info] Stopping running container: jenkins-master
docker stop jenkins-master

echo [Info] Getting new code:
git checkout configure/users
git pull
 
echo [Info] Building image:
docker build -t davis8988/jenkins-master . 

echo [Info] Tagging:
docker tag davis8988/jenkins-master davis8988/jenkins-master:configured-2.194-lts 

if [ -z "$shouldPush" ]; then echo [Info] Pushing:; docker push davis8988/jenkins-master:configured-2.194-lts; fi

echo [Info] Removing old stopped container: jenkins-master
docker rm -f jenkins-master

echo [Info] Running new container: jenkins-master
export contid=$(docker run -d --name jenkins-master -p 8080:8080 davis8988/jenkins-master:configured-2.194-lts)

echo [Info] Reading logs:
docker logs -f $contid

echo [Info]
Finished
