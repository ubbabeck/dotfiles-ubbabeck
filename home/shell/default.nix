{config, ...}: {
  imports = [
    ./common.nix
    ./tmux.nix
    ./fzf.nix
    ./terminal.nix
    ./zsh.nix
  ];
}
