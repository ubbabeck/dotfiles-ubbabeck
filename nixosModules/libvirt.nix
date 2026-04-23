{
  pkgs,
  ...
}:
{
  virtualisation.libvirtd.enable = true;
  users.users.ruben.extraGroups = [ "libvirtd" ];
  networking.firewall.checkReversePath = false;
  networking.firewall.trustedInterfaces = [ "virbr0" ];
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    dnsmasq
    guestfs-tools
  ];

}
