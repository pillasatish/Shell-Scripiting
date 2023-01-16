#!/bin/bash

set -e #exit the code if any one of the below code is not executed
COMPONENT=reddis
LOGFILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"


source components/common.sh

echo -n "Configuring the $COMPONENT repo: "
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>$LOGFILE
stat $?

echo -n "Installing the redis: "
yum install redis-6.2.7 -y &>> $LOGFILE
stat $?

#Update the BindIP from 127.0.0.1 to 0.0.0.0 in config file /etc/redis.conf & /etc/redis/redis.conf

echo -n "update the bind ip address: "
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf 
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
stat $?

echo -n "start the reddis database: "
#Start Redis Database
systemctl enable redis &>> $LOGFILE
systemctl start redis &>> $LOGFILE
stat $?