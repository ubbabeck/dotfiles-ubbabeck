{ pkgs, ... }:
{
  home.packages = with pkgs; [
    alejandra
    deadnix
    statix
    zsh
    bashInteractive
    tmux
    lazygit
  ];
  programs.direnv = {
    enable = true;
  };
  programs.eza.enable = true;
}
