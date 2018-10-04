#!/usr/local/Cellar/bash/4.4.12/bin/bash

[[ -n $PROMPT_COMMAND ]] && unset PROMPT_COMMAND

. /Users/jhyland/Documents/scripts/bash/test/colors.sh

incdir="./includes"

if [[ ! -d ${incdir} ]]; then
  echo "Unable to find the includes folder" 1>&2
  exit 1
fi

collen=$(ls -c1 ${incdir}/*.sh | awk 'BEGIN{w=0;}{l=length($0); if(l>w) w=l;}END{print w;}')

while read f; do
  printf "%-${collen}s ... " "${f}"
  #. ${f} 2>/dev/null

  ERROR=$(. ${f} 2>/dev/null 2>&1 >/dev/null)

  r=$?
  if [[ $r -eq 0 ]]; then
    echo "OK"
    continue
  fi

  printf "%s %s\n" "ERROR" "${ERROR}"
done < <(ls -c1 ${incdir}/*.sh | sort)