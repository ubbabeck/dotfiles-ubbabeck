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
      aiTools.cursor-agent
      aiTools.claude-code
      aiTools.spec-kit
      pkgs.pueue
    ];
}
