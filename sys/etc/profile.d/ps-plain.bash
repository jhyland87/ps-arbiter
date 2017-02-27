#!/bin/bash

[[ -n $PROMPT_COMMAND ]] && unset PROMPT_COMMAND

uid=$(id -u >&1)

if [[ $uid -eq 0 ]]
then
 export PS1="# "
else
 export PS1="$ "
fi
