#!/bin/bash

incdir="./includes"

if [[ ! -d ${incdir} ]]; then
  echo "Unable to find the includes folder" 1>&2
  exit 1
fi

while read f; do
  . ${f}
done < <(ls -c1 ${incdir}/*.sh | sort)