#!/bin/bash

source ./bool_helpers.sh

echo; echo "#### returning true ####"

str_var="some non-empty string";
true_var="true"

if _all $str_var true $true_var "yes"
then echo "true"
else echo "false"
fi

empty_str="";
false_str="false";
if _none $empty_str false $false_str $undeclared
then echo "true"
else echo "false"
fi

if _yea true && _nay false
then echo "true"
else echo "false"
fi

if _all true true true && _none false false false
then echo "true"
else echo "false"
fi



echo; echo "#### returning false ####"

str_var="some non-empty string";
true_var="true"

if _none $str_var true $true_var "yes"
then echo "true"
else echo "false"
fi

empty_str="";
false_str="false";
if _all $empty_str false $false_str $undeclared
then echo "true"
else echo "false"
fi

if _yea "yep" && _nay 1
then echo "true"
else echo "false"
fi

if `_none true "true" \n` && `_all false "" 0`
then echo "true"
else echo "false"
fi