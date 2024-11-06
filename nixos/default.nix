{ ... }:
{
  imports = [
    ./configuration.nix
    ./nix.nix
    ./programs
    ./zerotier.nix
    ./yubikey.nix
    ./sway.nix
    ./tor.nix
    ./android.nix
    #./wireguard.nix
  ];
}
