#!/bin/bash

set -e #exit the code if any one of the below code is not executed
COMPONENT=payment
LOGFILE="/tmp/$COMPONENT.log"
APPUSER="roboshop"


source components/common.sh

