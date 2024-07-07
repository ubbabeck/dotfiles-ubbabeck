{pkgs, ...}: {
  programs.neovim = {
    enable = true;

    extraConfig = ''
      set number relativenumber
      set number
      set cc=80
      if &diff
        colorscheme blue
      endif
    '';
    viAlias = true;
    vimAlias = true;
  };
}
