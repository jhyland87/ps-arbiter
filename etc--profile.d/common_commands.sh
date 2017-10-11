#!/usr/local/Cellar/bash/4.4.12/bin/bash

function setps {
  set_begin() {
  [[ -z "$begin" ]] && begin="$(date +"%s %N")"
}

calc_elapsed() {
  # Thresholds for command execution time (seconds)
  warn_threshold='300'      # 5 minutes
  danger_threshold='3600' # 1 hour
  
  read begin_s begin_ns <<< "$begin"
  begin_ns="${begin_ns##+(0)}"
  # PENDING - date takes about 11ms, maybe could do better by digging in
  # /proc/$$.  
  read end_s end_ns <<< $(date +"%s %N")
  end_ns="${end_ns##+(0)}"
  local s=$((end_s - begin_s))
  local ms
  
  [[ "$end_ns" -ge "$begin_ns" ]] && ms=$(((end_ns - begin_ns) / 1000000)) || ( s=$((s - 1)); ms=$(((1000000000 + end_ns - begin_ns) / 1000000)) )
  
  elapsed="$(printf " %2u:%03u" $s $ms)"
  
  [[ "$s" -ge 300 ]] && elapsed="$elapsed [$(human_time $s)]"
  
  # If the last execution elapsed time is greater than one of the above thresholds, then
  # set the color to red or yellow
  if [[ $s -gt $danger_threshold ]]; then
    elapsed="\[\e[31;1m\]$elapsed$plain"
  elif [[ $s -gt $warn_threshold ]]; then
    elapsed="\[\e[33m\]$elapsed$plain"
  fi

  echo "elapsed: $elapsed"
}

function showusage {
  printf "%-5s %s\n" "ID" "ALIASES" 1>&2

  for p in ${!prompt_titles[@]}; do
    printf "%-5s %s\n" "${p}" "${prompt_titles[$p]}" 1>&2
  done

  echo -e "\nUsage" 1>&2
  echo -e "  setps 1" 1>&2
  echo -e "  setps simple" 1>&2
  echo -e "  setps advanced" 1>&2
}

human_time() {
  local s=$1
  local days=$((s / (60*60*24)))
  s=$((s - days*60*60*24))
  local hours=$((s / (60*60)))
  s=$((s - hours*60*60))
  local min=$((s / 60))
  
  [[ "$days" != 0 ]] && local day_string="${days}d "
  
  printf "$day_string%02d:%02d\n" $hours $min
} 
  declare prompts

  prompts[0]='%prompt% '
  prompts[1]='(%cmdstatus%)%prompt% '
  prompts[2]='[%timestamp%](%cmdstatus%)%prompt% '

  declare -A replacements

  replacements[prompt]="#"
  [[ $(id -u) -eq 0 ]] && replacements[prompt]='#'
  replacements[timestamp]=$(date +"%a %b %d %T %Z %Y")

  # echo '[%timestamp%](%cmdstatus%)%prompt% ' | sed -e "s/%timestamp%/$(date +"%a %b %d %T %Z %Y")/g" -e "s/%prompt%/\$/g" -e "s/%cmdstatus%/0/g"

  function _promptx {
    cmdstat=$?

    . /Users/jhyland/promptstats.sh

    replacements[elapsed]=$elapsed
    replacements[cmdstatus]=$cmdstat

    promptid=$1

    # If the prompt ID is unspecified, default it back to the normal
    if [[ -z $promptid ]]; then
      . /etc/profile.d/ps1.sh

    # Otherwise, check that its a valid prompt, then use it
    elif [[ -z ${prompts[${promptid}]} ]]; then
      echo "${promptid} is not a valid prompt ID or alias" 1>&2
      echo
      showusage
      return 1
    fi

    prompttfmt="${prompts[${promptid}]}"

    for r in ${!replacements[@]}; do
      prompttfmt=$(echo -e "${prompttfmt}" | sed "s^%$r%^${replacements[$r]}^g")
    done

    PS1="${prompttfmt}"

    begin=
  }

  if [[ -z $1 ]]; then
    . /etc/profile.d/ps1.sh
  elif [[ $1 == 'help' ]] || [[ $1 == '--help' ]]; then
    showusage
  else
    set_begin
    trap set_begin DEBUG
    PROMPT_COMMAND="_promptx ${1}"
  fi
}