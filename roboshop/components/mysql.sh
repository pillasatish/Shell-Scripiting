#!/bin/bash

set -e #exit the code if any one of the below code is not executed
COMPONENT=mysql
LOGFILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"


source components/common.sh

#Setup MySQL Repo

echo -n "setup the $COMPONENT Repo: "
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo &>> $LOGFILE
stat $?

echo -n "Install $COMPONENT: "
yum install mysql-community-server -y &>> $LOGFILE
stat $?

echo -n "Start the $COMPONENT: "
systemctl enable mysqld 
systemctl start mysqld &>> $LOGFILE
stat $?

echo "changing the default root password: "
echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('RoboShop@1');" > /tmp/rootpassword_change.sql
DEFAULT_ROOT_PASSWORD=$(sudo grep "temporary password"  /var/log/mysqld.log | awk '{print $NF}')
mysql --connect-expired-password -uroot -p"$DEFAULT_ROOT_PASSWORD" < /tmp/rootpassword_change.sql
stat $?



