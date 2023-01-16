#!/bin/bash

set -e #exit the code if any one of the below code is not executed
COMPONENT=catalogue
LOGFILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"


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
 id roboshop &>> $LOGFILE || useradd roboshop 
 stat $?

echo -n "swtich to roboshop and install the $COMPONENT: "
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
stat $?

echo -n "cleanup:"
cd /home/roboshop/ && rm -rf ${COMPONENT} &>> $LOGFILE
stat $?

echo -n "extrating the $COMPONENT: "
cd /home/roboshop
unzip /tmp/${COMPONENT}.zip &>> $LOGFILE
mv ${COMPONENT}-main ${COMPONENT} && chown -R $APPUSER:$APPUSER $COMPONENT
cd ${COMPONENT}
stat $?




echo -n "Insatlling the $COMPONENT: "
npm install &>> $LOGFILE
stat $?

#Update SystemD file with correct IP addresses
#Update `MONGO_DNSNAME` with MongoDB Server IP
echo -n "systemD file: "
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop-internal/' systemd.service
stat $?

echo -n "setup the service with systemctl: "
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
systemctl daemon-reload &>> $LOGFILE
systemctl start catalogue &>> $LOGFILE
systemctl enable catalogue &>> $LOGFILE









