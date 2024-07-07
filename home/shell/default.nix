{config, ...}: {
  imports = [
    ./common.nix
    ./tmux.nix
    ./starship.nix
    ./fzf.nix
    ./terminal.nix
    ./zsh.nix
  ];
}
