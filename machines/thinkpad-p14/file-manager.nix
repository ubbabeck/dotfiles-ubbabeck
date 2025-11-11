{ pkgs, ... }:

{

  environment.systemPackages = [
    pkgs.parted
  ];
  programs.partition-manager.enable = true;
}
