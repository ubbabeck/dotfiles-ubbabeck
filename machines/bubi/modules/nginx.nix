{
  pkgs,
  self,
  ...
}:
let
  inherit (self.lib) ztIp;
  listenAddr = "[${ztIp "bubi"}]";
in
{
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "ruben@ubbabeck.com";

  # nginx binds the ZeroTier address, which only exists once zerotierone
  # has joined the network; allow binding before that to avoid a start race.
  boot.kernel.sysctl."net.ipv6.ip_nonlocal_bind" = 1;

  # Public traffic arrives via archie: TLS is passed through untouched on 443
  # (with PROXY protocol), plain HTTP on 80 is reverse proxied.
  services.nginx.virtualHosts."ubbabeck.com" = {
    serverAliases = [ "www.ubbabeck.com" ];
    enableACME = true;
    forceSSL = true;
    # Only listen on ZeroTier so the site is not exposed on the LAN.
    listen = [
      {
        addr = listenAddr;
        port = 443;
        ssl = true;
        proxyProtocol = true;
      }
      {
        addr = listenAddr;
        port = 80;
      }
    ];
    extraConfig = ''
      set_real_ip_from ${ztIp "archie"};
      real_ip_header proxy_protocol;
    '';
    root = pkgs.writeTextDir "index.html" ''
      <!doctype html>
      <title>ubbabeck.com</title>
      <h1>ubbabeck.com served from bubi</h1>
    '';
  };
}
