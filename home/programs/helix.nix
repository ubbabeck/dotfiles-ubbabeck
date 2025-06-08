{ pkgs, ... }:
{
  home.packages = [
    pkgs.python312Packages.python-lsp-server
  ];
  programs.helix = {
    enable = true;

    settings = {

      theme = "onedark";
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
      };
    };
    languages = {

      language-server.typescript-language-server = with pkgs.nodePackages; {
        command = "${typescript-language-server}/bin/typescript-language-server";
        args = [
          "--stdio"
          "--tsserver-path=${typescript}/lib/node_modules/typescript/lib"
        ];
      };
      language = [

        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
        }
        {
          name = "rust";
          auto-format = true;

        }
        { name = "python"; }
      ];
    };
  };
}
