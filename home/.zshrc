if [[ -n ${commands[tmux]} ]] && [[ "$TERM" != "linux" ]] && [[ "$TERM_PROGRAM" != WezTerm ]] && [[ -z "$TMUX" ]] && [[ "$INSIDE_EMACS" != "vterm" ]]; then
  if [[ -n "$SSH_AUTH_SOCK" ]]; then
    tmux set-environment -g SSH_AUTH_SOCK "$SSH_AUTH_SOCK" 2>/dev/null
  fi
  tmux new-session -s "${TTY:t}" -t main || tmux attach-session -t "${TTY:t}"
fi
if [[ -f ~/.nix-profile/etc/profile.d/hm-session-vars.sh ]]; then
  source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
fi

if [[ -e /etc/profile.d/nix.sh ]]; then
  # shellcheck disable=SC1091
  . /etc/profile.d/nix.sh
fi
if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
  # shellcheck disable=SC1091
  . ~/.nix-profile/etc/profile.d/nix.sh
fi
if [ -f ~/.nix-profile/zsh/ghostty-integration ]; then
  # shellcheck disable=SC1091
  . ~/.nix-profile/zsh/ghostty-integration
fi


## Options
setopt auto_name_dirs
setopt transient_rprompt
setopt pushd_ignore_dups
setopt no_beep
setopt auto_cd
setopt correct
setopt multios
setopt cdablevarS
autoload -U url-quote-magic
zle -N self-insert url-quote-magic
bindkey "^[m" copy-prev-shell-word
# Lines configured by zsh-newuser-install
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
DIRTSTACKSIZE=30
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>' # Like default, but without / -- ^W must be useful in paths, like it is in vim, bash, tcsh
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt share_history
setopt append_history
setopt hist_verify
setopt inc_append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_space
setopt long_list_jobs
# emacs keys, use -v for vim keys
bindkey -e
autoload edit-command-line
zle -N edit-command-line
bindkey '^X^e' edit-command-line
bindkey "^[[3~" delete-char # bind delete key

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/ruben/.zshrc'

autoload -Uz compinit
autoload colors; colors
autoload -U promptinit; promptinit
compinit -C
if [[ -n ${commands[fzf]} ]]; then
  source ~/.zsh-fzf-tab/fzf-tab.zsh
  if [ -n $TMUX ]; then
    zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
  fi
  # disable sort when completing `git checkout`
  zstyle ':completion:*:git-checkout:*' sort false
  # set descriptions format to enable group support
  # NOTE: don't use escape sequences here, fzf-tab will ignore them
  zstyle ':completion:*:descriptions' format '[%d]'
  # set list-colors to enable filename colorizing
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
  # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
  zstyle ':completion:*' menu no
  # preview directory's content with lsd when completing cd
  if [[ -n ${commands[lsd]} ]]; then
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color=always $realpath'
  fi
  # switch group using `<` and `>`
  zstyle ':fzf-tab:*' switch-group '<' '>'
fi

setopt complete_in_word
unsetopt always_to_end

PURE_GIT_UNTRACT_DIRTY=0 PURE_GIT_PULL=0
fpath+=($HOME/.zsh-pure)
PURE_PROMT_SYMBOL="%(?.%F{green}.%F{red})%%%f"
zstyle :prompt:pure:path color yellow
zstyle :prompt:pure:git:branch color yellow
zstyle :prompt:pure:user color cyan
zstyle :prompt:pure:host color yellow
zstyle :prompt:pure:git:branch:cached color red
## non-zero exit code in right prompt
RPS1='%(?.%F{magenta}.%F{red}(%?%) %F{magenta})'
autoload -U promptinit; promptinit
prompt pure

# End of lines added by compinstall
rust-doc(){
  xdg-open "$(nix-build '<nixpkgs>' -A rustc.doc --no-out-link)/share/doc/docs/html/index.html"
}

flakify() {
  if [ ! -e flake.nix ]; then
    nix flake new -t github:Mic92/flake-templates#nix-develop .
  elif [ ! -e .envrc ]; then
    echo "use flake" > .envrc
  fi
  direnv allow
  ${EDITOR:-vim} flake.nix
}

# File management
if [[ -n ${commands[eza]} ]]; then
  alias ls="eza --icons --smart-group --time-style relative"
  alias tree="eza --tree --icons"
elif [[ $OSTYPE == freebsd* ]] ||  [[ $OSTYPE == darwin* ]]; then
  alias ls='ls -G'
else
  alias ls='ls --color=auto --classify --human-readable'
fi

# Alias git
alias gl='git log --oneline --graph --all --decorate'
alias gc='git commit -v'
alias ga='git add -p'
alias gs='git status'
alias ls='ls --color=auto --classify --human-readable'
# Direnv
eval "$(direnv hook zsh)"
# Plugins
if [[ -f ~/.zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source ~/.zsh-autosuggestions/zsh-autosuggestions.zsh
  export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=60
fi
if [[ -f ~/.homesick/repos/homeshick/homeshick.sh ]]; then
  source ~/.homesick/repos/homeshick/homeshick.sh
fi
if [[ -f ~/.zsh-autopair/autopair.zsh ]]; then
  source ~/.zsh-autopair/autopair.zsh
fi
if [[ -f ~/.fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]]; then
  source ~/.fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
fi

[[ -d ~/.zsh-completions/src ]] && fpath+=(~/.zsh-completions/src)
[[ -d ~/.nix-profile/share/zsh/site-functions ]] && fpath+=(~/.nix-profile/share/zsh/site-functions)
[[ -d /run/current-system/sw/share/zsh/site-functions/ ]] && fpath+=(/run/current-system/sw/share/zsh/site-functions/)
