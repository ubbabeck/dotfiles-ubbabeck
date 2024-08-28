{
  config,
  lib,
  pkgs,
  ...
}:
let
  swayConfig = pkgs.writeText "greetd-sway-config" ''
    # `-l` activates layer-shell mode. Notice that `swaymsg exit` will run after gtkgreet.
    exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l; swaymsg exit"
    bindsym Mod4+shift+e exec swaynag \
      -t warning \
      -m 'What do you want to do?' \
      -b 'Poweroff' 'systemctl poweroff' \
      -b 'Reboot' 'systemctl reboot'
    input * {
     xkb_layout "no"
    }

  '';
in
{
  # programs.sway = {
  #   enable = true;
  #   wrapperFeatures.gtk = true;
  # };

  # TODO need to wait for a certain systemd process to finish
  # https://github.com/apognu/tuigreet/issues/68
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = ''
            ${pkgs.greetd.tuigreet}/bin/tuigreet \
          --time \
          --asterisks \
          --user-menu \
          --cmd sway
        '';
      };
    };
  };
  environment.etc."greetd/environments".text = ''
    sway
    zsh
  '';
}
