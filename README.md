# Bash Boolean Helper

[github.com/Jeff-Russ/bash-boolean-helpers](https://github.com/Jeff-Russ/bash-boolean-helpers)

### What is it?

This is set of functions for Bash that provide a friendlier generalization of 'yes' and 'no', as well as provide some syntactic sugar They come at a slight performance cost by will make coding easier, cleaner and sometimes safer.  

### Why?

There is no flexibility or anything like truthy/falsy in Bash. If you make a variable `bool=true`, you can sometimes get away with `if $bool;` but bash tries to execute the VALUE of `$bool` and either you get an error or something unwanted!  

You have to be explicit with one of these, which are pretty much all the same: `[ '$bool' = true ]`, `[ '$bool' = 'true' ]`,  `[[ '$bool' = true ]]`, `[[ '$bool' = 'true' ]]`, `[[ '$bool' == true ]]`, `[[ '$bool' == 'true' ]]`, `if test '$bool' = true;`  

BUUUUUT if `bool` equals `1` it will be false in any of these syntaxes!  

## Overview

Functions ending with `?` echo `true` or `false` and are suitable for viewing at the command line or redirecting to a variable. There are version without `?` that are more suitable next to the `if` keyword. 

1. Functions that accept single variable or command, generalize a boolean 
	* return an exit code of `0` or `1`:
		* `yea`
		* `ney`
		* `all`
		* `none`
	* echo either `true` or `false`:
		* `yes?`
		* `nay?`
		* `all?`
		* `none?`
2. Functions that perform comparison with the same syntax see between `[` and `]` or after `test`
	* return an exit code of `0` or `1`:
		* `when`
		* `unless`
	* echo either `true` or `false`:
		* `true?`
		* `false?`

Note that those under __1.__ do not do any comparison, the are more like converters which use loose evaluation with the following rules:  

__What is false?__
- `false`
- `"false"`
- `0`
- `"0"`
- undeclared variables and 
- empty strings
- commands with `return` a non-zero status

__What is true?__

- Everything else. (but keep reading...)

Note that strings with empty spaces are `false` but any escape character such as `\n` will make it `true`.

## The Boolean Helpers `yea`

Here is the defintion:

`yea` takes any variable, or even undeclared variables and returns the exit code that Bash structures like `if` and `elsif` expect. In order to feed them in, place the call in back-ticks.  
```bash
if yea $1; then
	echo "'$1' is true";
else
	echo "'$1' is false";
fi
```

## Assignment to Variables I: Single Booleans

Using `yea`, `nay`, `all` or `none` also have a nice side effect of making the evaluations savable to a variable, saving a lot of coding. Normally you might do something like this:
```bash
if [ "$stat_1" == "0" ]
then
	error_found=false
else
	error_found=true
fi

echo "error found: $error_found"
```

or the quicker way:
```bash
[ "$stat_1" == "0" ] && error_found=false || error_found=true
echo "error found: $error_found"
```

with `yea?`:
```bash
error_found=`yes? $stat_1`
echo "error found: $error_found"
```

You cannot save `[ "$stat_1" == "0" ]` to a variable because all it does is emit an exit code, but `yes $stat_1` echoes `false` making it usable for assigning. It also makes it usable for printing to the console:  

```bash
yes $stat_1                       # prints false
echo "error found:" `yes? $stat_1` # prints error found: false
```

All helper do two things: they `echo true` or `echo false` then `return 0` or `return 1`. They don't `exit 0` / `exit 1` which would actually exit your script or shell if called without redirection!  

## How it works 
If you are curious, the `if` expects an exit code as it's argument and skips the block if it get anything but a 0 That's right, 0 is 'true' and every other integer is false. The `test` function, as well as `[` take normal comparisons as arguments and returns the equivalent, bash-friendly error code to `if`. `yea` works in the same way.

[read more about exit codes](http://www.cyberciti.biz/faq/shell-how-to-determine-the-exit-status-of-linux-and-unix-command/)

## The Boolean Helper `ney`

There is also `ney` which allows you do to invert the results. For example: `ney false` will be `true`

Try it with this:
```bash
if nay false; then 
	echo "true"
else
	echo "false"
fi
```

__NOTE:__ `yes ! true` or `! yes true` won't work! Don't try it.  

## The Boolean Helpers `all`

You can assess values en masse with `all`, which evaluates to `true` (actually exit code 0) if all of it's arguments are "truthy" by the same definitions used by `yea`. Here, it would echo "true":
```bash
str_var="some non-empty string";
true_var="true";

if all $str_var true $true_var "yes"; then 
	echo "true"
else
	echo "false"
fi
```

## The Boolean Helpers `none`

With `none`, all arguments to be "falsy". As you might guess, this `echo`s "true":
```bash
empty_str="";
false_str="false";

if none $empty_str false $false_str $undeclared; then 
	echo "true"
else
	echo "false"
fi
```

## Assignment to Variables II: Multiple Booleans

Assuming you have this:
```bash
stat_1=0
stat_2=0
stat_3="running"
stat_4="running"
```

Before you might have done:
```bash
if [ "$stat_1" == "0" ] && 
   [ "$stat_2" == "0" ] && 
   [ "$stat_3" != "" ] && 
   [ "$stat_4" != "" ]
then
	error_found=false
else
	error_found=true
fi

echo "error found: $error_found"
```
Now you can just do:
```bash
error_found=`all $stat_1 $stat_2 $stat_3 $stat_4`
echo "error found: $error_found"
```
## Advanced Usage

You can mix `yea` with `ney` like seen below. You still don't need any brackets but, since there are two function calls, the two function calls need to be in separate sets of back-ticks with the boolean operator in between them: 
```bash
if `yes true` && `ney false`; then 
	echo "true"
else
	echo "false"
fi
```
You can also do `yes true` && ! `yes true` but there must be a space after `!` Remember that you are still depending on the `yea` function on both sides so you can't simply put `&& ! true` for the second half.  

Taking things a step further you can use the multi-bool functions in combination as well:
```bash
if `all true true true` && `none true false false`; then 
	echo "true"
else
	echo "false"
fi
```




