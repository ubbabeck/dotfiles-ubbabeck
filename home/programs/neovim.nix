{pkgs, ...}:
with pkgs; {
  programs.neovim = {
    enable = true;

    coc.enable = true;

    plugins = with vimPlugins; [
      scope-nvim
      surround-nvim
      vim-nix
      coc-python
      coc-pyright
      coc-rust-analyzer
      coc-sh
      coc-spell-checker
      coc-html
    ];
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
