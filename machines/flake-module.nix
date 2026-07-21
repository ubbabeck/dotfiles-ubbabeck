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

      # `config.nixos` is the list of NixOS machine names (darwin machines like
      # steve are excluded). backup = every NixOS machine except the server.
      tags =
        { config, ... }:
        {
          backup = builtins.filter (name: name != "fyrstikkeske") config.nixos;
        };

      machines = {
        steve.machineClass = "darwin";
        fyrstikkeske.deploy.targetHost = "root@192.168.42.116";
        archie.deploy.targetHost = "root@178.238.236.110";
      };
      instances = {
        emergency-access = {
          module.name = "emergency-access";
          module.input = "clan-core";
          roles.default.tags.nixos = { };
        };

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
          roles.server.machines.fyrstikkeske.settings.address = "192.168.42.116";
          roles.server.settings.directory = "/var/lib/borgbackup";
          # Applied to every client: declares clan.core.state folders to back up.
          roles.client.extraModules = [ ../nixosModules/borgbackup.nix ];
          # Every NixOS machine except the server backs up to fyrstikkeske.
          roles.client.tags.backup = { };
          roles.client.settings.exclude = borgbackupExcludes;
        };

        zerotier-ubbabeck = {
          module.name = "zerotier";
          module.input = "clan-core";
          roles.controller.machines.archie = { };
          roles.moon.machines.archie.settings = {
            stableEndpoints = [
              "178.238.236.110"
              "2a02:c207:2342:7388::1"
            ];
          };
          roles.peer.tags.nixos = { };
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
        internet.roles.default.machines.archie = {
          settings.host = "178.238.236.110";
          settings.user = "root";
        };
      };
    };
  };
}
