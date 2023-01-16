#!/bin/bash

set -e #exit the code if any one of the below code is not executed
COMPONENT=shipping
LOGFILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"


source components/common.sh

MAVEN


