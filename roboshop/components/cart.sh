#!/bin/bash


set -e #exit the code if any one of the below code is not executed
COMPONENT=cart
LOGFILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"


source components/common.sh

#calling nodejs function form common.sh file
NODEJS