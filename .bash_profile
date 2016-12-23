alias vim='/usr/local/Cellar/vim/7.4.979/bin/vim'

[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

function weather_fn(){
curl -4 http://wttr.in/$1
}

alias weather=weather_fn;

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
# same as 'alias ls=ls -G' which I also have set
# Put this in your .zshrc or .bashrc file
# Install `tree` first — brew install tree

if [ -f $(brew --prefix)/etc/bash_completion ]; then
	. $(brew --prefix)/etc/bash_completion
fi

function dc_info {
cat ~/duecourse/workbench/.cli/info
}

function t() {
# Defaults to 3 levels deep, do more with `t 5` or `t 1`
# pass additional args after
tree -I '.git|node_modules|bower_components|.DS_Store' --dirsfirst --filelimit 50 -L ${1:-3} -aC $2
}

function dc(){
if [ -z "$1" ]
then
	cd ~/duecourse/workbench/
else
	cd ~/duecourse/workbench/$1
fi
}

function docker_kill(){
docker stop $(docker ps -a -q); docker rm $(docker ps -a -q); docker volume rm $(docker volume ls -qf dangling=true)
}

function docker_clean(){
docker rmi $(docker images | grep "^<none>" | awk "{print $3}")
}

function dcup(){
dc && docker-compose up $1
}

function ports_in_use(){
lsof -nP | grep LISTEN
}

function cdmr(){
cd $1 && make rebuild
}

function cdmb(){
cd $1 && make build
}

function chmod_num(){
stat -f "%OLp" $1
}

source /usr/local/etc/bash_completion.d/docker-compose
alias dcu='docker-compose up'
complete -o default -o nospace -F _docker_compose_up dcu

# Automatically add completion for all aliases to commands having completion functions
function alias_completion {
local namespace="alias_completion"

# parse function based completion definitions, where capture group 2 => function and 3 => trigger
local compl_regex='complete( +[^ ]+)* -F ([^ ]+) ("[^"]+"|[^ ]+)'
# parse alias definitions, where capture group 1 => trigger, 2 => command, 3 => command arguments
local alias_regex="alias ([^=]+)='(\"[^\"]+\"|[^ ]+)(( +[^ ]+)*)'"

# create array of function completion triggers, keeping multi-word triggers together
eval "local completions=($(complete -p | sed -Ene "/$compl_regex/s//'\3'/p"))"
(( ${#completions[@]} == 0 )) && return 0

# create temporary file for wrapper functions and completions
rm -f "/tmp/${namespace}-*.tmp" # preliminary cleanup
local tmp_file; tmp_file="$(mktemp "/tmp/${namespace}-${RANDOM}XXX.tmp")" || return 1

local completion_loader; completion_loader="$(complete -p -D 2>/dev/null | sed -Ene 's/.* -F ([^ ]*).*/\1/p')"

# read in "<alias> '<aliased command>' '<command args>'" lines from defined aliases
local line; while read line; do
eval "local alias_tokens; alias_tokens=($line)" 2>/dev/null || continue # some alias arg patterns cause an eval parse error
local alias_name="${alias_tokens[0]}" alias_cmd="${alias_tokens[1]}" alias_args="${alias_tokens[2]# }"

# skip aliases to pipes, boolean control structures and other command lists
# (leveraging that eval errs out if $alias_args contains unquoted shell metacharacters)
eval "local alias_arg_words; alias_arg_words=($alias_args)" 2>/dev/null || continue
# avoid expanding wildcards
read -a alias_arg_words <<< "$alias_args"

# skip alias if there is no completion function triggered by the aliased command
if [[ ! " ${completions[*]} " =~ " $alias_cmd " ]]; then
	if [[ -n "$completion_loader" ]]; then
		# force loading of completions for the aliased command
		eval "$completion_loader $alias_cmd"
		# 124 means completion loader was successful
		[[ $? -eq 124 ]] || continue
		completions+=($alias_cmd)
	else
		continue
	fi
fi
local new_completion="$(complete -p "$alias_cmd")"

# create a wrapper inserting the alias arguments if any
if [[ -n $alias_args ]]; then
	local compl_func="${new_completion/#* -F /}"; compl_func="${compl_func%% *}"
	# avoid recursive call loops by ignoring our own functions
	if [[ "${compl_func#_$namespace::}" == $compl_func ]]; then
		local compl_wrapper="_${namespace}::${alias_name}"
		echo "function $compl_wrapper {
		(( COMP_CWORD += ${#alias_arg_words[@]} ))
		COMP_WORDS=($alias_cmd $alias_args \${COMP_WORDS[@]:1})
		(( COMP_POINT -= \${#COMP_LINE} ))
		COMP_LINE=\${COMP_LINE/$alias_name/$alias_cmd $alias_args}
		(( COMP_POINT += \${#COMP_LINE} ))
		$compl_func
	}" >> "$tmp_file"
	new_completion="${new_completion/ -F $compl_func / -F $compl_wrapper }"
fi
	fi
	# replace completion trigger by alias
	new_completion="${new_completion% *} $alias_name"
	echo "$new_completion" >> "$tmp_file"
done < <(alias -p | sed -Ene "s/$alias_regex/\1 '\2' '\3'/p")
source "$tmp_file" && rm -f "$tmp_file"
}; alias_completion

# $1 = type; 0 - both, 1 - tab, 2 - title
# rest = text
setTerminalText () {
	# echo works in bash & zsh
	local mode=$1 ; shift
	echo -ne "\033]$mode;$@\007"
}

stt_both  () { setTerminalText 0 $@; }
stt_tab   () { setTerminalText 1 $@; }
stt_title () { setTerminalText 2 $@; }

alias v='stt_tab $(basename `pwd`) && vim'

export -f dc
export -f dcup
export -f docker_clean
export -f t
export -f cdmr
export -f cdmb
export -f docker_kill
export -f dc_info
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export -f chmod_num
export -f stt_both
export -f stt_tab
export -f stt_title

# DueCourse workbench CLI
source /Users/erselaker/duecourse/workbench/.cli/env
