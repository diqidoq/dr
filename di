#!/bin/bash

di_init () {
  # color variables
  r='\033[0;31m';g='\033[0;32m';y='\033[0;33m';b='\033[0;34m';m='\033[0;35m';c='\033[0;36m'
  # Clear the color by default
  w='\033[0m'
  # some repeatable strings and interaction commands
  YESNO () {
    read -p " yY(es)/nN(o): " -n 1 -r ; printf "\n"
  }
  CHOOSE () {
    printf "\nDo you want to ${g}${1}${w}?" ; YESNO
  }
  SKIP () {
    printf "\nOk. ${g}Skipped${w} for now.\n."
  }
  ABORD () {
    printf "\n${g}Abord script${w} for now.\n." ; exit 1
  }
  INPROGRESS () { 
    printf "This feature is unsupported yet but in progress." ; ABORD
  }
  STOPERROR="${r}Error: Stopped (di) Drupal Install command!${w}"
  PRESSENTER="[Press ${g}ENTER${w} or ${g}RETURN${w} to go ahead. PRESS ${g}CTRL/C${w} to stop]"
  # @todo Which we can change programmatically on respective different tasks later.
  label="extension(s)"
}

di_check () {
  # Check if Composer exist and if we are in Composer/Drupal project root before continue.
  # Order is intentional. Missing arguments can be wanted to dry run command.
  if ! command -v composer &> /dev/null ; then
    printf "\n${STOPERROR}\nComposer could not be found.\n\n" ; ABORD
  elif [[ ! -f "composer.json" ]] ; then
    printf "\n${STOPERROR}\nAre we in the proper Composer init root? A ${g}composer.json${w} file does not exist here in path.\n\n" ; ABORD
  elif [[ ! -d "web/core" ]] ; then
    printf "\n${STOPERROR}\nAre we in a Drupal project root? A ${g}web/core${w} directory does not exist here in path.\n\n" ; ABORD
  elif [ "$#" -eq 0 ] ; then
    printf "\n${STOPERROR}\nArguments Count: 0 - No arguments provided.\n\n" ; ABORD
  fi
}

di_load () {
  # Checking for leading -flag in arguments to set modus operandi.
  case "${1}" in
    -r) # uninstall & remove | shortlink: dr
      DI_MODE="remove" ; shift
      ;;
    -c) # checkout module info | shortlink: dc
      DI_MODE="info" ; shift
      ;;
    -n) # renew (update) | shortlink: dn (du is a linux command already)
      DI_MODE="update" ; shift
      ;;
    #
    # Now flags without additional arguments, without selected extensions.
    #
    -s) # update status overview | shortlink: ds
      DI_MODE="show --outdated"
      ;;
    -upd) # update all drupal/* -W | shortlink: dupd (for historical reasons)
      DI_MODE="update-all"
      ;;
    -bkp) # backup of directory  & database. | shortlink dbkp
      DI_MODE="backup"
      ;;
    -prm) # repair all file permissions in project dir. shortlink dprm
      DI_MODE="repair-permissions"
      ;;
    #
    # finally the install mode wich needs no flag and has no other shortlink.
    #
    *) # install and enable
      DI_MODE="install"
      ;;
  esac
  
  if [[ "${1}" == +(*.log|*.txt|*.csv) ]] ; then
    DI_ARGTYPE="file" # flag for future reference and modus operandi.
    while read line ; do
      echo "${line}"
    done < ${1}
    exit 1
  else
    printf "You choose input arguments (not a file)."
    DI_ARGTYPE="input" # flag for future reference and modus operandi."
    Arguments=$@
    # To collect and fix multiple arguments input like 1, 2,3 4 5
    # so that it will be interpreted like 1 2 3 4 5 (as 5 arguments)
    # we do some string split replace and prepare an arguments array.
    if [[ $Arguments == *","* ]] ; then
      # Let's confirm arguments repair and split on separator by the user - just in case.
      printf "\n${r}Attention:${w} Seems that you used ${r}comma separated multiple arguments.${w}\n Some users use comma and space, some not. We will check and repair this. Do you want to go ahead? ${PRESSENTER}"
      read -p " ... "
      Arguments=$(sed 's/,/, /g' <<< "$Arguments")
      Arguments=$(sed 's/,//g' <<< "$Arguments")
    fi
    # Final whitespace cleanup and conversion into Array.
    Arguments=$(sed 's/  / /g' <<< "$Arguments")
  fi
  
  IFS=' '
  read -ra Arguments_Array <<< "$Arguments"
}

di_drush_cache_clear () {
  CHOOSE "clear Drupal caches" ; [[ "$REPLY" =~ ^([yY][eE][sS]|[yY])$ ]] && drush cr || SKIP
}
di_drush_cron_run () {
  CHOOSE "run Drupal cron" ; [[ "$REPLY" =~ ^([yY][eE][sS]|[yY])$ ]] && drush cron || SKIP
}

# consumes internal argument pm-install or pm-uninstall passed via install() or remove() function
di_drush_routine () {
  if ! command -v drush &> /dev/null ; then
    printf "${g}Drush${w} seems ${r}not to be installed${w} in your Drupal installation or\n you missed to install the Drush Launcher or other Drush detection method like recommended in the install README of -di-.\n" ; SKIP
  else
    CHOOSE "${1} ${label} via Drush"
    if [[ "$REPLY" =~ ^([yY][eE][sS]|[yY])$ ]] ; then
      drush ${1} $(for i in "${Arguments_Array[@]}"; do printf " $i" ; done)
    else
      SKIP
    fi
  fi
}

# Drupal specific Composer routine consuming internal argument require or remove.
di_composer_drupal_routine () {
  CHOOSE "${1} ${label} via Composer"
  if [[ "$REPLY" =~ ^([yY][eE][sS]|[yY])$ ]] ; then
    composer ${1} $(for i in "${Arguments_Array[@]}"; do printf " drupal/$i" ; done)
  else
    SKIP
  fi
}

di_composer_info_routine () {
  CHOOSE "${1} ${label} information via Composer"
  if [[ "$REPLY" =~ ^([yY][eE][sS]|[yY])$ ]] ; then
    for i in "${Arguments_Array[@]}"; do 
      composer ${1} -a drupal/$i | grep -e descrip -e versions --color=auto && printf "\n-----------------------------------\n\n"
    done
    CHOOSE "install ${label} now"
    if [[ "$REPLY" =~ ^([yY][eE][sS]|[yY])$ ]] ; then
      di_install
    fi
  else
    SKIP
  fi
}

di_drush_eval_get_bundle_info () {
  drush php-eval "print_r(array_keys(\Drupal::service('entity_type.bundle.info')->getBundleInfo('$1')));"
}

di_install () {
  di_composer_info_routine show
  di_composer_drupal_routine require
  di_drush_routine pm-install
  di_drush_cache_clear
}

di_remove () {
  di_drush_routine pm-uninstall
  di_composer_drupal_routine remove
  di_drush_cache_clear
  di_drush_cron_run
}

di_info () {
  di_composer_info_routine info
}

di_outdated () {
  INPROGRESS
}

di_update () {
  INPROGRESS
}

di_init
di_check $@
di_load $@

if [[ "${DI_MODE}" == "remove" ]] ; then
  di_remove
elif [[ "${DI_MODE}" == "info" ]] ; then
  di_info
elif [[ "${DI_MODE}" == "update" ]] ; then
  di_update
else
  di_install
fi

printf "\n${g}Done!${w}\n"
exit 0
