#!/bin/bash

# Text color variables
txtund=$(tput sgr 0 1) # Underline
txtbld=$(tput bold)    # Bold
txtrst=$(tput sgr0)    # Reset
txtulb="$(tput sgr 0 1)$(tput bold)" # Bold and Underline

# Base colors
red=$(tput setaf 1) 
grn=$(tput setaf 2)
yel=$(tput setaf 3)
blu=$(tput setaf 4)
pnk=$(tput setaf 5)
cya=$(tput setaf 6)
wht=$(tput setaf 7)
gry=$(tput setaf 8)

# BOLD colors
bldred=${txtbld}${red} #  red
bldgrn=${txtbld}${grn} #  green
bldyel=${txtbld}${yel} #  yellow
bldblu=${txtbld}${blu} #  blue
bldpnk=${txtbld}${pnk} #  pink
bldcya=${txtbld}${cya} #  cyan
bldwht=${txtbld}${wht} #  white
bldgry=${txtbld}${gry} #  grey

# UNDERLINE colors
undred=${txtund}${red} #  red
undgrn=${txtund}${grn} #  greeb
undyel=${txtund}${yel} #  yellow
undblu=${txtund}${blu} #  blue
undpnk=${txtund}${pnk} #  pink
undcya=${txtund}${cya} #  cyan
undwht=${txtund}${wht} #  white
undgry=${txtund}${gry} #  grey

