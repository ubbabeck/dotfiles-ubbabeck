{pkgs, ...}: let
  options = {
    frame = "full";
    fork = false;
  };
in {
  home.packages = [pkgs.neovide];
  xdg.configFile."neovide/config.toml".source = pkgs.writers.writeTOML "neovide/config.toml" options;
}
