{pkgs, ...}:
with pkgs; {
  programs.neovim = {
    enable = true;

    coc = {
      enable = true;
      settings = {
        "languageserver" = {
          nix = {
            command = "nixd";
            filetypes = ["nix"];
          };
        };
      };
      pluginConfig = ''
        inoremap <silent><expr> <Tab>
                \ coc#pum#visible() ? coc#pum#next(1) :
                \ CheckBackspace() ? "\<Tab>" :
                \ coc#refresh()

        inoremap <expr> <Tab>
               \ coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"

        inoremap <expr> <S-Tab>
               \ coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"

        inoremap <silent><expr> <tab> pumvisible() ? coc#_select_confirm : "\<C-g>u\<tab>"
      '';
    };

    plugins = with vimPlugins; [
      scope-nvim
      surround-nvim
      vim-nix
      coc-rust-analyzer
      coc-sh
      coc-spell-checker
      ale
      nvim-autopairs
      YouCompleteMe
      coc-html
    ];
    extraConfig = ''
      syntax on
      filetype plugin indent on
      set number relativenumber
      set number
      set backspace=indent,eol,start
      set cc=80
      if &diff
        colorscheme blue
      endif
    '';
    viAlias = true;
    vimAlias = true;
  };
}
