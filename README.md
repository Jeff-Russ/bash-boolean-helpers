# Bash Boolean Helper

[github.com/Jeff-Russ/bash-boolean-helpers](https://github.com/Jeff-Russ/bash-boolean-helpers)

### What is it?

This is set of functions for Bash called that provide a friendlier generalization of 'truthy' and 'falsy'. They come at a slight performance cost by will make coding easier, cleaner and sometimes safer.  

### Why?

There is no flexibility or anything like truthy/falsy in Bash. If you make a variable `bool=true`, you can sometimes get away with `if $bool;` but bash tries to execute the VALUE of `$bool` and either you get an error or something unwanted!  

You have to be explicit with one of these, which are pretty much all the same: `[ '$bool' = true ]`, `[ '$bool' = 'true' ]`,  `[[ '$bool' = true ]]`, `[[ '$bool' = 'true' ]]`, `[[ '$bool' == true ]]`, `[[ '$bool' == 'true' ]]`, `if test '$bool' = true;`  

BUUUUUT if `bool` equals `1` it will be false in any of these syntaxes!  

## Overview

- `bool` loosely evaluates one variable or literal, returns `true` or `false` 
- `not` same as `bool` but with inverted return
- `all` loosely evaluates many arguments. If all are `true`, returns `true`
- `none` same as `all` but If all are `false`, returns `true`
- `evalBool` experimental boolean expression evaluator
- `eBool` same as `evalBool` but more terse and less flexible

The last two require further explanation and should be used with caution. Note that first four do not do any comparison, the are more like converters which use loose evaluation with the following rules:  

__What is false?__
- `false`
- `"false"`
- `0`
- `"0"`
- undeclared variables and 
- empty strings

__What is true?__

- Everything else. (but keep reading...)

Note that strings with empty spaces are `false` but any escape character such as `\n` will make it `true`.

## The Boolean Helper `bool`

Here is the defintion:

```bash
bool () {
	if   [ -z "$1" ];      then echo "false"; return 1;
	elif [ "$1" = false ]; then echo "false"; return 1;
	elif [ "$1" = 0 ];     then echo "false"; return 1;
	else echo "true";  return 0;
	fi
}
```
`bool` takes any variable, or even undeclared variables and returns the exit code that Bash structures like `if` and `elsif` expect. In order to feed them in, place the call in back-ticks.  
```bash
if `bool $1`; then
	echo "'$1' is true";
else
	echo "'$1' is false";
fi
```

## Assignment to Variables I: Single Booleans

Using `bool`, `not`, `all` or `none` also have a nice side effect of making the evaluations savable to a variable, saving a lot of coding. Normally you might do something like this:
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

with `bool`:
```bash
error_found=`bool $stat_1`
echo "error found: $error_found"
```

You cannot save `[ "$stat_1" == "0" ]` to a variable because all it does is emit an exit code, but `bool $stat_1` echoes `false` making it usable for assigning. It also makes it usable for printing to the console:  

```bash
bool $stat_1                       # prints false
echo "error found:" `bool $stat_1` # prints error found: false
```

All helper do two things: they `echo true` or `echo false` then `return 0` or `return 1`. They don't `exit 0` / `exit 1` which would actually exit your script or shell if called without redirection!  

## How it works 
If you are curious, the `if` expects an exit code as it's argument and skips the block if it get anything but a 0 That's right, 0 is 'true' and every other integer is false. The `test` function, as well as `[` take normal comparisons as arguments and returns the equivalent, bash-friendly error code to `if`. `bool` works in the same way.

[read more about exit codes](http://www.cyberciti.biz/faq/shell-how-to-determine-the-exit-status-of-linux-and-unix-command/)

## The Boolean Helper `not`

There is also `not` which allows you do to invert the results. For example: `not false` will be `true`

Try it with this:
```bash
if `not false`; then 
	echo "true"
else
	echo "false"
fi
```

__NOTE:__ `bool ! true` or `! bool true` won't work! Don't try it.  

## The Boolean Helpers `all`

You can assess values en masse with `all`, which evaluates to `true` (actually exit code 0) if all of it's arguments are "truthy" by the same definitions used by `bool`. Here, it would echo "true":
```bash
str_var="some non-empty string";
true_var="true";

if `all $str_var true $true_var "yes"`; then 
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

if `none $empty_str false $false_str $undeclared`; then 
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

You can mix `bool` with `not` like seen below. You still don't need any brackets but, since there are two function calls, the two function calls need to be in separate sets of back-ticks with the boolean operator in between them: 
```bash
if `bool true` && `not false`; then 
	echo "true"
else
	echo "false"
fi
```
You can also do `bool true` && ! `bool true` but there must be a space after `!` Remember that you are still depending on the `bool` function on both sides so you can't simply put `&& ! true` for the second half.  

Taking things a step further you can use the multi-bool functions in combination as well:
```bash
if `all true true true` && `none true false false`; then 
	echo "true"
else
	echo "false"
fi
```

# evalBool

evalBool is an experimental meta-programming boolean helper for Bash

It takes at least two arguments where the first is a  boolean structure you 
normally see in Bash like '[ "$2" == "yes" ]', with single quotes. The 
remaining args are referred to by number in the first all of the arguments 
can be variables, allowing you to save a "test" as a string variable and/or 
test many variables against that test. Here is the function itself:
```bash
evalBool () {
	eval "
	if '$1';
	then
		echo true;
		return 0;
	else
		echo false;
		return 1;
	fi"
}
```
The exits codes are what Bash interprets as booleans in 'if' statements, 
for example. The echoes are there so that you may save the result to a 
variable for later. 

Here is an example where we make a function with evalBool for a common task: 
getting the absolute path from a relative path. The typical problem faced is 
that you get an error if you try to get the path of a non-existent directory. 
This protects you from that:
```bash
get_abs_path () {
	if `evalBool "[ -d "$1" ]"`; then
		echo `cd "$1"; pwd`
	fi
}
```
here it is in use:
```bash
path=$(get_abs_path "../")
echo "$path"                       # displays path

echo `cd "./dontexist"; pwd`       # throws error

path=$(get_abs_path "./dontexist") # avoids error
echo "$path"                       # prints nothing
```
Here is a more advanced example of a function that uses evalBool:
```bash
finder () {
	for arg in ${@:2}; do
		if `evalBool "${!1}" "${!arg}"`; then
			echo "$arg passed"
		fi
	done
}
```
You can save "tests" like this:
```bash
is_yes='[ "$2" == "yes" ]'
is_no='[ "$2" == "no" ]'
is_whatever='[ "$2" == "whatever" ]'
is_empty='[ -z "$2" ]'
```
Here is an example where you have a number of variable and you want to find 
out which one passes each test
```bash
 var1='yes'
 var2='no'
 var3=''
 var4='whatever'
```
We can use our finder function to search for the match and echo the output:
```bash
finder is_yes var1 var2 var3 var4      # prints: var1 passed
finder is_no var1 var2 var3 var4       # prints: var2 passed
finder is_empty var1 var2 var3 var4    # prints: var3 passed
finder is_whatever var1 var2 var3 var4 # prints: var4 passed
```

## eBool

`eBool` is just `evalBool` with the `[` and `]` automatically inserted:
```bash
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
```
It makes for slightly cleaner syntax. Here is an example of of a saving to a variable without `evalBool` or `eBool`:  
```bash
[ -d "./.git" ] && git_found=true || git_found=false
echo $git_found
```
now:
```bash
# with evalBool:
git_found=$(evalBool '[ -d ./.git ]')
# with eBool:
git_found=$(eBool '-d ./.git')

echo $git_found
```
Both are printable directly:
```bash
evalBool '[ -d ./.git ]'
eBool '-d ./.git'
```



