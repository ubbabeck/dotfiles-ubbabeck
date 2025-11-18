{
  virtualisation.libvirtd.enable = true;
  users.users.ruben.extraGroups = [ "libvirtd" ];
  networking.firewall.checkReversePath = false;
  programs.virt-manager.enable = true;
}
