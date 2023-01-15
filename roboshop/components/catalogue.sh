#!/bin/bash

set -e #exit the code if any one of the below code is not executed
COMPONENT=catalogue
LOGFILE="/tmp/$COMPONENT.log"
CATALOGUE_REPO_URL="https://github.com/stans-robot-project/catalogue/archive/main.zip"

source components/common.sh

echo -n "Downlaoding nodejs repo"
curl --silent --location https://rpm.nodesource.com/setup_16.x | bash &>> $LOGFILE
stat $?

echo -n "Insatlling the nodejs: "
yum install nodejs -y &>> $LOGFILE
stat $?

#Let's now set up the catalogue application.

#As part of operating system standards, we run all the applications and databases as a normal user but not with root user.

#So to run the catalogue service we choose to run as a normal user and that user name should be more relevant to the project. Hence we will use `roboshop` as the username to run the service.

echo -n "Adding the common Useradd: "
 useradd roboshop
 stat $?

echo -n "swtich to rpboshop and install the $COMPONENT: "
$ curl -s -L -o /tmp/${catalogue}.zip $CATALOGUE_REPO_URL
$ cd /home/roboshop
$ unzip /tmp/${catalogue}.zip
$ mv catalogue-main ${catalogue}
$ cd /home/roboshop/${catalogue}

echo -n "Insatlling the $COMPONENT"
$ npm install &>> $LOGFILE
stat $?






