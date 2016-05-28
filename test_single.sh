#!/bin/bash

source ./bool_helpers.sh

testBool () {
	if yea $1; then echo "'$1' is true";
	else echo "'$1' is false";
	fi
}

echo; echo "#### returning true ####"; echo

testBool true;
testBool "true";
testBool 1;
testBool "1";
testBool "random string";
testBool "\n"

echo; echo "#### returning false ####"; echo

testBool false;
testBool "false";
testBool 0;
testBool "0";
printf "never_declared";       testBool $never_declared;
printf "empty string literal"; testBool "";
testBool " ";
testBool "     ";
if nay true;
then echo "true"
else echo "false"
fi

