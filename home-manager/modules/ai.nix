{
  pkgs,
  self,
  inputs,
  ...
}:
{
  home.packages =
    let
      aiTools = inputs.nix-ai-tools.packages.${pkgs.stdenv.hostPlatform.system};
    in
    [
      self.packages.${pkgs.stdenv.hostPlatform.system}.claude-md
      self.packages.${pkgs.stdenv.hostPlatform.system}.cursor-agent
      aiTools.opencode
      aiTools.coderabbit-cli
      aiTools.goose-cli
      aiTools.cursor-agent
      aiTools.spec-kit
      pkgs.pueue
    ];
}
