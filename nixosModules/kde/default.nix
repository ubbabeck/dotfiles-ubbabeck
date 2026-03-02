{ pkgs, config, ... }:
{
  # Lock KWallet/ksecretd and before suspend
  systemd.user.services.lock-secrets-on-suspend = {
    description = "Lock secrets before suspend";
    before = [ "sleep.target" ];
    wantedBy = [ "sleep.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "lock-secrets" ''
        # Lock KWallet/ksecretd
        ${pkgs.libsecret}/bin/secret-tool lock --collection=kdewallet 2>/dev/null || true

        # lock keepassxc
        ${pkgs.keepassxc}/bin/keepassxc --lock  2>/dev/null || true

      '';
    };
  };

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # https://wiki.nixos.org/wiki/KDE#KMail_Renders_Blank_Messages
  environment.sessionVariables = {
    NIX_PROFILES = "${pkgs.lib.concatStringsSep " " (
      pkgs.lib.reverseList config.environment.profiles
    )}";
  };

  environment.systemPackages = with pkgs; [
    ferdium
    librewolf
    firefox
    chromium
    pavucontrol
    bottles
    libnotify
    kwalletcli

    wl-clipboard # wl-copy / wl-paste
    (pkgs.callPackage ./choosers.nix { })
  ];
  programs.kdeconnect.enable = true;
}
