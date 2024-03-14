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
VALIDATE $? "REDIS INSTALLATION"
dnf module enable redis:remi-6.2 -y
VALIDATE $? "REDIS 6.2 ENABLED"

rpm -qa | grep redis
if [ $? -eq 0 ]
then
    echo -e " $R REDIS ALREADY INSTALLED $N ..$Y SKIPPING $N "
else
    dnf install redis -y
    VALIDATE $? "REDIS INSTALLATION"    
fi   

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf
VALIDATE $? "127.0.0.1 REPLACED BY  0.0.0.0"

systemctl enable redis
VALIDATE $? "REDIS ENABLED"

systemctl start redis
VALIDATE $? "REDIS START"

echo -e "PLEASE VERIFY LOCAL IP STATUS BELOW"

netstat -lntp

echo "SCRIPT EXCEUTION DONE AT $TIME_STAMP THANK YOU!"