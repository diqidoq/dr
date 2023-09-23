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

# To fix confusing arguments input like 1, 2,3 4 5
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

composer require $(for i in "${ARGS[@]}"; do printf " drupal/$i" ; done)

if ! command -v drush &> /dev/null ; then
  printf "${g}Drush${w} seems ${r}not to be installed${w} in your Drupal installation. So enabling Drupal extension via Drush has been left out of this procedure this time.\n\n"
else
  printf "\nDo you want to ${g}enable the extensions via Drush (pm-install)${w}?"
  read -p " Y(es)/N(o): " REPLY

  if [[ "$REPLY" =~ ^([yY][eE][sS]|[yY])$ ]] ; then
    drush en $(for i in "${ARGS[@]}"; do printf " $i" ; done) && drush cr && drush cron
  else
    printf "\n${g}Ok, Let's finish without installing.${w}\n"
  fi
fi

printf "\n${g}Done!${w}\n"
exit 0
