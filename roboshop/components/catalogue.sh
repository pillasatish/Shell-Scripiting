#!/bin/bash

set -e #exit the code if any one of the below code is not executed
COMPONENT=catalogue
LOGFILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"


source components/common.sh

#calling nodejs function form common.sh file
NODEJS

#Let's now set up the catalogue application.

#As part of operating system standards, we run all the applications and databases as a normal user but not with root user.

#So to run the catalogue service we choose to run as a normal user and that user name should be more relevant to the project. Hence we will use `roboshop` as the username to run the service.













