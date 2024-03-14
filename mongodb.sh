#!/bin/bash

ID=$(id -u)
TIME_STAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIME_STAMP.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "Script started TIME: $TIME_STAMP"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e " $2...$R INSTALLATION FAILED $N"
        exit 1
    else
        echo -e " $2... $G INSTALLATION SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "ERROR:: $R YOUR NOT A ROOT USER $N "
    exit 1
else
    echo -e  "$G YOUR ARE A ROOT USER SHELL SCRIPT STARTS RUNNING $N"
fi
cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "COPYING mongo.repo"

yum list installed | grep mongodb

if [ $? -ne 0 ]
then
    dnf install mongodb-org -y
    VALIDATE $? "MONGO DB"
else
    echo -e "MONGO DB IS ALREADY INSTALLED.. $Y SKIIPING INSTALLATION $N" 
fi

systemctl enable mongod
VALIDATE $? "ENABLING MONGO-DB"

systemctl start mongod
VALIDATE $? "STARTING MONGO-DB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "127.0.0.1 IS REPALACED"

systemctl restart mongod
VALIDATE $? "RESTARTED MONGODB"

echo "SCRIPT EXCEUTION DONE AT $TIME_STAMP THANK YOU!"
