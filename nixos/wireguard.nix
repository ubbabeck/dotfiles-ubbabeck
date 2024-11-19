{
  config,
  pkgs,
  lib,
  ...
}:
{
  systemd.network = {
    enable = true;
    netdevs = {
      "10-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
          MTUBytes = "1300";
        };
        # See also man systemd.netdev (also contains info on the permissions of the key files)
        wireguardConfig = {
          # Don't use a file from the Nix store as these are world readable. Must be readable by the systemd.network user
          PrivateKeyFile = "/home/ruben/wireguard-keys/private";
          ListenPort = 9918;
        };
        wireguardPeers = [
          {
            PublicKey = "qX1vJoG/vogIdMQAT9bKUNs3sjTpARhdZ8OKrHg10CY=";
            AllowedIPs = [
              "fc00::1/64"
              "10.100.0.1"
            ];
            Endpoint = "78.47.91.240:51820";
          }
        ];
      };
    };
    networks.wg0 = {
      # See also man systemd.network
      matchConfig.Name = "wg0";
      # IP addresses the client interface will have
      address = [
        "fe80::3/64"
        "fc00::3/120"
        "10.100.0.2/24"
      ];
      DHCP = "no";
      dns = [ "fc00::53" ];
      ntp = [ "fc00::123" ];
      gateway = [
        "fc00::1"
        "10.100.0.1"
      ];
      networkConfig = {
        IPv6AcceptRA = false;
      };
    };
  };
}
