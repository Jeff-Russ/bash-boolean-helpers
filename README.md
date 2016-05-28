# Bash Boolean Helper

[github.com/Jeff-Russ/bash-boolean-helpers](https://github.com/Jeff-Russ/bash-boolean-helpers)

### What is it?

This is set of functions for Bash that provide a friendlier generalization of 'yea' and 'no', as well as provide some syntactic sugar They come at a slight performance cost by will make coding easier, cleaner and sometimes safer.  

### Why?

There is no flexibility or anything like truthy/falsy in Bash. If you make a variable `bool=true`, you can sometimes get away with `if $bool;` but bash tries to execute the VALUE of `$bool` and either you get an error or something unwanted!  

You have to be explicit with one of these, which are pretty much all the same: `[ '$bool' = true ]`, `[ '$bool' = 'true' ]`,  `[[ '$bool' = true ]]`, `[[ '$bool' = 'true' ]]`, `[[ '$bool' == true ]]`, `[[ '$bool' == 'true' ]]`, `if test '$bool' = true;`  

BUUUUUT if `bool` equals `1` it will be false in any of these syntaxes!  

## Overview

Functions beginning with `if_` echo `true` or `false` and are suitable for one liners (`if_yea $var && dothis || dothat`) viewing at the command line, or redirecting to a variable. There are version without the `if` in them that are more suitable next to the `if` keyword. 

1. Functions that accept single variable or command, generalize a boolean 
	* return an exit code of `0` or `1`:
		* `_yea`
		* `_nay`
		* `_all`
		* `_none`
	* echo either `true` or `false`:
		* `if_yea`
		* `if_nay`
		* `if_all`
		* `if_none`
2. Functions that perform comparison with the same syntax see between `[` and `]` or after `test`
	* return an exit code of `0` or `1`:
		* `_true`
		* `_false`
	* echo either `true` or `false`:
		* `if_true`
		* `if_false`

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

## The Boolean Helpers `_yea`

Here is the defintion:

`_yea` takes any variable, or even undeclared variables and returns the exit code that Bash structures like `if` and `elsif` expect. 
```bash
if _yea $1; then
	echo "'$1' is true";
else
	echo "'$1' is false";
fi
```

## Assignment to Variables I: Single Booleans

Using `_yea`, `_nay`, `_all` or `_none` also have a nice side effect of making the evaluations savable to a variable, saving a lot of coding. Normally you might do something like this:
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

with `_yea`:
```bash
error_found=`if_yea $stat_1`
echo "error found: $error_found"
```

You cannot save `[ "$stat_1" == "0" ]` to a variable because all it does is emit an exit code, but `_yea $stat_1` echoes `false` making it usable for assigning. It also makes it usable for printing to the console:  

```bash
yea $stat_1                          # prints false
echo "error found:" `if_yea $stat_1` # prints error found: false
```

All helper do two things: they `echo true` or `echo false` then `return 0` or `return 1`. They don't `exit 0` / `exit 1` which would actually exit your script or shell if called without redirection!  

## How it works 
If you are curious, the `if` expects an exit code as it's argument and skips the block if it get anything but a 0 That's right, 0 is 'true' and every other integer is false. The `test` function, as well as `[` take normal comparisons as arguments and returns the equivalent, bash-friendly error code to `if`. `_yea` works in the same way.

[read more about exit codes](http://www.cyberciti.biz/faq/shell-how-to-determine-the-exit-status-of-linux-and-unix-command/)

## The Boolean Helper `_nay`

There is also `_nay` which allows you do to invert the results. For example: `_nay false` will be `true`

Try it with this:
```bash
if _nay false; then 
	echo "true"
else
	echo "false"
fi
```

__NOTE:__ `_yea ! true` or `! _yea true` won't work! Don't try it.  

## The Boolean Helpers `_all`

You can assess values en masse with `_all`, which evaluates to `true` (actually exit code 0) if all of it's arguments are "truthy" by the same definitions used by `_yea`. Here, it would echo "true":
```bash
str_var="some non-empty string";
true_var="true";

if _all $str_var true $true_var "yea"; then 
	echo "true"
else
	echo "false"
fi
```

## The Boolean Helpers `_none`

With `_none`, all arguments to be "falsy". As you might guess, this `echo`s "true":
```bash
empty_str="";
false_str="false";

if _none $empty_str false $false_str $undeclared; then 
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
error_found=`_all $stat_1 $stat_2 $stat_3 $stat_4`
echo "error found: $error_found"
```
## Advanced Usage

You can mix `_yea` with `_nay` like seen below. 
```bash
if _yea true && _nay false; then 
	echo "true"
else
	echo "false"
fi
```

Taking things a step further you can use the multi-bool functions in combination as well:
```bash
if _all true true true && _none true false false; then 
	echo "true"
else
	echo "false"
fi
```




