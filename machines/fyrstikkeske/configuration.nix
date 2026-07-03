{ pkgs, self, ... }:
{
  imports = [
    self.nixosModules.default
    self.inputs.srvos.nixosModules.server

    ../../nixosModules/users.nix
    ./hardware-configuration.nix
    ./modules/et.nix
    ../../nixosModules/borgbackup.nix

    self.inputs.disko.nixosModules.disko
    ./disko.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Required by ZFS. Must be unique per host with the same pool name.
  networking.hostId = "03819847";
  boot.supportedFilesystems = [ "zfs" ];

  nixpkgs.pkgs = self.inputs.nixpkgs.legacyPackages.x86_64-linux;
  clan.core.deployment.requireExplicitUpdate = true;

  time.timeZone = "UTC";

  services.getty.autologinUser = "root";

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

  systemd.network.networks.ethernet = {
    matchConfig.Type = "ether";
    networkConfig = {
      DHCP = true;
      LLMNR = true;
      LinkLocalAddressing = true;
      LLDP = true;
      IPv6AcceptRA = true;
    };
    dhcpConfig = {
      UseHostname = false;
      RouteMetric = 512;
    };
    #  extraConfig = ''
    #    [Network]
    #    IPv6Token = "::fd87:20d6:a932:6605";
    #  '';
  };

  services.resolved.enable = true;
}
