{
  config,
  lib,
  ...
}:
let
  readList =
    path:
    lib.filter (l: l != "" && !lib.hasPrefix "#" l) (lib.splitString "\n" (lib.fileContents path));
  networks = readList config.clan.core.vars.generators.zerotier-networks.files."networks".path;
in
{
  options = {
    services.zerotierone = {
      blockRfc1918Addresses = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          If true, blocks RFC1918 addresses using the firewall to stop zerotier from connecting to it.
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
    services.zerotierone.enable = true;
    services.zerotierone.joinNetworks = [
      "b6079f73c62fdd0f"
      "3efa5cb78a26e018"
      "e5cd7a9e1ccee855"
      "60ee7c034a32e1b9"
      "b6079f73c62fdd0f"
    ];

    services.zerotierone.localConf.settings = {
      interfacePrefixBlacklist = [
        "tinc"
        "wiregrill"
        "tailscale"
      ];
    };
  };
}
