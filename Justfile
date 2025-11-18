check:
        nix flake check .# -L 

switch:
        doas nixos-rebuild switch --flake .# -L

update COMMIT="":
        nix flake update -L {{COMMIT}}

update-commit:
        just update --commit-lock-file

