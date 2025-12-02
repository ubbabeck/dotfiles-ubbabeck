{
  imports = [
    ./modules/ai.nix
    ./modules/atuin-autosync.nix
    ./modules/tmux-thumbs.nix
    ./programs/git.nix
    #./programs/neovim.nix
  ];
  services.syncthing.enable = true;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [

    gimp3

    anki
    #libreoffice
    libreoffice
    #email
    evolution

    #sqlitebrowser
    sqlitebrowser
    zed-editor
    ferdium
    mpv
    keepassxc
    calibre
    signal-desktop
    ungoogled-chromium
    # tor browser
    tor-browser
    ioto
    twitter-color-emoji
    hicolor-icon-theme

    adwaita-icon-theme

  ];
}
