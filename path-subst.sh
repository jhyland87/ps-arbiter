#!/usr/local/bin/bash4

declare -A pathsubst

pathsubst["~"]="${HOME}"
pathsubst["HOME"]="${HOME}"
pathsubst["PWD"]="$(pwd)"
pathsubst["ROOT"]="/"
pathsubst["TMPDIR"]="/tmp"

# 
# 
# 
# 
function altrpath {
  orig="${1}"
  result="${1}"

  while read p; do
    r=${pathsubst[$p]}
    result=$(echo "${result}" | sed -E "s@%${p}%@${r}@g")
  done < <(echo "${!pathsubst[@]}" | tr ' ' '\n')

  result=$(echo "${result}" | sed -E "s@//@/@g")
  result=$(echo "${result}" | sed -E "s@ @\\\ @g")

  #echo "Original: ${orig}"
  #echo "Result: ${result}"

  echo "${result}"
}

Any of my nerd friends on here know a way to register a .it domain if you dont reside in (or have a company/business that resides in) one of the required countries? (UK, Austria, Spain, Sweden, Italy, etc)
I tried to use a Trustee Service (Netim.com) to no avail, and I'm tyring Marcaria.com, but not sure that will succeed either.

you are NOT in one of the requred countries? (


Austria, Belgium, Bulgaria, Croatia, Cyprus, Czech Republic, Denmark, Estonia, Finland, France, Germany, Gibraltar, Greece, Holy See (VaticanCity), Hungary, Iceland, Ireland, Italy, Latvia, Liechtenstein, Lithuania, Luxembourg, Malta, Martinique, Mayotte, Netherlands, Norway, Poland, Portugal, Romania, San Marino, Slovakia, Slovenia, Spain, Sweden, Switzerland, United Kingdom