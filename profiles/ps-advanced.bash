#!/bin/bash
# Create /etc/profile.d/prompt.sh and add the content of this gist to it.
# 
# Prompt example:
#   (2)[Fri May 06 10:00:30|  0:003]{4}root@ip-172-31-1-226:~(0)#
# Format is:
#   (sessions on server)[date time| Last command exec time]{sessions on server}username@hostname:working_directory(exit code of last cmd)#
#
# Example Output (of $[prompt[0]}): http://d.pr/i/19B87
#
# Credit: Original version was taken from http://stackoverflow.com/a/8464508/5154806
#

[[ -n $PROMPT_COMMAND ]] && unset PROMPT_COMMAND

plain='\[\e[0m\]'
bold='\[\e[1m\]'				
error='\[\e[0;91m\]'		# Same as red, but can be changed - only used for error codes
success='\[\e[0;92m\]'	# Same as green, but can be changed - only used for success code (green check)
grey='\[\033[1;30m\]'		# Used for neutral colors (parenthesis, brackets, etc)
blue='\[\e[0;94m\]'			# Used for PWD
red='\[\e[31;1m\]'			# Used for main prompt color when user is root
green='\[\e[0;92m\]'		# Used for main prompt when user is not root

source /Users/jhyland/.git-prompt.sh

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

timer_prompt() {
	status=$?
	local size=16
	sess_count=$(who | wc -l)
	calc_elapsed
	
	[[ "${#PWD}" -gt $size ]] && pwd_string="${PWD: -$size}" || pwd_string="$(printf "%${size}s" $PWD)"
	
	if [[ $(id -u) -eq 0 ]]; then
		color=$red
		suffix='#'
	else
		color=$green
		suffix='$' 
	fi
	
	# (sessions)[timestamp][elapsed]{cmdnum}username@hostname:~(exitstatus)$
	prompt[0]="($grey$sess_count$plain)$plain[$grey\d \T$plain|$plain$bold$elapsed]$plain{$grey\#$plain}$color\u@\h$plain:$blue\w$grey(\`if [ \$? = 0 ]; then echo \"$success\342\234\223$plain\"; else echo \"$error$status$plain\"; fi\`$grey)$plain$(__git_ps1)$suffix "
	
	# (cmdnum)[timestamp][elapsed]{sessions}username@hostname:~(exitstatus)$
	prompt[1]="($grey\#$plain)$plain[$grey\d \T$plain]$plain[$bold$elapsed]{$grey$sess_count$plain}$color\u@\h$plain:$blue\w$grey(\`if [ \$? = 0 ]; then echo \"$success\342\234\223$plain\"; else echo \"$error$status$plain\"; fi\`$grey)$plain$suffix "
	
	# cmdnum|[elapsed][timestamp]{sessions}username@hostname:~(exitstatus)$
	prompt[2]="$grey\#$plain|$plain[$bold$elapsed]$plain[$grey\d \T$plain]{$grey$sess_count$plain}$color\u@\h$plain:$blue\w$grey(\`if [ \$? = 0 ]; then echo \"$success\342\234\223$plain\"; else echo \"$error$status$plain\"; fi\`$grey)$plain$suffix "
	
	# sessions|[elapsed][timestamp]{cmdnum}username@hostname:~(exitstatus)$
	prompt[3]="$grey$sess_count$plain|$plain[$bold$elapsed]$plain[$grey\d \T$plain]{$grey\#$plain}$color\u@\h$plain:$blue\w$grey(\`if [ \$? = 0 ]; then echo \"$success\342\234\223$plain\"; else echo \"$error$status$plain\"; fi\`$grey)$plain$suffix "
	
	# [sessions|elapsed|timestamp]{cmdnum}username@hostname:~(exitstatus)$
	prompt[4]="[$grey$sess_count$plain$plain|$bold$elapsed$plain|$grey\d \T$plain]{$grey\#$plain}$color\u@\h$plain:$blue\w$grey(\`if [ \$? = 0 ]; then echo \"$success\342\234\223$plain\"; else echo \"$error$status$plain\"; fi\`$grey)$plain$suffix "
	
	PS1=${prompt[0]}
	
	begin=
}

set_begin
trap set_begin DEBUG
PROMPT_COMMAND=timer_prompt
