{
  description = "rubens flake";

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://cache.lix.systems"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
    ];
  };
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-3.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      lix-module,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      allowed-unfree-packages = [
        "zerotierone"
        "obsidian"
      ];
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'

      nixosConfigurations = {
        thinkpad-p14 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              self
              inputs
              outputs
              allowed-unfree-packages
              ;
          };
          # > Our main nixos configuration file <
          modules = [
            ./nixos
            #./tools/flake.nix

            inputs.nixos-facter-modules.nixosModules.facter
            { config.facter.reportPath = ./facter.json; }

            lix-module.nixosModules.default

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.users.ruben = import ./home;
              home-manager.extraSpecialArgs = {
                inherit allowed-unfree-packages;
              };
            }
          ];
        };
      };
    };
}
