{
  virtualisation.libvirtd.enable = true;
  users.users.ruben.extraGroups = [ "libvirtd" ];
  networking.firewall.trustedInterfaces = [ "virbr0" ];
  networking.firewall.checkReversePath = false;
  programs.virt-manager.enable = true;
}
