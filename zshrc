export TERM="xterm-256color"
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
DEFAULT_USER="`whoami`"
plugins=(git common-aliases history urltools web-search safe-paste zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

bindkey -e
bindkey '^[[1;9C' forward-word
bindkey '^[[1;9D' backward-word

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR="vim"

setopt INTERACTIVE_COMMENTS

[ -f ~/dotfiles/aliases.zsh ] && source ~/dotfiles/aliases.zsh
[ -f ~/dotfiles/functions.zsh ] && source ~/dotfiles/functions.zsh

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)

export PATH="/usr/local/opt/openjdk@18/bin:$PATH"
export PATH="/usr/local/opt/python@3.10/bin:$PATH"
export PATH="/Users/daveystruijk/Library/pnpm:$PATH"
export PATH="/Users/daveystruijk/Library/Android/sdk/platform-tools:$PATH"

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

