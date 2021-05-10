while read p; do
	echo Executing: 
	echo curl --verbose --location --insecure --request POST --data "<jenkins><install plugin='$p' /></jenkins>" --user 'admin':'admin' -H 'Jenkins-Crumb: 634279dd30a7190c9d839ada18b7e454f72f913d4398eac293b5ff49e2e497a3' --header 'Content-Type: text/xml' --url 'http://localhost:8080/pluginManager/installNecessaryPlugins'
	echo '<jenkins><install plugin="$p" /></jenkins>'
    curl --verbose --location --insecure --request POST --data "<jenkins><install plugin='$p' /></jenkins>" --user 'admin':'admin' -H 'Jenkins-Crumb: 634279dd30a7190c9d839ada18b7e454f72f913d4398eac293b5ff49e2e497a3' --header 'Content-Type: text/xml' --url 'http://localhost:8080/pluginManager/installNecessaryPlugins'
  
done <plugins.txt

echo ''
echo Finished
read