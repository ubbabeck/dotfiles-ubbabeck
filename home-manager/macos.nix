{ pkgs, ... }:
{

  imports = [
    ./modules/atuin-autosync.nix
    ./modules/ai.nix
  ];

  home.packages = [
    pkgs.eternal-terminal
  ];
}
