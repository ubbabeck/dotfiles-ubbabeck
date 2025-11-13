{ ... }:
{
  imports = [
    ./configuration.nix
    ./nix.nix
    ./programs
    ./zerotier.nix
    ./yubikey.nix
    #./sway.nix
    ./tor.nix
    ./android.nix
    #./wireguard.nix
    ./file-manager.nix
    ./hardened.nix
    #./virt-manager.nix
    #./auto-cpufreq.nix
  ];
}
