{ lib, ... }:
{

  # For docker
  boot.kernel.sysctl."net.ipv4.ip_forward" = lib.mkDefault 1;
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = lib.mkDefault 1;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    storageDriver ="overlay2";
    extraOptions = "--userland-proxy=false --ip-masq=true";

    # not compatible with docker swarm
    liveRestore = false;

  };
}
