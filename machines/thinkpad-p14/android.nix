{ ... }:
{

  programs.adb.enable = true;
  users.users.ruben.extraGroups = [ "adbusers" ];
}
