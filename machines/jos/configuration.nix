{ pkgs, self, ... }:
{
  imports = [

    self.inputs.nixos-hardware.nixosModules.common-pc-ssd
    self.inputs.nix-index-database.nixosModules.nix-index
    self.nixosModules.default
    { programs.nix-index-database.comma.enable = true; }
    self.inputs.srvos.nixosModules.desktop
    self.inputs.disko.nixosModules.disko
    ./modules/disko.nix
    # Include the results of the hardware scan.
    #./modules/networkmanager
    ../../nixosModules/users.nix
    ../../nixosModules/i18n.nix
    #../../nixosModules/kde
    ../../nixosModules/niri
    ../../nixosModules/evolution.nix
    ../../nixosModules/workstation.nix
    ../../nixosModules/powertop.nix
    ../../modules/default.nix
    ../../nixosModules/fhs-compat.nix
    ../../nixosModules/mullvad.nix
    ../../nixosModules/libvirt.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.cleanOnBoot = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  services.fwupd.enable = true;
  systemd.timers.fwupd-refresh.enable = false; # https://github.com/NixOS/nixpkgs/issues/271834
  boot.plymouth.enable = true;

  #networking.wireless.interfaces = [ "wlp2s0" ];
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  services.logind.settings.Login = {
    HandlePowerKey = "hibernate";
    lidSwitch = "suspend-then-hibernate";
    lidSwitchDocked = "ignore";
  };
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

  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable the LXQT Desktop Environment.
  services.libinput.enable = true;

  programs.git.enable = true;

  # Configure console keymap
  console.keyMap = "us";

  services.blueman.enable = true;

  hardware = {
    graphics.enable = true;
    bluetooth.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    vim
    dive
    nixos-rebuild-ng

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
    aspell
    aspellDicts.en
    aspellDicts.da
    aspellDicts.nn
    aspellDicts.de
    hunspell
    hunspellDicts.nn-no

  ];

  environment.variables.EDITOR = "nvim";
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    zsh = {
      enable = true;
      promptInit = "";
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "prohibit-password";
}
