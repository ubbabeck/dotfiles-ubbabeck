{ config, ... }:
{

  users.users.ruben.openssh.authorizedKeys.keys = [

    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILAxHsji/CvivMu2uBdgs3hEQjUJNhtLtyWlMtinA3H8 "
  ];
  users.users.root.openssh.authorizedKeys.keys = config.users.users.ruben.openssh.authorizedKeys.keys;

  environment.etc."ssh/ssh_config.d/jumphost.conf".text = '''';

  programs.ssh.knownHosts.ssh-ca = {
    certAuthority = true;
    hostNames = [
    ];
    publicKeyFile = ./ssh-ca.pub;
  };

  programs.ssh.knownHosts."" = {
    hostNames = [ "" ];
    publicKey = "";
  };
}
