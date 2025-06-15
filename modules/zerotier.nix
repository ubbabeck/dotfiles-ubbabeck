{ config, lib, ... }:
{
  options = {
    services.zerotierone = {
      blockRfc1918Addresses = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          If true, blocks RFC1918 addresses using the firewall to stop hyprspace from connecting to it.
          Some providers such as Hetzner will sent out abuse reports if you connect to these addresses.
        '';
      };
    };
  };
  config = {
    systemd.services.zerotierone.serviceConfig.IPAddressDeny =
      lib.mkIf config.services.zerotierone.blockRfc1918Addresses
        [
          "10.0.0.0/8"
          "172.16.0.0/12"
          "192.168.0.0/16"
        ];
    services.zerotierone = {
      enable = true;
      joinNetworks = [
        "e5cd7a9e1ccee855"
        "60ee7c034a32e1b9"
        "48d6023c464c5f15"
      ];
    };

    services.zerotierone.localConf.settings = {
      interfacePrefixBlacklist = [
        "tinc"
        "wiregrill"
        "hyprspace"
        "tailscale"
      ];
    };
  };
}
