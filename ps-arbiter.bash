#!/bin/bash

#printenv

if [[ ! -d /etc/profile.d ]]
then
  echo "There doesn't seem to be an /etc/profile/d directory" 1>&2
  exit 1
fi

ps_scripts=$(find /etc/profile.d -type f -exec basename {} \;)

if [[ $? != 0 ]] || [[ $(echo "${ps_types}" | wc -w) == 0 ]]
then
  echo "Failed to determine the available PS types by reading the files in /etc/profile.d"
  exit 1
fi

ps_scripts_short=()
ps_scripts_full=()

for scr in 
do
  echo \"${scr}\" | awk 'match($0, /ps-([a-zA-Z]+)(\.[bash]*)?/, res ){ print $0 }' >/dev/null

  if [[ $? != 0 ]]
  then
    echo "Error parsing the filename '${scr}'" 1>&2
  else
    ps_scripts_full[${#ps_scripts_full[*]}]="$(echo \"${scr}\" | awk 'match($0, /ps-([a-zA-Z]+)(\.[bash]*)?/, res ){ print $0 }')"
    ps_scripts_short[${#ps_scripts_short[*]}]="$(echo \"${scr}\" | awk 'match($0, /ps-([a-zA-Z]+)(\.[bash]*)?/, res ){ print res[1] }')"
  fi
done

shell_lvl=${SHLVL:-1}
user_home=${HOME:-/home/$(whoami)}

function preferredps {
  if [[ -r "${user_home}/.PS${shell_lvl}" ]]
  then
    cat "${user_home}/.PS${shell_lvl}" | tr '[A-Z]' '[a-z]'
    return 0
  elif [[ -r "${user_home}/.PS" ]]
  then
    cat "${user_home}/.PS" | tr '[A-Z]' '[a-z]'
    return 0
  else
    echo "${ps_types[0]}"
  fi
}

function setps {
  if [[ -n $1 ]]
  then
    preferred=$( echo "${1}" | tr '[A-Z]' '[a-z]')
  elif [[ -n $(preferredps) ]]
  then
    preferred=$(preferredps)
  else
    echo "No PS type provided or found" 1>&2
    return 1
  fi

  # awk 'BEGIN { FS="."; } { if( match( $0, /sass/ ) && $2 == "sublime-project" ) print $1 }'
  # find /etc/profile.d -type f -exec basename {} \; | awk 'match($0, /ps-([a-zA-Z]+)(\.[bash]*)?/, res ){ print res[1] }' | tr '\n' ' '
  if [[ " ${ps_types_arr[*]} " != *" ${preferred} "* ]]; then
    echo "The PS type '${preferred}' was not found"
    return 1
  fi

  echo "Found PS type ${preferred}"
  

}
