{ pkgs, ... }:
{
  # for pactl
  environment.systemPackages = with pkgs; [
    pulseaudio
    pamixer
  ];

  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };
  security.rtkit.enable = true;
  security = {
    polkit.enable = true;
    #pam.services.swaylock = { };
    audit.enable = false;
  };
}
