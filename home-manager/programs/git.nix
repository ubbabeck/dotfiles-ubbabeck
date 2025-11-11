{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    #userName = "ruben";
    #userEmail = "ruben@sdu.as";
    settings = {
      merge.conflictstyle = "diff3";
    };

    ignores = [
      "*.swp"
      "result"
      ".direnv/"
      ".idea/"
    ];
  };
  programs.difftastic = {
    git = {
      enable = true;
      diffToolMode = true;
    };

    options = {
      color = "dark";
      sort-path = true;
      tab-width = 8;
    };
  };
}
