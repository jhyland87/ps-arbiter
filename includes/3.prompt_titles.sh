#!/usr/local/Cellar/bash/4.4.12/bin/bash

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