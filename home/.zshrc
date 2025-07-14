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

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/ruben/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
rust-doc(){
  xdg-open "$(nix-build '<nixpkgs>' -A rustc.doc --no-out-link)/share/doc/rust/html/index.html"
}


# Alias git
alias gl='git log --oneline --graph --all --decorate'
alias gc='git commit -v'
alias ga='git add -p'
alias gs='git status'
alias ls='ls --color=auto --classify --human-readable'
# Direnv
eval "$(direnv hook zsh)"
# Plugins
if [[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
  export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=60
fi
if [[ -f ~/.homesick/repos/homeshick/homeshick.sh ]]; then
  source ~/.homesick/repos/homeshick/homeshick.sh
fi
if [[ -f ~/.zsh/zsh-autopair/autopair.zsh ]]; then
  source ~/.zsh/zsh-autopair/autopair.zsh
fi
if [[ -f ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]]; then
  source ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
fi

[[ -d ~/.zsh-completions/src ]] && fpath+=(~/.zsh-completions/src)
[[ -d ~/.nix-profile/share/zsh/site-functions ]] && fpath+=(~/.nix-profile/share/zsh/site-functions)
[[ -d /run/current-system/sw/share/zsh/site-functions/ ]] && fpath+=(/run/current-system/sw/share/zsh/site-functions/)
