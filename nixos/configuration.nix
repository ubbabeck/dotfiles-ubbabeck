#nixPath = [ "nixpkgs=${self.inputs.nixpkgs}" ]; Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  config,
  pkgs,
  lib,
  allowed-unfree-packages,
  ...
}:
let
  nixos-hardware = inputs.nixos-hardware.nixosModules;
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/postgresql.nix
    ../nixosModules/users.nix
    ../nixosModules/i18n.nix
    ../nixosModules/kde
    ../nixosModules/powertop.nix
    {
      users = {
        groups.plugdev = { };
        users = {
          bitcoin = {
            name = "bitcoin";
            description = "user for bitcoin stuff";
            home = "/home/bitcoin";
            isNormalUser = true;
            useDefaultShell = true;
            createHome = true;
            extraGroups = [
              "networkmanager"
              "plugdev"
            ];
          };
        };
      };
      security.doas.extraConfig = ''
        permit nopass ruben as bitcoin
      '';
    }
    nixos-hardware.lenovo-thinkpad-p14s-amd-gen4
    nixos-hardware.common-pc-ssd

  ];

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };
  ruben.demo = {
    enable = false;

    greetings = [
      {
        name = "ruben";
        message = "Elsker joski";
      }
      {
        name = "joski";
        message = "Elsker ruki";
      }
    ];

  };

  security.doas.enable = true;
  security.sudo.enable = false;
  security.doas.extraRules = [
    {
      users = [ "ruben" ];

      keepEnv = true;
      persist = true;
    }
  ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "ruben"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
      keep-outputs = true;
      keep-derivations = true;
    };

    package = pkgs.nix;
  };

  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) allowed-unfree-packages;
  };
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.cleanOnBoot = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  boot.initrd.luks.devices."luks-1c3d6c0f-5c93-4c26-9b50-5a8db85684c6".device =
    "/dev/disk/by-uuid/1c3d6c0f-5c93-4c26-9b50-5a8db85684c6";
  boot.kernel.sysctl = {
    "net.ipv4.tcp_syncookies" = false;
    "vm.swappiness" = 60;
    "kernel.sysrq" = 1;
    "kernel.unprivileged_userns_clone" = 1;
  };
  boot.kernelParams = [
    "amdgpu.runpm=0"
    "amdgpu.dcdebugmask=0x10"
  ];
  boot.initrd.availableKernelModules = [
    "nvme"
    "ehci_pci"
    "xhci_pci"
    "usb_storage"
    "sd_mod"
    "rtsx_pci_sdmmc"
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-amd" ];

  networking.hostName = "thinkpad-p14"; # Define your hostname.
  networking.nameservers = [
    "194.242.2.4"
    "1.1.1.1"
  ];
  #boot.initrd.systemd.enable = true; to enable

  services.fwupd.enable = true;
  systemd.timers.fwupd-refresh.enable = false; # https://github.com/NixOS/nixpkgs/issues/271834

  networking.wireless.interfaces = [ "wlp2s0" ];
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  services.logind.lidSwitch = "suspend-then-hibernate";
  services.logind.lidSwitchDocked = "ignore";
  services.logind.extraConfig = ''
    HandlePowerKey=hibernate
  '';
  services.udisks2 = {
    enable = true;
  };
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  systemd.network.wait-online.enable = false;
  # Enable network manager applet
  programs.nm-applet.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable the LXQT Desktop Environment.
  services.libinput.enable = true;

  fonts = {
    packages = with pkgs; [
      # icon fonts

      open-dyslexic
      noto-fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
      nerd-fonts.symbols-only
      font-awesome
      noto-fonts-emoji
      mplus-outline-fonts.githubRelease
      noto-fonts-cjk-sans
      dina-font
    ];

    fontDir.enable = true;
    # use fonts specified by user rather than default ones
    enableDefaultPackages = false;

    # user defined fonts
    fontconfig.defaultFonts = {
      monospace = [
        "JetBrainsMono Nerd Font"
        "Noto Color Emoji"
      ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  programs.git.enable = true;

  # ----- Podman ---------
  virtualisation.containers.enable = true;
  virtualisation = {
    docker.enable = false;
    podman = {
      autoPrune.enable = true;
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  # ----- Podman ---------

  powerManagement.enable = true;
  # Configure keymap in wayland
  services.xserver = {
    xkb.layout = "us,no";
    xkb.options = "grp:win_space_toggle";
  };

  # Configure console keymap
  console.keyMap = "no";

  # Enable CUPS to print documents.
  services.printing = {
    enable = false;
    browsing = true;
    drivers = with pkgs; [
      gutenprint
    ];
  };

  services.journald.extraConfig = "SystemMaxUse=1G";

  security = {
    polkit.enable = true;
    #pam.services.swaylock = { };
  };

  services.fprintd.enable = false;

  services.gnome.gnome-keyring.enable = true;

  # sway light
  programs.light.enable = true;

  # Enable sound with pipewire.

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  # services.tlp.settings = {
  #   START_CHARGE_THRESH_BAT0 = 75;
  #   STOP_CHARGE_THRESH_BAT0 = 80;
  #   RESTORE_THRESHOLDS_ON_BAT = 1;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.

  programs.starship.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    vim
    dive
    podman-tui
    podman-compose
    podman-desktop

    pulseaudio
    pavucontrol

    grc
    fd
    zbar

    # Youtube
    yt-dlp
    (pkgs.writers.writeDashBin "youtube-dl" ''
      exec ${pkgs.yt-dlp}/bin/yt-dlp "@"
    '')

    (writers.writeDashBin "btc-kraken" ''
      ${curl}/bin/curl -Ss 'https://api.kraken.com/0/public/Ticker?pair=BTCUSD' | ${jq}/bin/jq '.result.XXBTZUSD.a[0]'
    '')
    (writers.writeDashBin "btc-bitmynt" ''
      ${curl}/bin/curl -Ss 'https://ny.bitmynt.no/data/rates.json' | ${jq}/bin/jq .'current_rate.bid'
    '')
  ];

  environment.variables.EDITOR = "nvim";
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
