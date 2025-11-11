{
  pkgs,
  inputs,
  ...
}:
{
  home.packages =
    let
      aiTools = inputs.nix-ai-tools.packages.${pkgs.stdenv.hostPlatform.system};
    in
    [
      aiTools.opencode
      aiTools.coderabbit-cli
      aiTools.goose-cli
      aiTools.cursor-agent
      aiTools.spec-kit
      pkgs.pueue
    ];
}
