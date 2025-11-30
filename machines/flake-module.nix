{ self, ... }:
{
  flake.nixosModules.default = ../nixosModules/default.nix;

  clan = {
    meta.name = "ubbabeck";

    pkgsForSystem = system: self.inputs.nixpkgs.legacyPackages.${system};

    # Define machines in the inventory
    # clan-core will automatically discover machines from ./machines/<machine-name>/
    # and use configuration.nix or default.nix as the entry point

    inventory = {

      machines.steve.machineClass = "darwin";

    };
  };
}
