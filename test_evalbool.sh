#!/bin/bash

source ./bool_helpers.sh

get_abs_path () {
   if `evalBool "[ -d "$1" ]"`; then
      echo `cd "$1"; pwd`
   fi
}