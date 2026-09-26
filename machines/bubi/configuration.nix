{
  pkgs,
  self,
  lib,
  ...
}:
{
  imports = [

    self.nixosModules.default
    self.inputs.srvos.nixosModules.server

    self.inputs.srvos.nixosModules.mixins-nginx
    self.inputs.nix-index-database.nixosModules.nix-index
    self.inputs.disko.nixosModules.disko
    ../../nixosModules/users.nix
    ./modules/disko.nix
    ./modules/initrd-ssh.nix
  ];
  nixpkgs.pkgs = self.inputs.nixpkgs.legacyPackages.x86_64-linux;

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;

  networking.hostName = "bubi";
  # ZFS requires a unique hostId per pool host to guard against concurrent import.
  networking.hostId = "9cf8d79c";

  networking.nameservers = [
    "195.179.224.53"
    "209.126.15.53"
  ];

  boot.initrd.systemd.enable = true;

  srvos.boot.consoles = lib.mkDefault [ ];
  environment.systemPackages = with pkgs; [
    tmux
    htop
    iotop
    tcpdump
    strace
    ethtool
    usbutils
    bandwhich
    vim
    python3
  ];

  # Fresh install on 26.11; never change after first deploy.
  system.stateVersion = "26.11";
}
