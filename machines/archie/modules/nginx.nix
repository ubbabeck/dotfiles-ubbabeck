{ lib, self, ... }:
let
  ztIp =
    machine:
    lib.trim (
      self.inputs.clan-core.lib.getPublicValue {
        flake = self;
        generator = "zerotier-ip-${machine}-zerotier-ubbabeck";
        file = "ip";
      }
    );
  bubi = "[${ztIp "bubi"}]";
in
{
  # TLS passthrough: bubi holds the certificate so archie never sees
  # plaintext. PROXY protocol carries the client address across the hop.
  services.nginx.streamConfig = ''
    server {
      listen 0.0.0.0:443;
      listen [::]:443;
      proxy_pass ${bubi}:443;
      proxy_protocol on;
    }
  '';

  # Plain HTTP is forwarded so bubi can answer ACME http-01 challenges and
  # issue its own https redirect.
  services.nginx.virtualHosts."ubbabeck.com" = {
    serverAliases = [ "www.ubbabeck.com" ];
    locations."/".proxyPass = "http://${bubi}:80";
  };
}
