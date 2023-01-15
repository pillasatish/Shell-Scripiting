#!/bin/bash

set -e #exit the code if any one of the below code is not executed
COMPONENT=mongoDB
LOGFILE="/tmp/$COMPONENT.log"
MONGODB_REPO_URL="https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo"
COMPONENT_REPO_URL="https://github.com/stans-robot-project/mongodb/archive/main.zip"

source components/common.sh

echo -n "Downloading and Installing the $COMPONENT: "
curl -s -o /etc/yum.repos.d/mongodb.repo $MONGODB_REPO_URL
yum install -y mongodb-org &>> $LOGFILE
stat $?



echo -n "Starting the $COMPONENT: "
systemctl enable mongod &>> $LOGFILE
systemctl start mongod &>> $LOGFILE
stat $?

#Update Listen IP address from 127.0.0.1 to 0.0.0.0 in the config file, so that MongoDB can be accessed by other services.

echo -n "Updating the configuration file mongod.conf"
#Config file:  /etc/mongod.conf
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat $?

echo -n "restart the $COMPONENT"
systemctl restart mongod &>> $LOGFILE
stat $?

echo -n "Downloading the $COMPONENT schema"

curl -s -L -o /tmp/mongodb.zip $COMPONENT_REPO_URL
stat $?

cd /tmp
echo -n "Extract the schema"
unzip -o mongodb.zip &>> $LOGFILE
stat $?


cd mongodb-main
echo -n "Injecting the schema"
mongo < catalogue.js &>> $LOGFILE
mongo < users.js &>> $LOGFILE
stat $?

echo -n "________________________$COMPONENT configuration is completed_________________________"


