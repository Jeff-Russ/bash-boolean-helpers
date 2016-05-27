#!/bin/bash

# evalBool is an experimental meta-programming boolean helper for Bash

# It takes at least two arguments where the first is a  boolean structure you 
# normally see in Bash like '[ "$2" == "yes" ]', with single quotes. The 
# remaining args are referred to by number in the first all of the arguments 
# can be variables, allowing you to save a "test" as a string variable and/or 
# test many variables against that test. Here is the function itself:

evalBool () {
   eval "
   if $1
   then
      echo true
      exit 0
   else
      echo false
      exit 1
   fi"
}

# The exits codes are what Bash interprets as booleans in 'if' statements, 
# for example.the echoes are there so that you may save the result to a 
# variable for later. Here is an example of a function that uses evalBool:

#     finder () {
#        for arg in ${@:2}; do
#           if `evalBool "${!1}" "${!arg}"`; then
#              echo "$arg passed"
#           fi
#        done
#     }

# You can save "tests" like this:

#     is_yes='[ "$2" == "yes" ]'
#     is_no='[ "$2" == "no" ]'
#     is_whatever='[ "$2" == "whatever" ]'
#     is_empty='[ -z "$2" ]'

# Here is an example where you have a number of variable and you want to find 
# out which one passes each test

#     var1='yes'
#     var2='no'
#     var3=''
#     var4='whatever'

# We can use our finder function to search for the match and echo the output:

#     finder is_yes var1 var2 var3 var4      # prints: var1 passed
#     finder is_no var1 var2 var3 var4       # prints: var2 passed
#     finder is_empty var1 var2 var3 var4    # prints: var3 passed
#     finder is_whatever var1 var2 var3 var4 # prints: var4 passed
