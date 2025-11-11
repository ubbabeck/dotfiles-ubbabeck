{
  imports = [
    #./sway.nix
    #./sway-bars.nix
    #./wayland.nix
    ./file-manager.nix
    ../modules/ai.nix
  ];
  services.syncthing.enable = true;
}
