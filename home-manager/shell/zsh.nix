{
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    starship
  ];

  #      the standard path under ~/.config/
  #           to find the file       Where the file is located relative to this .nix file
  #                    |                             |
  #                    V                             V
  xdg.configFile."starship.toml".source = lib.mkForce ./starship.toml;

  programs.starship = {
    enable = false;
    enableZshIntegration = true;

  };

  #programs.fish = {
  #  enable = true;
  #  interactiveShellInit = ''
  #    set fish_greeting # Disable greeting
  #  '';

  #  plugins = [
  #    {
  #      name = "grc";
  #      src = pkgs.fishPlugins.grc.src;
  #    }
  #  ];
  #  generateCompletions = true;

  #  # set some aliases, feel free to add more or remove some
  #  shellAbbrs = {
  #    eza = "eza -l --icons --time-style=long-iso --group-directories-first";
  #    gs = "git status";
  #  };

  #};
}
