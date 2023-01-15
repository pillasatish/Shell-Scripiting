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