#!/bin/bash

set -e #exit the code if any one of the below code is not executed
COMPONENT=mongoDB
LOGFILE="/tmp/$COMPONENT.log"
MONGODB_REPO_URL="https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo"


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

echo "Updating the configuration file mongod.conf"
#Config file:  /etc/mongod.conf
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat $?

#systemctl restart mongod

# curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"

# cd /tmp
# unzip mongodb.zip
# cd mongodb-main
# mongo < catalogue.js
# mongo < users.js
