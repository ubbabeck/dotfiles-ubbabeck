{pkgs, ...}: {
  home.packages = with pkgs; [
    tmuxPlugins.cpu
  ];

  programs.tmux = {
    enable = true;
    clock24 = true;
    terminal = "screen-256color";
    keyMode = "vi";
    mouse = true;
    reverseSplit = true;
    extraConfig = ''
      set -g status-right '#[fg=black,bg=color15] #{cpu_percentage}  %H:%M '
      set-option -sg escape-time 10
      run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
    '';
  };
}
