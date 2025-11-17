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
}
