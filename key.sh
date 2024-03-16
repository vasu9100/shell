#!/bin/bash
ID=$(id -u)
USER_NAME="centos"
PASSWORD="DevOps321"
IP_ADDRESS=(
    "172.31.18.95"
    "172.31.24.196" 
    "172.31.17.143" 
    "172.31.6.195" 
    "172.31.5.226" 
    "172.31.28.146" 
    "172.31.27.233" 
    "172.31.9.162"
    "172.31.28.58"
    "172.31.27.103"
    "172.31.17.227" )
# Specify the filename for the SSH key
SSH_KEY_FILE="$HOME/.ssh/vasu_pub"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo "$2...FAILED"
    else
        echo "$2...SUCCESS"
    fi      
}

if [ $ID -ne 0 ]
then
    echo "YOU'RE NOT ROOT USER"
    exit 1
fi    

# Check if the SSH key file exists
if [ -f "$SSH_KEY_FILE" ]; then
    echo "SSH key already exists: $SSH_KEY_FILE SKIPPING"
else
    # Generate SSH key pair
    ssh-keygen -t rsa -b 4096 -f "$SSH_KEY_FILE"
    echo "SSH key generated: $SSH_KEY_FILE"
fi

for ip in "${IP_ADDRESS[@]}"
do
    sshpass -p "PASSWORD" scp "$SSH_KEY_FILE.pub" "$USER_NAME"@"$ip":~/
    VALIDATE $? "COPIED PUBLIC KEY to $ip"       
done