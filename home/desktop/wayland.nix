{
  pkgs,
  ...
}:
{
  programs.rofi = {
    enable = true;
    plugins = pkgs.networkmanager_dmenu;
  };
}
