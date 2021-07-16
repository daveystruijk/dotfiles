# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export TERM="xterm-256color"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel9k/powerlevel9k"

# Set the default user to hide
DEFAULT_USER="`whoami`"

bindkey -e
bindkey '^[[1;9C' forward-word
bindkey '^[[1;9D' backward-word

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git common-aliases history urltools web-search safe-paste zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR="vim"

# Make the shell support comments, allowing you to comment out a line
setopt INTERACTIVE_COMMENTS

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases

alias zshrc="vim ~/.zshrc && source ~/.zshrc"
alias vimrc="vim ~/dotfiles/vimrc"

alias nmap_hosts="sudo nmap -sP"
alias nmap_full="sudo nmap -sV -oN nmap.txt"

alias branches="git for-each-ref --sort=-committerdate refs/heads --format='%(HEAD)%(color:yellow)%(refname:short)|%(color:bold green)%(committerdate:relative)|%(color:blue)%(subject)|%(color:magenta)%(authorname)%(color:reset)'|column -ts'|'|head -n10"

alias lock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

alias playdir="vlc -Z --audio-visual=visual --effect-list=spectrometer *"

alias prettyjson='python -m json.tool'

export PATH="/Users/daveystruijk/.local/bin:/usr/local/bin:/usr/local/opt/python/libexec/bin:$PATH:$HOME/esp/xtensa-esp32-elf/bin"
export IDF_PATH="$HOME/esp/esp-idf"

function s() {
  find . -iname "*$1*"
}

unalias -m "t"
function t() {
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    python ~/t/t.py --task-dir ~/todos --list "$(basename $(git rev-parse --show-toplevel)).txt" $@
  else
    python ~/t/t.py --task-dir ~/todos --list "main.txt" $@
  fi
}

function _prompt_todos() {
  echo $(t | wc -l | sed -e"s/ *//")
}

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)

function pip_save() {
	package_name=$1
	requirements_file=$2
	if [[ -z $requirements_file ]]
	then
		requirements_file='./requirements.txt'
	fi
	pip install $package_name && pip freeze | grep -i $package_name >> $requirements_file
}

function tab_title() {
	local REPO=$(basename `git rev-parse --show-toplevel 2> /dev/null` 2> /dev/null) || return
	if [[ -z $REPO ]]
	then
		echo "%20<…<${PWD/#$HOME/~}%>>" # 20 char left truncated PWD
	else
		echo "%20>…>$REPO%>>🔹" # 20 char right truncated
	fi
}

function gitday() {
  git --no-pager log --after="$1 00:00" --before="$1 23:59" --author=davey --stat --reverse
}

function gitmonth() {
  for day in {0..31}
  do
    timestamp="2021-$1-$day"
    echo "============="
    echo "$timestamp"
    echo "============="
    gitday $timestamp
  done
}

# List gitlab issues
function issues() {
  glab issue list --assignee=@me
}

function web() {
  glab issue view --web $1
}

# Create a new gitlab issue w/ branch and merge request
function issue() {
  if [ -z "$1" ]; then
    echo "Please specify a title"
    return
  fi

  echo "=> Stashing changes"
  git stash

  re='^[0-9]+$'
  if ! [[ $1 =~ $re ]] ; then
    echo "=> Switching to develop"
    git checkout develop
    git pull origin develop --recurse-submodules
    git status

    echo "=> Creating issue"
    issue=$(glab issue create --no-editor --title "$1" --description "" --assignee=@me | tail -n 2 | head -n 1 | tr -dc '0-9')
    echo "Issue ID: $issue"

    echo "=> Creating merge request"
    branch=$(glab mr for "$issue" --wip | tail -n 3 | head -n 1 | sed 's/^[^\(]*//;s/[^\)]*$//' | awk '{print $NF}' | awk '{print substr($0, 2, length($0) - 2)}')
    echo "Branch: $branch"
  else
    issue=$1
    # Check if issue has a branch, else open web page
    git fetch --all
    branch=$(git branch --list -r "origin/$issue-*" | head -n 1 | awk '{sub(/;.*/,""); print $NF}' | sed 's/origin\///')
    if [ -z "$branch" ]; then
      echo "=> Issue $issue has no MR, opening web page"
      glab issue view --web $issue
    fi
  fi

  echo "=> Switching to branch: $branch"
  git fetch --all
  local_branch=$(git branch --list "$branch")
  if [ -z "$local_branch" ]; then
    git checkout -b "$branch"
  else
    git checkout "$branch"
  fi
}

function ci() {
  glab pipeline ci trace
  # branch=$(git symbolic-ref --short HEAD)
}

function commit() {
  if [ -z "$1" ]; then
    git commit
  fi
  git commit -m "$1"
  ggpush
  ci
}

function close() {

}

ZSH_THEME_TERM_TAB_TITLE_IDLE='$(tab_title)'
export PATH="/usr/local/opt/ncurses/bin:/Users/daveystruijk/code/platform-tools:/Users/daveystruijk/bin:/Users/daveystruijk/bin/qemu/bin:/Users/daveystruijk/momo/cu_refactor/bin:$PATH"

DIRSTACKSIZE=8
setopt autopushd pushdminus pushdsilent pushdtohome
alias dh='dirs -v'

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"


export PATH="/Users/daveystruijk/gcc-arm-none-eabi-9-2019-q4-major/bin:/usr/local/sbin:/Library/Developer/CommandLineTools/usr/lib:/Users/daveystruijk/.gem/ruby/2.7.0/bin:$PATH"
export PATH="/usr/local/opt/openjdk@16/bin:$PATH"

ANDROID_SDK_HOME="/Volumes/Davey Struijk/Android"

alias vi="nvim"
alias vim="nvim"
alias work="cd ~/code/work/ && cargo run"
alias du="diskonaut"
alias ping="gping"
alias wiki="vim ~/vimwiki/index.wiki"
alias ls="lsd"
alias cat="bat"

