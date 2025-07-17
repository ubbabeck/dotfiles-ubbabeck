{
  description = "rubens flake";

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      catppuccin,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      allowed-unfree-packages = [
        "zerotierone"
        "obsidian"
        "vmware-workstation"
        "cnijfilter2"
      ];
      pkgs = import nixpkgs;
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
          modules = [
            ./nixos
            ./modules
            catppuccin.nixosModules.catppuccin
            #./tools/flake.nix

            #nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen4

            inputs.nixos-facter-modules.nixosModules.facter
            { config.facter.reportPath = ./facter.json; }

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.users.ruben = {
                imports = [
                  ./home-manager
                  catppuccin.homeModules.catppuccin
                ];
              };
              home-manager.extraSpecialArgs = {
                inherit allowed-unfree-packages;
              };
            }
          ];
        };
      };

    };
}
