{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./programs
    ./shell
    ./desktop
    ./codename-goose.nix
  ];

  home = {
    username = "ruben";
    homeDirectory = "/home/ruben";
    stateVersion = "24.05";
  };
  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
  services.network-manager-applet.enable = true;
  catppuccin = {
    enable = true;
    flavor = "mocha";
  };
  # better eval time
  manual.html.enable = false;
  manual.manpages.enable = false;
  manual.json.enable = false;

}
