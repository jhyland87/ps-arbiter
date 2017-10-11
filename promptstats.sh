#!/usr/local/Cellar/bash/4.4.12/bin/bash

[[ -n $PROMPT_COMMAND ]] && unset PROMPT_COMMAND

plain='\[\e[0m\]'
bold='\[\e[1m\]'        
error='\[\e[0;91m\]'    # Same as red, but can be changed - only used for error codes
success='\[\e[0;92m\]'  # Same as green, but can be changed - only used for success code (green check)
grey='\[\033[1;30m\]'   # Used for neutral colors (parenthesis, brackets, etc)
blue='\[\e[0;94m\]'     # Used for PWD
red='\[\e[31;1m\]'      # Used for main prompt color when user is root
green='\[\e[0;92m\]'    # Used for main prompt when user is not root

. /Users/jhyland/Documents/scripts/bash/test/colors.sh

declare -A promptcfg
promptcfg[defaultpid]=2

declare -A prompts

prompts[1:basic:simple:prompt]='%prompt% '
prompts[2:status:result:exitstatus]='(%cmdstatus%)%prompt% '
prompts[3:stattime:timestamp]='[%timestamp%](%cmdstatus%)%prompt% '
prompts[3:stattime:timestamp]='[%timestamp%](%cmdstatus%)%prompt% '
prompts[4:pwd]='[%pwd%](%cmdstatus%)%prompt% '
prompts[5:cmds]='%cmdnum%'
prompts[6:date]='%date% '
prompts[7:time]='%time% '
prompts[8:timestamp]='%timestamp% '
prompts[9:advanced]='(${gry}%sessions%${txtrst})[${bldgry}%timestamp%${txtrst}]{%cmdnum%}${bldgrn}%username%@%hostname%${txtrst}:${bldblu}%pwd%${txtrst}${gry}(${txtrst}%cmdstatus%${gry})${txtrst}%prompt% '
prompts[10:elapsed]="%elapsed%"
prompts[11:escapechars:escape]="%escapechars%"

declare -A prompt_titles

#($grey\#$plain)$plain[$grey\d \T$plain]$plain[$bold$elapsed]{$grey$sess_count$plain}$color\u@\h$plain:$blue\w$grey(\`if [ \$? = 0 ]; then echo \"$success\342\234\223$plain\"; else echo \"$error$status$plain\"; fi\`$grey)$plain$suffix 

#(sessions)[timestamp][elapsed]{cmdnum}username@hostname:~(exitstatus)$

for p in ${!prompts[@]}; do
  p_idx=$(echo "${p}" | cut -d: -f1)
  p_aliases=$(echo "${p}" | cut -d: -f2- | tr ':' ' ')
  promptkeys=$(echo "${p}" | tr ':' ' ')
  prompt_titles[$p_idx]="${p_aliases}"

  for p2 in $(echo "${p}" | tr ':' ' '); do
    prompts[${p2}]=${prompts[${p}]}
    #printf "%-20s : %s\n" "${p2}" "${prompts[${p}]}"
  done
done

declare -A replacements

#replacements[]=""
replacements[cmdnum]="\\\#"
replacements[uid]=$(id -u)
replacements[gid]=$(id -g)
replacements[fullname]=$(id -F)
replacements[tty]="$(tty | sed 's^/dev/^^g')"
replacements[sessions]=$(who | wc -l)
replacements[date]="\\\d"
replacements[time]="\\\T"
#replacements[timestamp]=$(date +"%a %b %d %T %Z %Y")
replacements[timestamp]="\\\d \\\T"
replacements[epoch]=$(date +"%s")
replacements[username]=$(whoami)
#replacements[pwd]=$(pwd)
replacements[pwd]="\\\w"
replacements[dir]="\\\W"
replacements[prompt]="\$"
replacements[bashv]="\\\V"
[[ $(id -u) -eq 0 ]] && replacements[prompt]='#'
replacements[hostname]=$(hostname -f)
replacements[procs]=$(ps -U jhyland | sed 1d | wc -l)
replacements[gitbranch]=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
replacements[jobs]="$(jobs -sp | wc -l)r/$(jobs -rp | wc -l)s" # Show jobs running and stopped like "3r/1s"
replacements[escapechars]="a: \\\a\\\nd: \\\d\\\nh: \\\h\\\nH: \\\H\\\nj: \\\j\\\nl: \\\l\\\ns: \\\s\\\nt: \\\t\\\nT: \\\T\\\n@: \\\@\\\nA: \\\A\\\nu: \\\u\\\nv: \\\v\\\nV: \\\V\\\nw: \\\w\\\nW: \\\W\\\n"


