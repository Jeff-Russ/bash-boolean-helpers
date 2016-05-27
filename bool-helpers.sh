#!/bin/bash

bool () {
   # falsy:
   if   [ -z "$1" ];      then exit 1;
   elif [ "$1" = false ]; then exit 1;
   elif [ "$1" = 0 ];     then exit 1;

   else exit 0; # truthy
   fi
}

not () {
   # truthy:
   if   [ -z "$1" ];      then exit 0;
   elif [ "$1" = false ]; then exit 0;
   elif [ "$1" = 0 ];     then exit 0;

   else exit 1; # falsy
   fi
}

all () {
   while test ${#} -gt 0; do
      if   [ -z "$1" ];      then exit 1;
      elif [ "$1" = false ]; then exit 1;
      elif [ "$1" = 0 ];     then exit 1;

      else shift;
      fi
   done
}

none () {
   while test ${#} -gt 0 ; do
      if   [ -z "$1" ];      then shift;
      elif [ "$1" = false ]; then shift;
      elif [ "$1" = 0 ];     then shift;

      else exit 1;
      fi
   done
}

testBool () {
   if `bool $1`; then echo "'$1' is true";
   else echo "'$1' is false";
   fi
}


# # tests and examples: 

# testBool true;
# testBool "true";
# testBool 1;
# testBool "1";
# testBool "random string";
# newline_char="\n";

# testBool false;
# testBool "false";
# testBool 0;
# testBool "0";
# printf "never_declared";       testBool $never_declared;
# printf "empty string literal"; testBool "";
# testBool " ";
# testBool "     ";

# if `not false`
# then echo "true"
# else echo "false"
# fi
# str_var="some non-empty string";
# true_var="true"
# if `all $str_var true $true_var "yes"`
# then echo "true"
# else echo "false"
# fi
# empty_str="";
# false_str="false";
# if `none $empty_str false $false_str $undeclared`
# then echo "true"
# else echo "false"
# fi
# if `bool true` && `not false`
# then echo "true"
# else echo "false"
# fi
# if `all true true true` && `none true false false`
# then echo "true"
# else echo "false"
# fi