#!/bin/bash

bool () {
	if   [ -z "$1" ];      then echo "false"; return 1;
	elif [ "$1" = false ]; then echo "false"; return 1;
	elif [ "$1" = 0 ];     then echo "false"; return 1;
	else echo "true";  return 0;
	fi
}

not () {
	if   [ -z "$1" ];      then echo "true"; return 0;
	elif [ "$1" = false ]; then echo "true"; return 0;
	elif [ "$1" = 0 ];     then echo "true"; return 0;
	else echo "false"; return 1;
	fi
}

all () {
	while test ${#} -gt 0; do
		if   [ -z "$1" ];      then echo "false"; return 1;
		elif [ "$1" = false ]; then echo "false"; return 1;
		elif [ "$1" = 0 ];     then echo "false"; return 1;
		else shift;
		fi
	done
	echo "true"
	return 0;
}

none () {
	while test ${#} -gt 0 ; do
		if   [ -z "$1" ];      then shift;
		elif [ "$1" = false ]; then shift;
		elif [ "$1" = 0 ];     then shift;
		else echo "false"; return 1;
		fi
	done
	echo "true"
	return 0;
}

evalBool () {
	eval "
	if $1;
	then
		echo true;
		return 0;
	else
		echo false;
		return 1;
	fi"
}

eBool () {
	eval "
	if [ $1 ];
	then
		echo true;
		return 0;
	else
		echo false;
		return 1;
	fi"
}