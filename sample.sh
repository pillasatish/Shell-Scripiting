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
#$* : prints all the varible declared

# through commanf line one can pass upto 9 variables
echo "the name is $1"
echo "the first name is $2"
echo $*

