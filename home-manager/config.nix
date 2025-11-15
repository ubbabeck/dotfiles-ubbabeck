{
  nurFun ? (
    import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz")
  ),

  ...
}:
{
  allowUnfre = true;
  # https://github.com/nix-community/home-manager/issues/2942

  pulseaudio = true;
  #allowUnsupportedSystem = true;
  oraclejdk.accept_license = true;
  android_sdk.accept_license = true;

  packageOverrides = pkgs: {
    nur = nurFun {
      nurpkgs = pkgs;
      inherit pkgs;
    };
  };
}
