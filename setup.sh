#!/usr/local/bin/bash4

. ./path-subst.sh

altrpath "test"

exit

sysfilesdir="./sysfiles"

sysdirs=$(find ${sysfilesdir} -mindepth 1 -type d)

colwid=$(echo "${sysdirs}" | awk 'BEGIN{w=0;}{l=length($0); if(l>w) w=l;}END{print w;}')

#find ${sysfilesdir} -mindepth 1 -not -type d

while read f; do
  #printf "%-${colwid}s ... " "${f}"
  #. ${f} 2>/dev/null

  printf "%-15s : %s\n" "File" "${f}"

  destdir=$(echo "${f}" | sed -E -e "s%^${sysfilesdir}%%")

  printf "%-15s : %s\n" "Dest" "${destdir}"

  continue
  #ERROR=$(. ${f} 2>/dev/null 2>&1 >/dev/null)
  ERROR=$(stat ${f} 2>/dev/null 2>&1 >/dev/null)
  
  r=$?
  if [[ $r -eq 0 ]]; then
    echo "OK"
    continue
  fi

  printf "%s %s\n" "ERROR" "${ERROR}"
done < <(echo "${sysdirs}")


exit


colwid=$(find sysfiles -mindepth 1 -type f | awk 'BEGIN{w=0;}{l=length($0); if(l>w) w=l;}END{print w;}')

folders=$(find sysfiles -mindepth 1 -type d)

while read f; do
  printf "%-${colwid}s ... " "${f}"
  #. ${f} 2>/dev/null

  #ERROR=$(. ${f} 2>/dev/null 2>&1 >/dev/null)
  ERROR=$(stat ${f} 2>/dev/null 2>&1 >/dev/null)
  
  r=$?
  if [[ $r -eq 0 ]]; then
    echo "OK"
    continue
  fi

  printf "%s %s\n" "ERROR" "${ERROR}"
done < <(find sysfiles -mindepth 1 -type f)

