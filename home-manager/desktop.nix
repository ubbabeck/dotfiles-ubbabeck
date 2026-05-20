{ pkgs, ... }:
{
  imports = [
    ./modules/ai.nix
    ./modules/atuin-autosync.nix
    ./modules/tmux-thumbs.nix
  ];
  services.syncthing.enable = true;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [

    gimp3

    anki
    #libreoffice
    libreoffice
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
    iotop
    twitter-color-emoji
    git-lfs

    adwaita-icon-theme

    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    unifont

    dejavu_fonts
    ubuntu-classic
  ];
}
