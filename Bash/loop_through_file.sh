#!/usr/bin/sh
# Creator: Chase Merola
# When: 8/20/2020 @ 12:06
# Purpose: Provide a template for rapid development of looping scripts while including the typical desired functionality such as:
#     1) Optional verbose for debugging
#     2) Basic Input Sanitation
#     3) Easy Color Formatting
#     4) Execution Times
#     5) Easy Logging
#     6) File Locking (to ensure only one instance at any given moment)
#     7) Commentary / Explanations

#---- Usage
# ./loop_through_file.sh loop_through_file_sample.txt

#---- Notes
#@ This script is unique, and will likely need to be modified to operate properly on other systems. YOU MUST provide it with the data to process.
#@ "builtin echo" prints to the terminal regardless of verbose argument

#---- Changelog
#@ 08/20/2020 - Creation

#---- Colorizing for interactive usage
#normal=$(tput sgr0)                      # normal text
normal=$'\e[0m'                           # (works better sometimes)
bold=$(tput bold)                         # make colors bold/bright
red="$bold$(tput setaf 1)"                # bright red text
green=$(tput setaf 2)                     # dim green text
fawn=$(tput setaf 3); beige="$fawn"       # dark yellow text
yellow="$bold$fawn"                       # bright yellow text
darkblue=$(tput setaf 4)                  # dim blue text
blue="$bold$darkblue"                     # bright blue text
purple=$(tput setaf 5); magenta="$purple" # magenta text
pink="$bold$purple"                       # bright magenta text
darkcyan=$(tput setaf 6)                  # dim cyan text
cyan="$bold$darkcyan"                     # bright cyan text
gray=$(tput setaf 7)                      # dim white text
darkgray="$bold"$(tput setaf 0)           # bold black = dark gray text
white="$bold$gray"                        # bright white text
# Example --> echo "${red}Red ${yellow}yellow ${green}green${normal}back to normal"

#- Insert newline for cleanliness
printf "\n"

# date_atomic
exactdate=$(date +"%Y-%m-%d %H:%M:%S.%N")

# Calculate time to execute
startdate=$(date +%s.%N)

# server hostname
HOSTNAME=$(hostname)

# lookup the scripts location
scriptpath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#echo $SCRIPTLOC

# lookup the name of this script
scriptname=`basename $0`

# log file
logfile="${scriptname%.*}.log"

#---- Check if any input was provided
if [ $# -eq 0 ] ; then
	echo "${red}No arguments supplied ${normal}"
	echo "${yellow}Usage:${green} .$scriptpath/$scriptname ${cyan}loop_through_file_sample.txt ${purple}[Optional Args: --verbose]${normal}"
	echo ""
	exit 1
fi

#---- Check if line delimited file was provided
if [ -z "$1" ] || [[ $1 == *"--verbose"* ]] ; then
	echo "${red}No arguments supplied ${normal}"
	echo "${yellow}Usage:${green} .$scriptpath/$scriptname ${cyan}loop_through_file_sample.txt ${purple}[Optional Args: --verbose]${normal}"
	echo ""
  exit 1
fi

if [[ "$*" == *--verbose* ]]; then
  INSTRUMENTING=yes  # any non-null will do
#  shift
fi
echo () {
  [[ "$INSTRUMENTING" ]] && builtin echo "$@"
}

# builtin echo's regardless of verbose argument
builtin echo "${yellow}`date +"%Y-%m-%d %H:%M:%S.%N"`: ${green}======= Initializing ========${normal}"
builtin echo "`date +"%Y-%m-%d %H:%M:%S.%N"`: ======= Initializing ========" >> "$logfile"

# Declare stuff or functions

builtin echo "${yellow}`date +"%Y-%m-%d %H:%M:%S.%N"`: ${green}======= Looping through $1 ========${normal}"
builtin echo "`date +"%Y-%m-%d %H:%M:%S.%N"`: ======= Looping through $1 ========" >> "$logfile"

echo "" # Cleanliness

#---- Loop Through Provided List
cat $1 |\
while IFS= read -r line ; do
  echo "${yellow}Found:${purple} $line ${normal}" # fyi this is only visable if --verbose is used.
done

echo "" # Cleanliness

enddate=$(date +%s.%N)
runtime=$(python -c "print(${enddate} - ${startdate})")
#=========================================================================
# builtin echo's regardless of verbose argument
builtin echo "${yellow}`date +"%Y-%m-%d %H:%M:%S.%N"`: ${green}======= Ending - Total script runtime in $runtime seconds ========${normal}"
builtin echo "`date +"%Y-%m-%d %H:%M:%S.%N"`: ======= Ending - Total script runtime in $runtime seconds ========" >> "$logfile"

#- Insert newline for cleanliness
printf "\n"