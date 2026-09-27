{ self, ... }:
{
  nix.settings.nix-path = [ "nixpkgs=${self.inputs.nixpkgs}" ];
}
