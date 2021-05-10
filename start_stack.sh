
# This script starts Jenkins Master stack


#  This section below tries to extract the ip address. It must have the right interface name though..
#  run 'ifconfig' and see what is the desired interface name

#ADAPTER_NAME=enp0s8
# ADAPTER_NAME=eth0
DEFAULT_ADAPTER_NAME=ens192
export ADATPER_NAME_TO_EXTRACT_FROM=${ADAPTER_NAME:-$DEFAULT_ADAPTER_NAME}
echo "Attempting to retrieve ip address of interface: '${ADATPER_NAME_TO_EXTRACT_FROM}' to embed it in jenkins server base-url address"
export HOST_IP_ADDR=$(ip -4 addr show ${ADATPER_NAME_TO_EXTRACT_FROM} | grep -oP "(?<=inet )[\d\.]+(?=/)")
if [ -z "$HOST_IP_ADDR" ]; then 
    echo""; echo "Error - Failed to retrieve ip address of interface: '${ADATPER_NAME_TO_EXTRACT_FROM}'"; echo " Maybe it's not the right interface name?" 
    echo " Execute 'ifconfig' and see what is the right interface name"
    echo "  and re-execute this script again. Example: "; echo ""; echo "  ADAPTER_NAME=eth08 ./start_stack.sh"; echo ""
    if [ ! -z "$ADAPTER_NAME" ]; then exit 1; else echo "Continuing anyway.. "; echo ""; fi 
else
    echo "Found host ip: '$HOST_IP_ADDR'. Mapping jenkins base-url address to it"
fi


echo Starting Jenkins Master stack

echo Creating required dirs:
for i in /jenkins-common/shared $(pwd)/containers-data; do echo Creating dir: $i && mkdir -p $i && chmod -R 777 $i; done

echo Executing: docker-compose up -d
JENKINS_ADMIN_PASSWORD=Abcd1234 docker-compose up -d 

echo Done