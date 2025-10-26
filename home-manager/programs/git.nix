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
    git.enable = true;
  };
}
