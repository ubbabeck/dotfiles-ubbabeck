{ pkgs, ... }:
{

  users.users = {
    ruben = {
      isNormalUser = true;
      home = "/home/ruben";
      description = "ruben";
      extraGroups = [
        "networkmanager"
        "wheel"
        "podman"
        "video"
      ];
      uid = 1000;

      shell = pkgs.zsh;
    };
  };
  imports = [ ./zsh.nix ];
}
