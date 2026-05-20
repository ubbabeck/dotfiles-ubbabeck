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

      machines = {
        steve.machineClass = "darwin";
        fyrstikkeske.deploy.targetHost = "root@fyrstikkeske.x";
      };
      instances = {
        # TODO create this
        #        emergency-access = {
        #          module.name = "emergency-access";
        #          module.input = "clan-core";
        #          roles.default.tags.nixos = { };
        #        };
        users-root = {
          module.name = "users";
          module.input = "clan-core";
          roles.default.tags.nixos = { };
          roles.default.settings = {
            user = "root";
            prompt = true;
            groups = [ ];
          };
        };
        tor.roles.server.tags.nixos = { };

      };
    };
  };
}
