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
    hercules-ci-effects.url = "github:hercules-ci/hercules-ci-effects";
    hercules-ci-effects.inputs.nixpkgs.follows = "nixpkgs";
    hercules-ci-effects.inputs.flake-parts.follows = "flake-parts";

    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix.url = "git+https://github.com/nixos/nix?shallow=1";
    nix.inputs.nixpkgs.follows = "nixpkgs";
    nix.inputs.flake-parts.follows = "";
    nix.inputs.flake-compat.follows = "";
    nix.inputs.nixpkgs-regression.follows = "";
    nix.inputs.git-hooks-nix.follows = "";
    nix.inputs.nixpkgs-23-11.follows = "";

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    ngit.url = "github:DanConwayDev/ngit-cli";
    ngit.inputs.nixpkgs.follows = "nixpkgs";

    nix-ai-tools = {
      url = "github:numtide/nix-ai-tools";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    clan-core.url = "git+https://git.clan.lol/clan/clan-core";
    clan-core.inputs.nixpkgs.follows = "nixpkgs";
    clan-core.inputs.flake-parts.follows = "flake-parts";
    clan-core.inputs.nixos-facter-modules.follows = "nixos-facter-modules";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

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
          ./devshell/flake-module.nix
          ./home-manager/flake-module.nix
          inputs.clan-core.flakeModules.default
          inputs.hercules-ci-effects.flakeModule
        ];
        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
        ];
        herculesCI = herculesCI: {
          onPush.default.outputs.effects.deploy = withSystem config.defaultEffectSystem (
            { pkgs, hci-effects, ... }:
            hci-effects.runIf (herculesCI.config.repo.branch == "main") (
              hci-effects.mkEffect {
                effectScript = ''
                  echo "${builtins.toJSON { inherit (herculesCI.config.repo) branch tag rev; }}"
                  ${pkgs.hello}/bin/hello
                '';
              }
            )
          );
        };

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
