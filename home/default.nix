{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./programs
    ./shell
    ./desktop
  ];

  home = {
    username = "ruben";
    homeDirectory = "/home/ruben";
    stateVersion = "24.05";
  };
  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
