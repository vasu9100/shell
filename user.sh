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
        echo -e "$2.. $R FAILED $N"
        exit 1
    else
        echo -e  "$2...$N $G SUCESS $N" 
    fi
}

if [ $ID -eq 0 ]
then
    echo -e " $G SUCCESS:: YOUR ARE ROOT USER: $N "
else
    echo -e " $R ERROR:: YOUR ARE NOT ROOT USER: $N "
    exit 1 
fi

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "DISABLE CURRENT NODEJS"
dnf module enable nodejs:18 -y &>>$LOGFILE
VALIDATE $? "ENABLED NODE-JS:18"

yum list installed | grep nodejs &>>$LOGFILE

if [ $? -eq 0 ]
then
    echo -e " $Y NODE-JS ALREADY INSTALLED SO SKIIPING INSTALLATION $N "
else
    dnf install nodejs -y &>>$LOGFILE
    VALIDATE $? "NODEJS:18 INSTALLING"
fi

id roboshop &>>$LOGFILE

if [ $? -eq 0 ]
then
    echo -e " $R ROOSHOP USER ALREADY EXITSED $N ..$Y SKIPPING CREATION $N "
else
    useradd roboshop &>>$LOGFILE
    VALIDATE $? "ROBOSHOP USER CREATION"
fi

mkdir -p /app
VALIDATE $? "/app DIRECTORY CREATION"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>>$LOGFILE
VALIDATE $? "DOWNLOADING USER.ZIP"

cd /app 

unzip -o /tmp/user.zip &>>$LOGFILE
VALIDATE "UNZIPPING CODE"

npm install &>>$LOGFILE
VALIDATE "NPM INSTALLATION" &>>$LOGFILE

cp /home/centos/shell/user.service /etc/systemd/system/user.service
VALIDATE $? "COPYING  user.serive"

systemctl daemon-reload
VALIDATE $? "REALOD DAEMON"

systemctl enable user
VALIDATE $? "ENABALED user SERVICE"

systemctl start user
VALIDATE $? "STARTED OF user"

cp /home/centos/shell/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "mongo.repo COPYING"

mongo --version &>>$LOGFILE
if [ $? -eq 0 ]
then
    echo -e "$R MONGO SHELL ALREADY EXITSED $N ..$Y SKIPPING $N "
else
    dnf install mongodb-org-shell -y &>>$LOGFILE
    VALIDATE $? "MONGO SHELL INSTALLATION"
fi
mongo --host $MONGO_HOST </app/schema/user.js &>>$LOGFILE
VALIDATE $? "LOADING SCHEMA"

echo "SCRIPT EXCEUTION DONE AT $TIME_STAMP THANK YOU!"
