{ self, ... }:

let
  borgbackupExcludes = import ../nixosModules/borgbackup-excludes.nix;
in
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
        fyrstikkeske.deploy.targetHost = "root@192.168.42.116";
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

        borgbackup-fystikkeske = {
          module.name = "borgbackup";
          module.input = "clan-core";
          roles.server.machines.fyrstikkeske = { };
          roles.server.settings.directory = "/var/lib/borgbackup";
          roles.client.machines.fyrstikkeske.settings.exclude = borgbackupExcludes;
        };

        sshd-ubbabeck = {
          module.name = "sshd";
          module.input = "clan-core";
          roles.server.tags.nixos = { };
          roles.client.tags.nixos = { };
          # searchDomains on the server role end up as principals in the host
          # certificates; without them connections via e.g. eve.i warn about
          # "name is not a listed principal".
          roles.server.settings = {
            certificate.searchDomains = [
              "i"
              "r"
              "local"
              "onion"
            ];
          };
          roles.client.settings = {
            certificate.searchDomains = [
              "i"
              "r"
              "local"
              "onion"
            ];
          };
        };

        # Direct SSH reachability over the LAN/clearnet (highest priority in
        # clan's networking fallback). Update host if the IP changes; replace
        # with zerotier/wireguard later for a stable overlay address.
        internet.roles.default.machines.fyrstikkeske = {
          settings.host = "192.168.42.116";
          settings.user = "root";
        };
      };
    };
  };
}
