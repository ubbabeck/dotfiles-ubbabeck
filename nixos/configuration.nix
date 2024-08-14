# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  allowed-unfree-packages,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./sway.nix
    ./programs
    ./zerotier.nix
    ./yubikey.nix
  ];

  security.doas.enable = true;
  security.sudo.enable = false;
  security.doas.extraRules = [
    {
      users = ["ruben"];
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
      trusted-users = ["root" "ruben"];
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
      keep-outputs = true;
      keep-derivations = true;
    };

    package = pkgs.nixVersions.latest;
  };

  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) allowed-unfree-packages;
  };
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-1c3d6c0f-5c93-4c26-9b50-5a8db85684c6".device = "/dev/disk/by-uuid/1c3d6c0f-5c93-4c26-9b50-5a8db85684c6";
  networking.hostName = "thinkpad-p14"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable network manager applet
  programs.nm-applet.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nb_NO.UTF-8";
    LC_IDENTIFICATION = "nb_NO.UTF-8";
    LC_MEASUREMENT = "nb_NO.UTF-8";
    LC_MONETARY = "nb_NO.UTF-8";
    LC_NAME = "nb_NO.UTF-8";
    LC_NUMERIC = "nb_NO.UTF-8";
    LC_PAPER = "nb_NO.UTF-8";
    LC_TELEPHONE = "nb_NO.UTF-8";
    LC_TIME = "nb_NO.UTF-8";
  };

  services.xserver.enable = true;

  # Enable the LXQT Desktop Environment.
  services.libinput.enable = true;

  fonts = {
    packages = with pkgs; [
      # icon fonts

      #open-dyslexic
      noto-fonts
      # nerdfonts
      (nerdfonts.override {fonts = ["JetBrainsMono" "Iosevka" "NerdFontsSymbolsOnly"];})
      font-awesome
      noto-fonts-emoji
    ];

    fontDir.enable = true;
    # use fonts specified by user rather than default ones
    enableDefaultPackages = false;

    # user defined fonts
    fontconfig.defaultFonts = {
      monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };

  programs.git.enable = true;

  # -----Docker ---------
  virtualisation.containers.enable = true;
  virtualisation = {
    docker.enable = false;
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  # -----Docker ---------

  # Configure keymap in wayland
  services.xserver = {
    xkb = {
      layout = "no";
      variant = "";
    };
  };

  # Configure console keymap
  console.keyMap = "no";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  security = {
    polkit.enable = true;
    pam.services.swaylock = {};
  };

  services.gnome.gnome-keyring.enable = true;

  # sway light
  programs.light.enable = true;

  # Enable sound with pipewire.

  hardware.pulseaudio.enable = false;
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

  services.fprintd = {
    enable = false;
    # TODO allowUnFree for this packages
    # tod = {
    #   enable = true;
    #   driver = pkgs.libfprint-2-tod1-goodix;
    # };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ruben = {
    isNormalUser = true;
    description = "ruben";
    extraGroups = ["networkmanager" "wheel" "podman" "video"];
    packages = with pkgs; [
      #  thunderbird
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

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

    # Sway
    grim
    slurp
    wl-clipboard
    mako

    # Youtube
    yt-dlp
    (pkgs.writers.writeDashBin "youtube-dl" ''
      exec ${pkgs.yt-dlp}/bin/yt-dlp "@"
    '')

    (pkgs.writers.writeDashBin "btc-kraken" ''
      ${pkgs.curl}/bin/curl -Ss 'https://api.kraken.com/0/public/Ticker?pair=BTCEUR' | ${pkgs.jq}/bin/jq '.result.XXBTZEUR.a[0]'
    '')
    (pkgs.writers.writeDashBin "btc-bitmynt" ''
      ${pkgs.curl}/bin/curl -Ss 'https://ny.bitmynt.no/data/rates.json' | ${pkgs.jq}/bin/jq .'current_rate.bid'
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
