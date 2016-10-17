
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

export -f dc
export -f t
export -f cdmr
export -f cdmb
export -f docker_kill
export -f dc_info
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export -f chmod_num

# DueCourse workbench CLI
source /Users/erselaker/duecourse/workbench/.cli/env
