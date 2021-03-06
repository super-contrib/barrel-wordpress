#!/bin/bash

####################################################################
## This test script is used to validate the syntax of each .json file
## contained within the theme directory provided using the
## json_decode() function of PHP. 
####################################################################

# Terminal colors
DEFAULT=$(tput setaf 7 -T xterm)
RED=$(tput setaf 1 -T xterm)
GREEN=$(tput setaf 2 -T xterm)
YELLOW=$(tput setaf 3 -T xterm)
BLUE=$(tput setaf 4 -T xterm)

## Check if module name was provided before moving on
if [ -z ${THEME_NAME+x} ]; then
    echo "${YELLOW}Hmm... Looks like you didn't set a theme name yet. What theme are we evaluating?${DEFAULT}"
    read THEME_NAME
fi

INVALID_FILES=""
THEME_LOCATION="wp-content/themes/$THEME_NAME"

printf "Switching to the theme directory in $THEME_LOCATION..\n"
cd $THEME_LOCATION

printf "Validating json files in the $THEME_NAME theme\n"
while read -r line; do
    echo "Testing $line..."
    php -r "if ( ! json_decode(file_get_contents('$line')) ) { exit(1); }"
    if [ $? -ne 0 ]; then
        INVALID_FILES+="$line\n"
    fi
done <<< "$(find . -type f -name '*.json' -not -path './node_modules/*')"

if [ -z "$INVALID_FILES" ]; then
    echo "${GREEN}All JSON files look ok. Moving on ...${DEFAULT}"
    exit
else
    printf "\n${RED}JSON Syntax errors were found in the ${THEME_NAME} theme. Please check the syntax of the following files and fix any errors.${DEFAULT}\n"
    printf "\nINVALID JSON FILES:\n${INVALID_FILES}"
    exit 1;
fi