{
  config,
  lib,
  pkgs,
  ...
}: let
  swayConfig = pkgs.writeText "greetd-sway-config" ''
    # `-l` activates layer-shell mode. Notice that `swaymsg exit` will run after gtkgreet.
    exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l; swaymsg exit"
    bindsym Mod4+shift+e exec swaynag \
      -t warning \
      -m 'What do you want to do?' \
      -b 'Poweroff' 'systemctl poweroff' \
      -b 'Reboot' 'systemctl reboot'

    bar {
      position bottom
    }
    # Brightness
    bindsym XF86MonBrightnessDown exec ${pkgs.light} -U 10
    bindsym XF86MonBrightnessUp exec ${pkgs.light} -A 10

    # Volume
    bindsym XF86AudioRaiseVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'
    bindsym XF86AudioLowerVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'
    bindsym XF86AudioMute exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'
  '';
in {
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  programs.waybar.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.sway}/bin/sway --config ${swayConfig}";
      };
    };
  };
  environment.etc."greetd/environments".text = ''
    sway
    zsh
  '';
}
