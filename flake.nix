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

    # Nixos Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      allowed-unfree-packages = [
        "zerotierone"
        "obsidian"
        "rust-rover"
      ];
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'

      nixosConfigurations = {
        thinkpad-p14 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs allowed-unfree-packages;
          };
          # > Our main nixos configuration file <
          modules = [
            ./nixos/configuration.nix

            nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen4

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
