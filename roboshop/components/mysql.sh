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

#only run for the first time
echo "show databases" | mysql -uroot -pRoboShop@1 &>> $LOGFILE
if [ 0 -ne $? ]; then
    echo "changing the default root password: "
    echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('RoboShop@1');" > /tmp/rootpassword_change.sql
    DEFAULT_ROOT_PASSWORD=$(sudo grep "temporary password"  /var/log/mysqld.log | awk '{print $NF}')
    mysql --connect-expired-password -uroot -p"$DEFAULT_ROOT_PASSWORD" < /tmp/rootpassword_change.sql
    stat $?
fi

echo "show plugins" | mysql -uroot -pRoboShop@1 &>> $LOGFILE | grep "validate_password"
if [ 0 -eq $? ]; then
    echo "Uninstall the pluhin : "
    echo "uninstall plugin validate_password;" > /tmp/password-validate.sql 
    mysql  --connect-expired-password -uroot -pRoboShop@1 </tmp/password-validate.sql &>> $LOGFILE
    stat $?
fi






