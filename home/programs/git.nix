{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "ruben";
    userEmail = "ruben@sdu.as";

    difftastic.enable = true;
    difftastic.background = "dark";
    ignores = ["*.swp" "result" ".envrc" ".direnv/"];
  };
}
