{ pkgs, ... }:
{
  home.packages = with pkgs; [
    alejandra
    deadnix
    statix
  ];
  programs.direnv = {
    enable = true;
  };
  programs.eza.enable = true;
}
