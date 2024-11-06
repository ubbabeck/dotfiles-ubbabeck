{ pkgs, ... }:
{

  programs.adb.enable = true;
  users.users.ruben.extraGroups = [ "adbusers" ];

  services.udev.packages = [
    pkgs.android-udev-rules
  ];

}
