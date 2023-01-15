#!/bin/bash

set -e #exit the code if any one of the below code is not executed
COMPONENT=frontend
LOGFILE="/tmp/$COMPONENT.log"


source components/common.sh

stat() {
    if [ $? -eq 0 ] ; then
    echo -e "\e[32m SUCCESS\e[0m"
else
    echo -e "\e[32m FAILURE\e[0m"

fi
}


echo -n "Installing Nginx"
yum install nginx -y &>> $LOGFILE
stat $?

systemctl enable nginx &>> $LOGFILE

echo -n "Starting nginx"
systemctl start nginx
stat $?

echo -n "Downloading $COMPONENT: "

curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
stat $?

echo -n "Clearing the old content $COMPONENT: "
cd /usr/share/nginx/html
rm -rf *
stat $?

echo -n "Extracting the $COMPONENT: "
unzip /tmp/frontend.zip &>>$LOGFILE
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md

echo -n "Updating the proxy file $COMPONENT: "
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?