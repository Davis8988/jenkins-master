@echo off

:: Disable crumb
REM import jenkins.model.Jenkins
REM def instance = Jenkins.instance
REM instance.setCrumbIssuer(null)



REM set crumb=
echo Getting crumb

pushd "%~dp0"

REM echo Getting crumb
REM for /f %%a in ('curl -v -X GET http://localhost:8080/crumbIssuer/api/json --user admin:admin ^| jq .crumb') do (call :SET_CRUMB %%a)

REM curl --verbose --location --insecure --request POST --data "<jenkins><install plugin='%%a' /></jenkins>" --header "Jenkins-Crumb:%crumb%" --url "http://localhost:8080/pluginManager/installNecessaryPlugins"

echo crumb="%crumb%"
pause
for /f %%a in (plugins.txt) do (
	echo Executing: curl --verbose --location --insecure --request POST --data "<jenkins><install plugin='%%a' /></jenkins>" --user "admin":"admin" --header "Content-Type: text/xml" --url "http://localhost:8080/pluginManager/installNecessaryPlugins"
	curl --verbose --location --insecure --request POST --data "<jenkins><install plugin='%%a' /></jenkins>" --user "admin":"admin" --header "Content-Type: text/xml" --url "http://localhost:8080/pluginManager/installNecessaryPlugins"
)

echo Finished
pause
exit


:SET_CRUMB
set crumb=%~1
EXIT /B

