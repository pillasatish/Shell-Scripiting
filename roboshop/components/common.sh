#!/bin/bash

USER_ID=$(id -u)
if [ $USER_ID -ne 0 ] ; then
    echo -e "\e[31m run as root user \e[0m"
    exit 1
fi

# checking the whether the all the steps are executed correctly are not.
stat() {
    if [ $? -eq 0 ] ; then
    echo -e "\e[32m SUCCESS\e[0m"
else
    echo -e "\e[32m FAILURE\e[0m"

fi
}

NODEJS() {
    echo -n "Downlaoding nodejs repo"
    curl --silent --location https://rpm.nodesource.com/setup_16.x | bash &>> $LOGFILE
    stat $?

    echo -n "Insatlling the nodejs: "
    yum install nodejs -y &>> $LOGFILE
    stat $?

    #calling user creation function
    CREATE_USER

    # calling function downlaod and eactract
    DOWNLAOD_AND_EXTRACT
    #Installing the nodejs
    echo -n "Insatlling the $COMPONENT: "
    npm install &>> $LOGFILE
    stat $?

    # calling config service
    CONFIG_SERVICE

    # calling the start service
    START_SERVICE
}

CREATE_USER() {
    echo -n "Adding the common Useradd: "
    id roboshop &>> $LOGFILE || useradd roboshop 
    stat $?
}

DOWNLAOD_AND_EXTRACT() {
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
}

CONFIG_SERVICE(){
    echo -n "systemD file: "
    sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop-internal/' systemd.service
    mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/catalogue.service
    stat $?
}

START_SERVICE() {
    echo -n "setup the service with systemctl: "
    systemctl daemon-reload 
    systemctl restart $COMPONENT &>> $LOGFILE
    systemctl enable $COMPONENT &>> $LOGFILE
    stat $? 

}