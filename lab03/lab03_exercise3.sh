#!/bin/bash

# As in many other programming languages, it is good practice to use uppercase for constants, but with a twist!: To avoid the risk of overwriting system environment variables (e.g., $PATH or $HOME), they should start with a unique prefix (commonly the character "_").
_LOGFILE="process_log.txt"
# Logfile location

# for loop to count to 10
for c in {1..5}; do
	echo "Count: $c"

	# if does not use == it uses -eq
	# note the spaces around if [ ]
	if [ $c -eq 3 ]; then
		echo "found the third item"
	fi
done

# how do we pass parameters from the command line
# into this bash script. 
# we use the notation $1, $2 etc to represent
# the first, second etc parameter into this script
if [ -z $1 ]; then
	echo "You didn't pass any paraemters to $0"
else
	echo "You passed in $1 to $0"
fi





# heres a brand new command: 
# it calls ps -ef, then pipes it into word counter
# then stores the result in ct
ct=$(ps -ef | wc -l)
echo "There are $ct processes running on this machine"




# Validate the supplied process threshold (first, if the number of expected parameters is right, then check if $1 is a number).
# Common error: Missing/non-numeric input causes comparison errors.
if [[ $# -ne 1 || ! $1 =~ ^[0-9]+$ ]]; then
	# Always a good practice in Bash to send the errors to stderr (i.e., ">&2" instead of stdout.
    echo "Usage: $0 <maximum_processes>" >&2
    # Likewise, one should stop execution if critical errors found (like missing mandatory parameters!).
	exit 1
fi

# Count running processes.
ct=$(ps -ef | wc -l)
#ct=$(( $(ps -ef | wc -l) - 1 )) 	#Alternative command, if you want to remove the ps header from the count and be more accurate.

# Compare the actual count against the supplied maximum.
# Common error: Reversed comparisons or incorrect equality handling.
if [ "$ct" -gt "$1" ]; then
    echo "Maximum number of processes exceeded"
else
    echo "The maximum number of processes NOT exceeded"
fi


# Send the result to the requested destination only.
# Common error: Ignoring the selected output mode.
if [ "$2" = "screen" ]; then
    echo "$message"
else
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$timestamp - $message" >> "$_LOGFILE"
fi
