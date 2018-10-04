#!/usr/local/Cellar/bash/4.4.12/bin/bash

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

