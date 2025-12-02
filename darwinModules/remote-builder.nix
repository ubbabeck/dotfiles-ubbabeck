{ config, ... }:
{
  nix.distributedBuilds = true;

  nix.buildMachines = [
    {
      hostName = "jamie";
      sshUser = "nix";
      protocol = "ssh-ng";
      #sshKey = config.sops.secrets.ssh-remote-builder.path;
      systems = [
        "x86_64-linux"
        "i686-linux"
      ];
      maxJobs = 64;
      supportedFeatures = [
        "big-parallel"
        "kvm"
        "nixos-test"
      ];
    }
    {
      hostName = "eliza";
      sshUser = "nix";
      protocol = "ssh-ng";
      #sshKey = config.sops.secrets.ssh-remote-builder.path;
      system = "x86_64-linux";
      maxJobs = 224;
      supportedFeatures = [
        "big-parallel"
        "kvm"
        "nixos-test"
      ];
    }
    #{
    #  hostName = "aarch64.nixos.community";
    #  maxJobs = 96;
    #  sshKey = "/root/.ssh/id_ed25519";
    #  protocol = "ssh-ng";
    #  sshUser = "ruben";
    #  system = "x86_64-linux";
    #  supportedFeatures = [
    #    "big-parallel"
    #    "kvm"
    #    "nixos-test"
    #  ];
    #}
  ];

  programs.ssh.extraConfig = '''';
}
