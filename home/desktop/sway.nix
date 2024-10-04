{
  config,
  pkgs,
  lib,
  ...
}:
let
  loginctl = "${pkgs.systemd}/bin/loginctl";
  swaymsg = "${pkgs.sway}/bin/swaymsg";
  systemctl = "${pkgs.systemd}/bin/systemctl";
  mod4 = "Mod4";
  wpaperd-config = {
    default = {
      path = "~/Documents/Pictures/Backgrounds";
    };
  };

  pactl = pkgs.pulseaudio + /bin/pactl;

  wpaperd-config-dir = pkgs.runCommand "wpaperd-config" { } ''
    mkdir -p $out/wpaperd
    cp ${(pkgs.formats.toml { }).generate "wallpaper.toml" wpaperd-config} $out/wpaperd/wallpaper.toml
  '';
in
{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config.modifier = mod4;
    config.terminal = "alacritty";
    config.input."type:touchpad" = {
      tap = "enabled";
      natural_scroll = "enabled";
    };
    config.input."type:keyboard".xkb_layout = "no,us";
    config.input."type:keyboard".xkb_options = "grp:win_space_toggle";

    config.keybindings = lib.mkOptionDefault {
      #"${mod4}+D" = "exec ${pkgs.rofi}/bin/rofi --show=drum";
      "${mod4}+Q" = "exec alacritty";
      # brightness
      "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 5";
      "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 5";
      # audio control
      "XF86AudioRaiseVolume" = "exec '${pactl} set-sink-volume @DEFAULT_SINK@ +5%'";
      "XF86AudioLowerVolume" = "exec '${pactl} set-sink-volume @DEFAULT_SINK@ -5%'";
      "XF86AudioMute" = "exec '${pactl} set-sink-mute @DEFAULT_SINK@ toggle'";
      "XF86AudioMicMute" = "exec '${pactl} set-source-mute @DEFAULT_SOURCE@ toggle'";
    };
    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1
    '';
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  xdg.portal.config.common.default = "*";

  services.swayidle = {
    enable = true;
    systemdTarget = "graphical-session.target";

    events = [
      {
        event = "lock";
        command = "${systemctl} --user start swaylock";
      }
    ];

    timeouts = [
      {
        timeout = 5 * 60;
        command = "${swaymsg} 'output * power off'";
        resumeCommand = "${swaymsg} 'output * power on'";
      }
      {
        timeout = 6 * 60;
        command = "${loginctl} lock-session";
      }
    ];
  };

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      screenshots = true;
      clock = true;
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 7;
      effect-blur = "7x5";
      show-failed-attempts = true;
      font-size = 24;
      color = "808080";
    };
  };

  systemd.user.services.swaylock = {
    Unit.Description = "Lock screen";
    Service.ExecStart = "${config.programs.swaylock.package}/bin/swaylock";
  };

  systemd.user.services.wpaperd = {
    Unit = {
      Description = "Wallpaper daemon";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.wpaperd}/bin/wpaperd";
      Environment = "XDG_CONFIG_HOME=${wpaperd-config-dir}";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
