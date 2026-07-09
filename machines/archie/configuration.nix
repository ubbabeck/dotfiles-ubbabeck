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
  ];
  nixpkgs.pkgs = self.inputs.nixpkgs.legacyPackages.x86_64-linux;

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;

  networking.hostName = "archie";
  # ZFS requires a unique hostId per pool host to guard against concurrent import.
  networking.hostId = "a5c81e2f";

  # Contabo assigns a static public IP with no DHCP server, so mirror the
  # provider's netplan here. Match on MAC so it survives interface renames.
  systemd.network.enable = true;
  systemd.network.networks."10-wan" = {
    matchConfig.MACAddress = "00:50:56:65:7d:60";
    address = [
      "178.238.236.110/24"
      "2a02:c207:2342:7388::1/64"
    ];
    routes = [
      { Gateway = "178.238.236.1"; }
      {
        Gateway = "fe80::1";
        GatewayOnLink = true;
      }
    ];
    linkConfig.RequiredForOnline = "routable";
  };

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
