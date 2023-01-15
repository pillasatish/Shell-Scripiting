#!/bin/bash
echo "Hello world"
echo "Hai"

# print the colour code
echo -e "\e[45;33m i am yellow \e[0m"

#Variable is something which holds the values dynamically.

a=10
b=abc
# no concept of data type in bash scripting
# so here is 10 is a string
 
 echo $a #$a is printing the value of a
 echo $b

 # Variables that are declared inside the script are Local Variable
# variables that are declared as shell using exoprt are environment variables.

# Always local varible as higher precedence than Envirment varaiables.

# dyamic output
Date=$(date +%F)
echo "today's data is $Date"

#Special varaibles:
#$0 : prints the script name
#$? : check the status of command 
#$* : prints all the CLI varible declared
#$# : print the number of varibales

# through commanf line one can pass upto 9 variables
echo "the name is $1"
echo "the first name is $2"
echo $*
echo $#


#taking the input from the users
read -p "enter the name" name
echo -e "print $name"

# IN linux, 4 types of command are there:

#1) Binaries (/bin,/sbin)
#2) alias (creating shorcuts)
#3) shell built (built in commands)
#4) Functions wrapping the set of commands in a single command

#sample function
f() {
    echo "today data $(date +%F)"
}
#call the function
f
# function call mutiple functions

# Redirections

# > output redirected to the file
# >> output redirected without over-ridden
# 2> captures only standard error

# < taking input from the file


# Exit code:
#range is between 0:255
#0:success
#1-255: failure/parially failed

# Loops and Conditions:
# 1)IF 2) CASE

# Syntax
ACTION=$1
case $ACTION in
    start)
        echo "xy";
    stop)
        echo "er"
esac