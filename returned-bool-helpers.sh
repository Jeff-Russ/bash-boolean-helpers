#!/bin/bash

evalBool () {
   eval "
   if $1
   then
      echo true
      return 0
   else
      echo false
      return 1
   fi"
}

bool () {
   # falsy:
   if   [ -z "$1" ]; then 
      return 1;
   elif [ "$1" = false ]; then
      return 1;
   elif [ "$1" = 0 ]; then
      return 1;
   else
      return 0;
   fi
}

not () {
   # truthy:
   if   [ -z "$1" ]; then
      return 0;
   elif [ "$1" = false ]; then
      return 0;
   elif [ "$1" = 0 ]; then
      return 0;
   else
      return 1;
   fi
}

all () {
   while test ${#} -gt 0; do
      if   [ -z "$1" ]; then
         return 1;
      elif [ "$1" = false ]; then
         return 1;
      elif [ "$1" = 0 ]; then
         return 1;
      else
         shift;
      fi
   done
   echo "true"
}

none () {
   while test ${#} -gt 0 ; do
      if   [ -z "$1" ]; then
         shift;
      elif [ "$1" = false ]; then
         shift;
      elif [ "$1" = 0 ]; then
         shift;
      else
         return 1;
      fi
   done
   echo "true"
}