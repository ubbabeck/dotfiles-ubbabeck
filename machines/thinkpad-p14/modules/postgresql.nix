{ ... }:
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
      port = 5435;
    };
  };

}
