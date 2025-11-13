{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/b048fb2f-7466-4181-8481-0a92fa13f3da";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-c241b575-3316-4a02-801a-07ca4b8bf33e".device =
    "/dev/disk/by-uuid/c241b575-3316-4a02-801a-07ca4b8bf33e";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3EB1-A084";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
      "umask=0077"
    ];
  };
  swapDevices = [
    { device = "/dev/disk/by-uuid/ee7b8438-ff63-422d-8a5e-b3871e034dff"; }
  ];
}
