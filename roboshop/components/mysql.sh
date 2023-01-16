#!/bin/bash

set -e #exit the code if any one of the below code is not executed
COMPONENT=mysql
LOGFILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"


source components/common.sh

#Setup MySQL Repo

echo -n "setup the $COMPONENT Repo: "
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo
stat $?

echo -n "Install $COMPONENT: "
yum install mysql-community-server -y
stat $?

echo -n "Start the $COMPONENT: "
systemctl enable mysqld 
systemctl start mysqld
stat $?

