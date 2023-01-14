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

Date=2023-01-14
echo "today's data is $Date"

