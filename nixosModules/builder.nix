{
  users.users.nix = {
    isSystemUser = true;
    home = "/var/empty";
    group = "nix";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILAxHsji/CvivMu2uBdgs3hEQjUJNhtLtyWlMtinA3H8"
    ];
  };
  users.groups.nix = { };

  nix.settings.trusted-users = [ "nix" ];
}
