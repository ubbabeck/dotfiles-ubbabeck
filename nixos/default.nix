{ ... }:
{
  imports = [
    ./configuration.nix
    ./nix.nix
    ./programs
    ./zerotier.nix
    ./yubikey.nix
    ./sway.nix
  ];
}
