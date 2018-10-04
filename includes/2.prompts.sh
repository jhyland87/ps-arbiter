#!/usr/local/Cellar/bash/4.4.12/bin/bash

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