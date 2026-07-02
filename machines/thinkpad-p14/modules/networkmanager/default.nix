# Share the WiFi uplink with machines plugged into the wired ethernet port.
# Gives connected hosts a DHCP lease + internet (NAT), so they can reach the
# internet and you can SSH to them on 192.168.42.0/24.
{ ... }:
let
  # Wired port that clients plug into (the shared/downstream side).
  lanIface = "enp1s0f0";
  # Uplink with internet (WiFi). Used as the NAT external interface.
  wanIface = "wlp2s0";
in
{
  # Let systemd-networkd own the wired port and run a DHCP server on it.
  # NetworkManager must not touch it or it fights over the address.
  networking.networkmanager.unmanaged = [ lanIface ];

  systemd.network.networks."30-ethernet-share" = {
    matchConfig.Name = lanIface;
    address = [ "192.168.42.1/24" ];
    networkConfig.DHCPServer = true;
    dhcpServerConfig = {
      PoolOffset = 100;
      PoolSize = 100;
      EmitDNS = true;
      # Hand clients a public resolver directly; simpler than proxying DNS
      # through this host and avoids a resolved stub-listener collision.
      DNS = [
        "194.242.2.4"
        "1.1.1.1"
      ];
    };
  };

  # NAT: masquerade traffic from the wired subnet out over the WiFi uplink.
  # This is what actually gives connected machines internet access.
  networking.nat = {
    enable = true;
    externalInterface = wanIface;
    internalInterfaces = [ lanIface ];
    internalIPs = [ "192.168.42.0/24" ];
  };

  # Open DHCP server and SSH to the wired subnet only.
  networking.firewall.interfaces.${lanIface} = {
    allowedUDPPorts = [ 67 ]; # DHCP
    allowedTCPPorts = [ 22 ]; # SSH from clients into this host
  };
}
