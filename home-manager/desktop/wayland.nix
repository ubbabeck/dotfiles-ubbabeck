{
  ...
}:
{
  programs.rofi = {
    enable = false;
  };

  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 50.8;
    longitude = 4.3;
  };
}
