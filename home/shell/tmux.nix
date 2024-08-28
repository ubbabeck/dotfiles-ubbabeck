{ ... }:
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    terminal = "tmux-256color";
    keyMode = "vi";
    mouse = true;
    customPaneNavigationAndResize = true;
    reverseSplit = true;
    extraConfig = ''
      set-option -ga terminal-overrides ",alacritty:Tc"
      set-option -g status-right "tmux"
      set-option -g status-style "bg=black, fg=gray"
    '';
  };
}
