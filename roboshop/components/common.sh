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

MAVEN() {
    echo -n "install maven: "
    yum install maven -y &>> $LOGFILE

     #calling user creation function
    CREATE_USER

    DOWNLAOD_AND_EXTRACT

    mvn clean package &>> LOGFILE && mv target/$COMPONENT-1.0.jar $COMPONENT.jar

    CONFIG_SERVICE

    START_SERVICE
}

NODEJS() {
    echo -n "Downlaoding nodejs repo"
    #rm /etc/yum.repos.d/nodesource* &>> $LOGFILE
    #yum update &>> $LOGFILE
    curl -sL https://rpm.nodesource.com/setup_14.x | bash &>> $LOGFILE
    stat $?

    echo -n "Installing the nodejs: "
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
    npm install &>> $LOGFILE
    stat $?
}

CONFIG_SERVICE(){
    echo -n "systemD file: "
    sed -i -e 's/AMQPHOST/rabbit-mq.roboshop-internal/' -e 's/USERHOST/users.roboshop-internal/' -e 's/CARTHOST/cart.roboshop-internal/' -e 's/DBHOST/my-sql.roboshop-internal/' -e 's/CARTENDPOINT/cart.roboshop-internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop-internal/' -e 's/REDIS_ENDPOINT/redis.roboshop-internal/' -e 's/REDIS_ENDPOINT/redis.roboshop-internal/'  -e 's/MONGO_ENDPOINT/mongodb.roboshop-internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop-internal/' systemd.service
    mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
    stat $?
}

START_SERVICE() {
    echo -n "Starting $COMPONENT service: "
    systemctl daemon-reload 
    systemctl restart $COMPONENT 
    systemctl enable $COMPONENT  &>> $LOGFILE  
    systemctl status $COMPONENT -l &>> $LOGFILE 
    stat $?      

}