{
  pkgs,
  ...
}:
{
  # consider moving this to the homemanager module. instead.
  services.pcscd.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization ];

  environment.systemPackages = with pkgs; [
    yubikey-personalization
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
