{ pkgs, ... }:
{
  home.packages = with pkgs; [
    alejandra
    deadnix
    statix
    zsh
    bashInteractive
    tmux
    screen
    lazygit
  ];
  programs.direnv = {
    enable = true;
    # Use nix-direnv
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };
  programs.eza.enable = true;
}
