{
  self,
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./programs/git.nix
    ./shell
    #./codename-goose.nix
    ./modules/ai.nix
    ./modules/atuin-autosync.nix
    ./modules/tmux-thumbs.nix
    ./modules/neovim
  ];

  nix.package = self.inputs.nix.packages.${pkgs.stdenv.hostPlatform.system}.nix;

  home.enableNixpkgsReleaseCheck = false;
  home = {
    username = lib.mkDefault "ruben";
    homeDirectory =
      if pkgs.stdenv.isDarwin then "/Users/${config.home.username}" else "/home/${config.home.username}";
    stateVersion = "24.05";
  };
  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
  # better eval time
  manual.html.enable = false;
  manual.manpages.enable = false;
  manual.json.enable = false;

  # Packages that should be installed to the user profile.
  # TODO split and clean up
  home.packages =
    with pkgs;
    [
      # here is some command line tools I use frequently
      # feel free to add your own or remove some of them

      fastfetch
      league-of-moveable-type

      # archives
      zip
      xz
      unzip

      nodejs

      xdg-utils

      eternal-terminal

      # utils
      ripgrep # recursively searches directories for a regex pattern
      jq # A lightweight and flexible command-line JSON processor
      yq-go # yaml processor https://github.com/mikefarah/yq
      fzf # A command-line fuzzy finder
      mdcat
      bottom

      #video player
      graphicsmagick
      screen-message
      sshfs-fuse
      inxi

      # networking tools
      mtr # A network diagnostic tool
      iperf3
      dnsutils # `dig` + `nslookup`
      ldns # replacement of `dig`, it provide the command `drill`
      aria2 # A lightweight multi-protocol & multi-source command-line download utility
      cheat
      socat # replacement of openbsd-netcat
      nmap # A utility for network discovery and security auditing
      ipcalc # it is a calculator for the IPv4/v6 addresses
      wget
      q

      wireguard-tools
      # misc
      file
      which
      tree
      gnused
      gnutar
      gawk
      zstd
      gnupg

      # nix related
      #
      # it provides the command `nom` works just like `nix`
      # with more details log output
      nix-output-monitor
      nix-tree
      alejandra
      nixfmt-rfc-style
      fh

      cargo
      cargo-watch

      # productivity
      glow # markdown previewer in terminal

      btop # replacement of htop/nmon
      iftop # network monitoring

      pciutils # lspci
      usbutils # lsusb

      apksigner # for verifying apk files

      #
      # password manager

      # remote programming
      mob

      # gitlab cli
      glab

      # gh
      gh

      zoxide

      # accounting
      hledger

      # signal desktop
      # TODO add norwegian language
      # obsidian
      #obsidian

      # pueue for long running task
      pueue

      #ungoogled chromeium

      # electrum
      #electrum

      #just
      just

      (pkgs.runCommand "uutils-coreutils" { } ''
        mkdir -p $out/bin
        for i in ${pkgs.uutils-coreutils}/bin/*; do
          ln -s "$i" "$out/bin/$(basename "''${i#${pkgs.uutils-coreutils}/bin/uutils-}")"
        done
      '')
      git
      mypy

      nixos-shell

      dust
    ]
    ++ lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
      ghostty
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [ iproute2mac ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      strace
      ethtool
      psmisc
      glibcLocales
      gdb
      # system call monitoring
      ltrace # library call monitoring
      lsof # list open files
      strace # system call monitoring
    ];
  programs.bat.enable = true;
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      vscodevim.vim
      yzhang.markdown-all-in-one
      llvm-vs-code-extensions.vscode-clangd
    ];
  };

}
