#!/bin/bash

# color variables
r='\033[0;31m'
g='\033[0;32m'
y='\033[0;33m'
b='\033[0;34m'
m='\033[0;35m'
c='\033[0;36m'
# Clear the color after that
w='\033[0m'

# some repeatable strings and interaction commands
YESNO () { read -p " yY(es)/nN(o): " -n 1 -r && printf "\n" }
CHOOSE () { printf "\nDo you want to ${g}${1}${w}?" && YESNO }
SKIPPED () { printf "\nOk. ${g}Skipped${w} for now.\n." }
STOPERROR="${r}Error: Stopped (di) Drupal Install command!${w}"
PRESSENTER="[Press ${g}ENTER${w} or ${g}RETURN${w} to go ahead. PRESS ${g}CTRL/C${w} to stop]"

if ! command -v composer &> /dev/null ; then
  printf "\n${STOPERROR}\nComposer command could not be found.\n\n"
  exit 1
elif [[ ! -d "vendor/composer" ]]; then
  printf "\n${STOPERROR}\nAre we in project root? The ${g}vendor/composer${w} directory is missing here in path.\n\n"
  exit 1
elif [[ ! -f "composer.json" ]]; then
  printf "\n${STOPERROR}\nAre we in project root? The ${g}composer.json${w} file does not exist here in path.\n\n"
  exit 1
elif [ "$#" -eq 0 ]; then
  printf "\n${STOPERROR}\nArguments Count: 0 - No arguments provided.\n\n"
  exit 1
fi

getargs () {
# To collect anf fix arguments input like 1, 2,3 4 5
# so that it will be interpreted like 1 2 3 4 5 (as 5 arguments)
# we do some string split replace and prepare an array.
EXT=$@
if [[ $EXT == *","* ]] ; then
  printf "\n${r}Attention:${w} Seems that you used ${r}comma to provide multiple arguments.${w}\nDo you want to go ahead with seperated arguments? ${PRESSENTER}"
  read -p " ... "
  EXT=$(sed 's/,/, /g' <<<"$EXT")
  EXT=$(sed 's/,//g' <<<"$EXT")
fi
EXT=$(sed 's/  / /g' <<<"$EXT")
IFS=' '
read -ra ARGS <<< "$EXT"
}

# consumes argument en or dis (-able) inside install() or remove()
drush_routine () {
  if ! command -v drush &> /dev/null ; then
    printf "${g}Drush${w} seems ${r}not to be installed${w} in your Drupal installation or\n 
    you missed to install the Drush Launcher like recommended in the install README of -di-.\n" ; SKIPPED
  else
    CHOOSE "${1}able ${ARGS[@]} via Drush"
    if [[ "$REPLY" =~ ^([yY][eE][sS]|[yY])$ ]] ; then
      drush ${1} $(for i in "${ARGS[@]}"; do printf " $i" ; done)
      CHOOSE "clear Drupal caches" ; [[ "$REPLY" =~ ^([yY][eE][sS]|[yY])$ ]] && drush cr || SKIPPED
      CHOOSE "run Drupal cron" ; [[ "$REPLY" =~ ^([yY][eE][sS]|[yY])$ ]] && drush cron || SKIPPED
    else
      SKIPPED
    fi
  fi
}

# Drupal specific Composer routine consuming argument require or remove.
composer_drupal_routine () {
  CHOOSE "${1} ${ARGS[@]} via composer"
  [[ "$REPLY" =~ ^([yY][eE][sS]|[yY])$ ]] && composer ${1} $(for i in "${ARGS[@]}"; do printf " drupal/$i" ; done) || SKIPPED
}

install() {
  composer_drupal_routine require
  drush_routine en
}

remove () {
  drush_routine dis
  composer_drupal_routine remove
}

[[ "${1}" == '-r' ]] && shift ; getargs ; remove || getargs ; install

printf "\n${g}Done!${w}\n"
exit 0