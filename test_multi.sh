#!/bin/bash

source ./bool_helpers.sh

echo; echo "#### returning true ####"

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

if `yes true` && `nay false`
then echo "true"
else echo "false"
fi

if `all true true true` && `none false false false`
then echo "true"
else echo "false"
fi



echo; echo "#### returning false ####"

str_var="some non-empty string";
true_var="true"

if `none $str_var true $true_var "yes"`
then echo "true"
else echo "false"
fi

empty_str="";
false_str="false";
if `all $empty_str false $false_str $undeclared`
then echo "true"
else echo "false"
fi

if `bool "yep"` && `nay 1`
then echo "true"
else echo "false"
fi

if `none true "true" \n` && `all false "" 0`
then echo "true"
else echo "false"
fi