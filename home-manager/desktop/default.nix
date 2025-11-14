{
  imports = [
    ./file-manager.nix
    ../modules/ai.nix
  ];
  services.syncthing.enable = true;
}
