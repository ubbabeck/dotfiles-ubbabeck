{
  imports = [
    #./sway.nix
    #./sway-bars.nix
    #./wayland.nix
    ./file-manager.nix
  ];
  services.syncthing.enable = true;
}
