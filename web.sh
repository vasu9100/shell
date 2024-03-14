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

yum list installed | grep nginx &>>$LOGFILE

if [ $? -eq 0 ]
then
    echo -e " $Y NGINX ALREADY INSTALLED ..SKIPPING $N "
else
    dnf install nginx -y &>>$LOGFILE
    VALIDATE $? "NGINX INSTALLING"
fi



systemctl enable nginx
VALIDATE $? "ENABALED user ngnix"

systemctl start nginx
VALIDATE $? "STARTED OF nginx"

if [ -d /usr/share/nginx/html ]
then
    mkdir -p /tmp/BACKUP-html-$TIME_STAMP
    VALIDATE $? "LATEST BACKUP DIRECTORY CREATED"
    cp -r /usr/share/nginx/html/. /tmp/BACKUP-html-$TIME_STAMP
    VALIDATE $? "BACKUP TAKEN AND PLACED IN BACKUP FOLDER"
else
    echo -e "$R HTML FOLDER NOT FOUND $N"
fi       

rm -rf /usr/share/nginx/html/*
VALIDATE $? "REMOVED OLD HTML CONTENT"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip
VALIDATE $? "DOWLOADED THE LATEST HTML CONTENT"

cd /usr/share/nginx/html
VALIDATE $? "YOUR ARE IN HTML FOLDER"

unzip -o /tmp/web.zip
VALIDATE $? "UNZIPPING Web.zip"

cp /home/centos/shell/roboshop.conf /etc/nginx/default.d/roboshop.conf 
VALIDATE $? "COPYing roboshop.conf"

systemctl restart nginx 
VALIDATE $? "RESTARTED NGINX"





echo "SCRIPT EXCEUTION DONE AT $TIME_STAMP THANK YOU!"
