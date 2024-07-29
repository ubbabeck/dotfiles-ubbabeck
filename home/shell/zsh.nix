{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    zsh-powerlevel10k
  ];
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    # set some aliases, feel free to add more or remove some
    shellAliases = {
      ls = "eza";
      gs = "git status";
    };

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };
  };
}
