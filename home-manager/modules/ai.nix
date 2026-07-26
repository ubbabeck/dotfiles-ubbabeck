{
  pkgs,
  inputs,
  self,
  ...
}:
{
  home.packages =
    let
      aiTools = inputs.nix-ai-tools.packages.${pkgs.stdenv.hostPlatform.system};
      selfPkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
    in
    [
      aiTools.opencode
      aiTools.cursor-agent
      selfPkgs.claude-code
      aiTools.spec-kit
    ];
}
