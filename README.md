# Bash Boolean Helper

[github.com/Jeff-Russ/bash-boolean-helpers](https://github.com/Jeff-Russ/bash-boolean-helpers)

This is Bash function called `bool` that provide a friendlier generalization of 'truthy' and 'falsy'. It will come at a performance cost by will make coding easier, safer and cleaner.

__Usage:__

`bool` takes any variable, or even undeclared variables and returns the exit code that Bash structures like `if` and `elsif` expect. In order to feed them in, place the call in back-ticks.  

   if `bool $1`; then
      echo "'$1' is true";
   else
      echo "'$1' is false";
   fi

__What is false?__
- `false`
- `"false"`
- `0`
- `"0"`
- undeclared variables and 
- empty strings

__What is true?__

- Everything else. 

Note that strings with empty spaces are `false` but any escape character such as `\n` will make it `true`.

## Bash is Strict

There is no flexibility or anything like truthy/falsy in Bash. You can sometimes get away with this but bash tries to execute the VALUE of $bool and either you get an error or something unwanted!

   bool=true;
   if $bool; then # ....

You have to be explicit like one of these, which are pretty much all the same:
   
   bool=true
   
   if [ '$bool' = true ]; then
   if [ '$bool' = 'true' ]; then
   
   if [[ '$bool' = true ]]; then
   if [[ '$bool' = 'true' ]]; then
   if [[ '$bool' == true ]]; then
   if [[ '$bool' == 'true' ]]; then

which means if `bool` equals `1` it will be false! You can also use the built-in /bin/test which basically does the job of the `[[ ]]` or `[[ ]]`

   if test '$bool' = true; then
   if test '$bool' = 'true'; then

## How it works

If you are curious about what `[[ ]]` or `[[ ]]` are returning, test holds the secret to what `if` expects.

The `if` keyword is basically a function that takes an exit code int as it's argument and skips the block if it get anything but a 0 That's right, 0 is 'true' and every other integer is false. The `test` function takes normal comparisons as arguments and returns the equivalent, bash-friendly error code.

[read more here](http://www.cyberciti.biz/faq/shell-how-to-determine-the-exit-status-of-linux-and-unix-command/)

## The Boolean Helper `bool`

You can create your own replacement for `test` that provide a friendlier generalization of 'truthy' and 'falsy'. It will come at a performance cost by will make coding easier, safer and cleaner.

   bool () {
      # falsy:
      if   [ -z "$1" ];      then exit 1;
      elif [ "$1" = false ]; then exit 1;
      elif [ "$1" = 0 ];     then exit 1;
   
      else exit 0; # truthy
      fi
   }

## Testing and Using It

   testBool () {
      if `bool $1`; then echo "'$1' is true";
      else echo "'$1' is false";
      fi
   }
   
   echo;
   echo "______________These are all true:____________"; 
   testBool true;
   testBool "true";
   testBool 1;
   testBool "1";
   testBool "random string";
   newline_char="\n";
   
   echo;
   echo "______________These are all false:____________"; 
   
   testBool false;
   testBool "false";
   testBool 0;
   testBool "0";
   printf "never_declared";       testBool $never_declared;
   printf "empty string literal"; testBool "";
   testBool " ";
   testBool "     ";

## The Boolean Helper `not`

There is also `not` which allows you do to invert the results. For example: `not false` will be `true` note: `bool ! true` or `! bool true` won't work!

   not () {
      # truthy:
      if   [ -z "$1" ];      then exit 0;
      elif [ "$1" = false ]; then exit 0;
      elif [ "$1" = 0 ];     then exit 0;
   
      else exit 1; # falsy
      fi
   }

Try it with this:

   if `not false`; then 
      echo "true"
   else
      echo "false"
   fi
   
## The Boolean Helpers `all` and `none`


You can assess values en masse with `all`, evaluates to "true" (actually exit code 0) if all of it's arguments are "truthy" in by the same definitions in `bool`. Here is it's definition:


   all () {
      while test ${#} -gt 0; do
         if   [ -z "$1" ];      then exit 1;
         elif [ "$1" = false ]; then exit 1;
         elif [ "$1" = 0 ];     then exit 1;
   
         else shift;
         fi
      done
   }

Here, it would echo "true":

   str_var="some non-empty string";
   true_var="true";
   
   if `all $str_var true $true_var "yes"`; then 
      echo "true"
   else
      echo "false"
   fi

With `none`, all arguments to be "falsy". Here is the definition:

   none () {
      while test ${#} -gt 0 ; do
         if   [ -z "$1" ];      then shift;
         elif [ "$1" = false ]; then shift;
         elif [ "$1" = 0 ];     then shift;
   
         else exit 1;
         fi
      done
   }

As you might guess, this `echo`s "true":

   empty_str="";
   false_str="false";
   
   if `none $empty_str false $false_str $undeclared`; then 
      echo "true"
   else
      echo "false"
   fi

## Advanced Usage

You can mix `bool` with `not` like seen below. You still don't need any brackets but, since there are two function calls, the two function calls need to be in separate sets of back-ticks with the boolean operator in between them: 

   if `bool true` && `not false`; then 
      echo "true"
   else
      echo "false"
   fi

You can also this but there must be a space after `!` Remember that you are still depending on the `bool` function on both sides so you can't simply put `&& ! true` for the second half.

   `bool true` && ! `bool true`
   
Taking things a step further you can use the multi-bool functions in combination as well:

   if `all true true true` && `none true false false`; then 
      echo "true"
   else
      echo "false"
   fi

