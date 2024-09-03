{ self, pkgs, ... }:
{
  nix.nixPath = [ "nixpkgs=${self.inputs.nixpkgs}" ];
}
