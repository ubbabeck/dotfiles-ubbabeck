{ pkgs, ... }:
{
  imports = [

    ../../nixosModules/packages.nix
  ];
  environment.systemPackages = with pkgs; [ cntr ];
}
