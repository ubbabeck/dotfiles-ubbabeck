{
  pkgs,
  self,
  ...
}:
{
  nix = {
    package = self.inputs.nix.packages.${pkgs.stdenv.hostPlatform.system}.nix;
    gc.automatic = true;
    gc.dates = "03:15";
    gc.options = "--delete-older-than 10d";
    nixPath = [ "nixpkgs=flake:nixpkgs" ];

    settings = {
      keep-outputs = true;
      keep-derivations = true;
      trusted-users = [
        "@wheel"
        "root"
      ];
      substituters = [
        "https://hetzner-cache.numtide.com"
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      fallback = true;
      warn-dirty = false;
      auto-optimise-store = true;
    };
  };
  systemd.timers.nix-cleanup-gcroots = {
    timerConfig = {
      OnCalendar = [ "weekly" ];
      Persistent = true;
    };
    wantedBy = [ "timers.target" ];
  };
  systemd.services.nix-cleanup-gcroots = {
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [
        # delete automatic gcroots older than 30 days
        "${pkgs.findutils}/bin/find /nix/var/nix/gcroots/auto /nix/var/nix/gcroots/per-user -type l -mtime +30 -delete"
        # created by nix-collect-garbage, might be stale
        "${pkgs.findutils}/bin/find /nix/var/nix/temproots -type f -mtime +10 -delete"
        # delete broken symlinks
        "${pkgs.findutils}/bin/find /nix/var/nix/gcroots -xtype l -delete"
      ];
    };
  };
  programs.command-not-found.enable = false;
}
