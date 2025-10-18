{
  lib,
  pkgs,
  allowed-unfree-packages,
  ...
}:
{
  # Packages that should be installed to the user profile.
  # TODO split and clean up
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    fastfetch
    league-of-moveable-type

    gimp3
    # archives
    zip
    xz
    unzip

    eternal-terminal
    ferdium

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    fzf # A command-line fuzzy finder
    mdcat
    bottom

    # sound
    #rhythmbox

    #video player
    mpv
    adwaita-icon-theme
    hicolor-icon-theme
    graphicsmagick
    screen-message
    sshfs-fuse
    inxi

    #screen show
    ghostty

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

    gdb
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
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb

    apksigner # for verifying apk files

    #
    neovide
    # password manager
    keepassxc

    # remote programming
    mob

    calibre

    # gitlab cli
    glab

    # gh
    gh

    zoxide

    # accounting
    hledger

    # signal desktop
    # TOOD add norwegian language
    signal-desktop
    # obsidian
    obsidian

    # pueue for long running task
    pueue

    #ungoogled chromeium
    ungoogled-chromium

    # tor browser
    tor-browser

    anki

    #libreoffie
    libreoffice

    #sqlitebrowser
    sqlitebrowser

    # electrum
    electrum

    #email
    evolution

    #just
    just

    dust
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
