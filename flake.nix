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
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    ngit.url = "github:DanConwayDev/ngit-cli";
    ngit.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin.url = "github:catppuccin/nix";
    catppuccin.inputs.nixpkgs.follows = "nixpkgs";

    nix-ai-tools = {
      url = "github:numtide/nix-ai-tools";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    clan-core.url = "git+https://git.clan.lol/clan/clan-core";
    clan-core.inputs.nixpkgs.follows = "nixpkgs";
    clan-core.inputs.flake-parts.follows = "flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        withSystem,
        self,
        config,
        ...
      }:
      {
        imports = [
          ./machines/flake-module.nix
          inputs.clan-core.flakeModules.default
        ];
        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
        ];

        perSystem =
          {
            inputs',
            self',
            lib,
            system,
            ...
          }:
          {
            # make pkgs available to all `perSystem` functions
            _module.args.pkgs = inputs'.nixpkgs.legacyPackages;

            checks =
              let
                machinesPerSystem = {
                  aarch64-linux = [
                  ];
                  x86_64-linux = [
                    "thinkpad-p14"
                  ];
                };

                allowed-unfree-packages = [
                  "zerotierone"
                  "obsidian"
                  "vmware-workstation"
                ];
                nixosMachines = lib.mapAttrs' (n: lib.nameValuePair "nixos-${n}") (
                  lib.genAttrs (machinesPerSystem.${system} or [ ]) (
                    name: self.nixosConfigurations.${name}.config.system.build.toplevel
                  )
                );

                blacklistPackages = [
                  "install-iso"
                  "nspawn-template"
                  "netboot-pixie-core"
                  "netboot"
                ];
                packages = lib.mapAttrs' (n: lib.nameValuePair "package-${n}") (
                  lib.filterAttrs (n: _v: !(builtins.elem n blacklistPackages)) self'.packages
                );

                devShells = lib.mapAttrs' (n: lib.nameValuePair "devShell-${n}") self'.devShells;

                homeConfigurations = lib.mapAttrs' (
                  name: config: lib.nameValuePair "home-manager-${name}" config.activation-script
                ) (self'.legacyPackages.homeConfigurations or { });

              in
              nixosMachines // packages // devShells // homeConfigurations;

          };
      }
    );
}
