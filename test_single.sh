#!/bin/bash

source ./bool_helpers.sh

testBool () {
   if `bool $1`; then echo "'$1' is true";
   else echo "'$1' is false";
   fi
}

testBool true;
testBool "true";
testBool 1;
testBool "1";
testBool "random string";
newline_char="\n";

testBool false;
testBool "false";
testBool 0;
testBool "0";
printf "never_declared";       testBool $never_declared;
printf "empty string literal"; testBool "";
testBool " ";
testBool "     ";

if `not false`
then echo "true"
else echo "false"
fi
str_var="some non-empty string";
true_var="true"
if `all $str_var true $true_var "yes"`
then echo "true"
else echo "false"
fi
empty_str="";
false_str="false";
if `none $empty_str false $false_str $undeclared`
then echo "true"
else echo "false"
fi
if `bool true` && `not false`
then echo "true"
else echo "false"
fi
if `all true true true` && `none true false false`
then echo "true"
else echo "false"
fi
