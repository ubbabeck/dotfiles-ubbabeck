{ config, ... }:
let
  id = "bottom";
in
{
  programs.i3status-rust = {
    enable = true;
    bars = {
      "${id}" = {
        icons = "awesome6";
        blocks = [
          {
            block = "sound";
            format = "$output_description $icon {$volume.eng(w:2) |}";
          }
          {
            block = "cpu";
          }
          { block = "memory"; }
          { block = "disk_space"; }
          {
            block = "time";
            format = "$icon $timestamp.datetime(f:'%F %a %R')";
          }
          {
            block = "keyboard_layout";
            driver = "sway";
            mappings = {
              "Norsk (NO)" = "NO";
              "English (US)" = "US";
            };
          }
          {
            block = "sound";
            device_kind = "source";
            format = "$icon";
          }
          {
            block = "battery";
            missing_format = "";
          }
        ];
      };
    };
  };
  wayland.windowManager.sway.config.bars = [
    {
      statusCommand = "i3status-rs ${config.xdg.configHome}/i3status-rust/config-${id}.toml";
      mode = "hide";
      trayOutput = "none";
      fonts = {
        names = [ "monospace" ];
        size = 12.0;
        style = "Bold";
      };
    }
  ];
}
