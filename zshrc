# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export TERM="xterm-256color"
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
DEFAULT_USER="`whoami`"
plugins=(git common-aliases history urltools web-search safe-paste zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

bindkey -e
bindkey '^[[1;9C' forward-word
bindkey '^[[1;9D' backward-word
bindkey '\e' clear-screen

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR="nvim"

setopt INTERACTIVE_COMMENTS

[ -f ~/dotfiles/aliases.zsh ] && source ~/dotfiles/aliases.zsh
[ -f ~/dotfiles/functions.zsh ] && source ~/dotfiles/functions.zsh

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)
ZLE_RPROMPT_INDENT=0

export PATH="/usr/local/opt/openjdk@18/bin:$PATH"
export PATH="/usr/local/opt/python@3.10/bin:$PATH"
export PATH="/Users/daveystruijk/Library/pnpm:$PATH"
export PATH="/Users/daveystruijk/go/bin:$PATH"
export PATH="/Users/daveystruijk/Library/Android/sdk/platform-tools:$PATH"

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# pnpm
export PNPM_HOME="/Users/daveystruijk/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH="/usr/local/opt/openjdk/bin:$PATH"
export CPPFLAGS="-I/usr/local/opt/openjdk/include"

