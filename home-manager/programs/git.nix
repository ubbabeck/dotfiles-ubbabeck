{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "ruben";
    userEmail = "ruben@sdu.as";

    difftastic.enable = true;
    difftastic.options.background = "dark";
    ignores = [
      "*.swp"
      "result"
      ".direnv/"
      ".idea/"
    ];
  };
}
