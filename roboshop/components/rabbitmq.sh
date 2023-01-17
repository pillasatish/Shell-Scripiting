#!/bin/bash

set -e #exit the code if any one of the below code is not executed
COMPONENT=rabbitmq
LOGFILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"


source components/common.sh

echo -n "Install the dependines: "
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOGFILE
stat $?

echo -n "steup the repositories: "
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOGFILE
stat $?

echo -n "Install $COMPONENT: "
yum install rabbitmq-server -y &>> $LOGFILE
stat $?

echo -n "Starting the $COMPONENT: "
systemctl enable rabbitmq-server &>> $LOGFILE
systemctl start rabbitmq-server &>> $LOGFILE
stat $?

#Create application user ( These are rabbitmq commands given by the developer, same can be seen in the official documentation of rabbitmq )

sudo rabbitmqctl list_users | grep roboshop &>> $LOGFILE
if [ $? -eq 0 ] ; then

    echo "Commands to execute: "
    rabbitmqctl add_user $APPUSER roboshop123 
    stat $?
 fi

echo -n " Configuring the $APPUSER permission"
rabbitmqctl set_user_tags $APPUSER administrator &>> $LOGFILE
rabbitmqctl set_permissions -p / $APPUSER ".*" ".*" ".*" &>> $LOGFILE
stat $?