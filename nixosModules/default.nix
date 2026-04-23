{
  lib,
  ...
}:
{

  documentation.info.enable = false;
  security.sudo.execWheelOnly = lib.mkForce false;
  programs.nano.enable = false;

  imports = [
    ./nix-path.nix
    ./i18n.nix
    ./nix-daemon.nix
    ./nftables.nix
    ./zerotier.nix
  ];
}
