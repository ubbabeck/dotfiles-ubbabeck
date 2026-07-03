# Declares what to back up (clan.core.state). The backup destination, keys and
# schedule are configured by the clan `borgbackup` service instance in
# machines/flake-module.nix. Exclude patterns live in ./borgbackup-excludes.nix
# because clan reads them at the inventory level, not from this NixOS module.
{
  lib,
  config,
  ...
}:
{
  clan.core.state = {
    networkmanager = lib.mkIf config.networking.networkmanager.enable {
      folders = [ "/etc/NetworkManager" ];
    };
    system.folders = [
      "/home"
      "/var"
      "/root"
    ];
  };
}
