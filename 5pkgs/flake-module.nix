{
  perSystem =
    {
      pkgs,
      inputs',
      ...
    }:
    {
      packages = {
        checkhash = pkgs.callPackage ./checkhash { };
        claude-code = pkgs.callPackage ./claude-code {
          claude-code = inputs'.nix-ai-tools.packages.claude-code;
        };
      };
    };
}
