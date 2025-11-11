{ lib, ... }:
{
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "ruben" ];
    ensureUsers = [
      {
        name = "ruben";
        ensureDBOwnership = true;
      }
    ];
    settings = {
      log_connections = true;
      log_statement = "all";
      logging_collector = true;
      log_disconnections = true;
      log_destination = lib.mkForce "syslog";
      port = 5435;
    };
  };

}
