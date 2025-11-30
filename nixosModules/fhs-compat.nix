{
  pkgs,
  lib,
  config,
  ...
}:

{
  services.envfs.enable = lib.mkDefault true;

  programs.nix-ld.enable = lib.mkDefault true;

  programs.nix-ld.libraries =
    with pkgs;
    [
      stdenv.cc.cc
      zlib
      zstd
      libnotify
      dbus
      util-linux
      libsodium
      icu
      libunwind
    ]
    ++ lib.optionals (config.hardware.graphics.enable) [
      libGL
      gtk3
      glib
    ];
}
