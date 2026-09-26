{ config, pkgs, ... }:
{
  # The root dataset asks for its ZFS passphrase at boot. Without console
  # access, SSH into the initrd and answer it with:
  #   ssh -p 2222 root@bubi
  #
  # Networking comes from networking.useNetworkd + useDHCP, which NixOS
  # mirrors into the systemd initrd; virtio_net is already loaded via facter.

  # Separate host key from the main system: it is stored unencrypted in the
  # initrd on the ESP, so leaking it must not compromise the real host key.
  clan.core.vars.generators.initrd-ssh = {
    files."ssh_host_ed25519_key".neededFor = "activation";
    files."ssh_host_ed25519_key.pub".secret = false;
    runtimeInputs = [
      pkgs.coreutils
      pkgs.openssh
    ];
    script = ''
      ssh-keygen -t ed25519 -N "" -C "" -f $out/ssh_host_ed25519_key
    '';
  };

  # Interactive SSH logins run bash as a login shell, which sources
  # /etc/profile: answer the pending ZFS prompt right away, then fall through
  # to a normal shell for debugging if nothing was pending or it failed.
  boot.initrd.systemd.contents."/etc/profile".text = ''
    /bin/systemd-tty-ask-password-agent --query
  '';

  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      # Different port than the booted system, so clients don't hit a
      # host-key mismatch for the same host:port.
      port = 2222;
      authorizedKeys = config.users.users.root.openssh.authorizedKeys.keys;
      hostKeys = [ config.clan.core.vars.generators.initrd-ssh.files."ssh_host_ed25519_key".path ];
    };
  };
}
