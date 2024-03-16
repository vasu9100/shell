#!/bin/bash

ID=$(id -u)

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
    echo "YOUR NOT A ROOT USER"
    exit 1
fi   

if [ -d /home/centos/.ssh ]
then
    echo "KEY ALREADY EXISTIED  So SKIPPING TO KEY CREATION"
else
   ssh-keygen -t rsa -f /home/centos/rsa_key 
   VALIDATE $? "SSH-KEY-GENERATION"
fi