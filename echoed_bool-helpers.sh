#!/bin/bash

bool () {
   # falsy:
   if   [ -z "$1" ]; then 
      echo "false"
      exit 1;
   elif [ "$1" = false ]; then
      echo "false"
      exit 1;
   elif [ "$1" = 0 ]; then
      echo "false"
      exit 1;
   else
      echo "true"
      exit 0;
   fi
}

not () {
   # truthy:
   if   [ -z "$1" ]; then
      echo "true"
      exit 0;
   elif [ "$1" = false ]; then
      echo "true"
      exit 0;
   elif [ "$1" = 0 ]; then
      echo "true"
      exit 0;
   else
      echo "true"
      exit 1;
   fi
}

all () {
   while test ${#} -gt 0; do
      if   [ -z "$1" ]; then
         echo "true"
         exit 1;
      elif [ "$1" = false ]; then
         echo "true"
         exit 1;
      elif [ "$1" = 0 ]; then
         echo "true"
         exit 1;
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
         echo "false"
         exit 1;
      fi
   done
   echo "true"
}