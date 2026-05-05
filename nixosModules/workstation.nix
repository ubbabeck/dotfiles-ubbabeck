{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Common desktop/laptop workstation configuration

  imports = [
    ./i18n.nix
    #./kde
    ./networkd.nix
    ./packages.nix
    ./pipewire.nix
    ./powertop.nix
    ./tracing.nix
    ./users.nix
  ];

  # System configuration
  system.etc.overlay.enable = true;
  system.etc.overlay.mutable = true;
  services.userborn.enable = true;

  # Hardware support
  services.fwupd.enable = true;
  hardware.keyboard.qmk.enable = true;

  # Desktop services
  services.gvfs.enable = true;

  # Boot configuration
  boot.plymouth.enable = true;
  boot.initrd.systemd.enable = true;

  # Manual timezones (set by networkmanager dispatcher or manually)
  #time.timeZone = null;

  # Development tools
  programs.wireshark.enable = false;

  environment.systemPackages = [ pkgs.android-tools ];

  # Services
  services = {
    gpm.enable = true;
    upower.enable = true;

    printing = {
      enable = false;
      browsing = true;
      drivers = with pkgs; [
        gutenprint
        cnijfilter2
      ];
    };

    journald.extraConfig = "SystemMaxUse=1G";

    tor.client.enable = true;
  };

  # Mute audio before suspend
  systemd.services.audio-off = {
    description = "Mute audio before suspend";
    wantedBy = [ "sleep.target" ];
    serviceConfig = {
      Type = "oneshot";
      Environment = "XDG_RUNTIME_DIR=/run/user/1000";
      User = "joerg";
      RemainAfterExit = "yes";
      ExecStart = "${pkgs.pamixer}/bin/pamixer --mute";
    };
  };

  # Fonts
  fonts.fontDir.enable = true;

  # Programs
  programs = {
    ssh = {
      extraConfig = ''
        SendEnv LANG LC_*
      '';
    };
    zsh = {
      enable = true;
      promptInit = "";
    };
  };

  # Security
  security.audit.enable = false;
  security.sudo.wheelNeedsPassword = lib.mkForce (!config.services.fprintd.enable);

  # Cross-architecture support
  boot.binfmt.emulatedSystems = [
    "armv7l-linux"
    "riscv32-linux"
    "riscv64-linux"
    "powerpc64-linux"
    "powerpc64le-linux"
  ];

  # User management
  users.mutableUsers = false;
  users.users.ruben.hashedPasswordFile =
    config.clan.core.vars.generators.user-password-root.files.user-password-hash.path;

  # Network
  networking.networkmanager.enable = lib.mkDefault true;
}
