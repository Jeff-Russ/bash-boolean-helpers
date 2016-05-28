#!/bin/bash

yea () {
	command -v "$*" >/dev/null 2>&1 || { 
		if   [ -z "$*" ];      then return 1;
		elif [ "$*" = false ]; then return 1;
		elif [ "$*" = 0 ];     then return 1;
		else return 0;
		fi
	}
	typeset cmnd="$*"
	typeset ret_code
	eval $cmnd >/dev/null 2>&1
	ret_code=$?
	return $ret_code
}

nay () {
	command -v "$*" >/dev/null 2>&1 || { 
		if   [ -z "$*" ];      then return 0;
		elif [ "$*" = false ]; then return 0;
		elif [ "$*" = 0 ];     then return 0;
		else return 1;
		fi
	}
	typeset cmnd="$*"
	typeset ret_code
	eval $cmnd >/dev/null 2>&1
	ret_code=$?
	test $ret_code -eq 0 && return 1 || return 0
}

all () {
	while test ${#} -gt 0; do
		if   [ -z "$1" ];      then return 1;
		elif [ "$1" = false ]; then return 1;
		elif [ "$1" = 0 ];     then return 1;
		else shift;
		fi
	done
	return 0;
}

none () {
	while test ${#} -gt 0 ; do
		if   [ -z "$1" ];      then shift;
		elif [ "$1" = false ]; then shift;
		elif [ "$1" = 0 ];     then shift;
		else return 1;
		fi
	done
	return 0;
}

yea? () {
	command -v "$*" >/dev/null 2>&1 || { 
		if   [ -z "$*" ];      then echo false; return 1;
		elif [ "$*" = false ]; then echo false; return 1;
		elif [ "$*" = 0 ];     then echo false; return 1;
		else echo true; return 0;
		fi
	}
	typeset cmnd="$*"
	typeset ret_code
	eval $cmnd >/dev/null 2>&1
	ret_code=$?
	test $ret_code -eq 0 && echo true || echo false
}

nay? () {
	command -v "$*" >/dev/null 2>&1 || { 
		if   [ -z "$*" ];      then echo true; return 0;
		elif [ "$*" = false ]; then echo true; return 0;
		elif [ "$*" = 0 ];     then echo true; return 0;
		else echo false; return 1;
		fi
	}
	typeset cmnd="$*"
	typeset ret_code
	eval $cmnd >/dev/null 2>&1
	ret_code=$?
	test $ret_code -eq 0 && echo false || echo true
}

all? () {
	while test ${#} -gt 0; do
		if   [ -z "$1" ];      then echo false; return 1;
		elif [ "$1" = false ]; then echo false; return 1;
		elif [ "$1" = 0 ];     then echo false; return 1;
		else shift;
		fi
	done
	echo true;
	return 0;
}

none? () {
	while test ${#} -gt 0 ; do
		if   [ -z "$1" ];      then shift;
		elif [ "$1" = false ]; then shift;
		elif [ "$1" = 0 ];     then shift;
		else echo false; return 1;
		fi
	done
	echo true;
	return 0;
}

true? () {
	if test "$@"; then echo true; return 0;
	else echo false; return 1;
	fi
}
false? () {
	if test "$@"; then echo true; return 0;
	else echo false; return 1;
	fi
}

if [ -z "$PS1" ]; then 
	# The shell is not interactive
	when ()   { test "$@";   }
	unless () { test "! $@"; }
else 
	# The shell is interactive
	alias when="test"
	alias unless="test !"
fi
