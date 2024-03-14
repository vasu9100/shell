#!/bin/bash

ID=$(id -u)
TIME_STAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIME_STAMP.log"
MONGO_HOST="mongodb.gonepudirobot.online"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "Script started TIME: $TIME_STAMP"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$Y $2...$N $R FAILED $N"
        exit 1
    else
        echo -e  "$Y $2...$N $G SUCESS $N" 
    fi
}

if [ $ID -eq 0 ]
then
    echo -e " $G SUCCESS:: YOUR ARE ROOT USER: $N "
else
    echo -e " $R ERROR:: YOUR ARE NOT ROOT USER: $N "
    exit 1 
fi

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
