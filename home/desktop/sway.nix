{
  config,
  pkgs,
  lib,
  ...
}: let
  loginctl = "${pkgs.systemd}/bin/loginctl";
  swaymsg = "${pkgs.sway}/bin/swaymsg";
  systemctl = "${pkgs.systemd}/bin/systemctl";

  wpaperd-config = {
    default = {
      path = "~/Documents/Pictures/Backgrounds";
    };
  };

  wpaperd-config-dir = pkgs.runCommand "wpaperd-config" {} ''
    mkdir -p $out/wpaperd
    cp ${(pkgs.formats.toml {}).generate "wallpaper.toml" wpaperd-config} $out/wpaperd/wallpaper.toml
  '';
in {
  wayland.windowManager.sway = {
    enable = true;
    package = null;
    config = null;
    systemd.xdgAutostart = true;
    extraConfig = lib.fileContents ./sway.conf;
  };

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

  programs.bemenu.enable = true;

  systemd.user.services.swaylock = {
    Unit.Description = "Lock screen";
    Service.ExecStart = "${config.programs.swaylock.package}/bin/swaylock";
  };

  systemd.user.services.wpaperd = {
    Unit = {
      Description = "Wallpaper daemon";
      After = ["graphical-session-pre.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${pkgs.wpaperd}/bin/wpaperd";
      Environment = "XDG_CONFIG_HOME=${wpaperd-config-dir}";
    };

    Install.WantedBy = ["graphical-session.target"];
  };
}
