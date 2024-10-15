{ pkgs, ... }:

let
  USER = "raf";

  internal = {
    device = "eDP-1";
    resolution = "2256x1504@60";
    position = "0x0";
    scale = "1.567";
    config = "${internal.device},${internal.resolution},${internal.position},${internal.scale}";
  };
  external = {
    device = "desc:Samsung Electric Company Odyssey G85SB H1AK500000";
    resolution = "3440x1440@120";
    position = "auto";
    scale = "1.67";
    vrr_mode = "vrr,1";
    config = "${external.device},${external.resolution},${external.position},${external.scale},${external.vrr_mode}";
  };
  default = {
    device = "";
    resolution = "preffered";
    position = "auto";
    scale = "1";
    config = "${default.device},${default.resolution},${default.position},${default.scale}";
  };
in
{
  imports = [
    ./dependencies.nix
    ./autostart.nix
    ./hyprlock.nix
    ./cursor.nix
    ./mouseless.nix
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  home-manager.users.${USER} = {
    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      xwayland.enable = true;
      systemd.enable = true;
      settings = {
        monitor = [
          "${internal.config}"
          "${external.config}"
          "${default.config}"
        ];
        binde = [
          ",XF86MonBrightnessDown, exec, brightnessctl set 5-"
          ",XF86MonBrightnessUp, exec, brightnessctl set 5+"
          ",XF86AudioLowerVolume, exec, amixer -q sset Master 5%-"
          ",XF86AudioRaiseVolume, exec, amixer -q sset Master 5%+"
        ];
        bind = [
          ",XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
          ",XF86AudioPrev, exec, playerctl previous"
          ",XF86AudioPlay, exec, playerctl play-pause"
          ",XF86AudioNext, exec, playerctl next"

          "CTRL ALT, DELETE, exec, shutdown now"
          "CTRL ALT, RETURN, exec, reboot"
          ",XF86PowerOff, exec, hyprlock"

          "CTRL, q, killactive"
          "CTRL, RETURN, exec, kitty"
          "CTRL, SPACE, exec, tofi-drun --drun-launch=true"

          "CTRL, up,    movefocus, u"
          "CTRL, right, movefocus, r"
          "CTRL, down,  movefocus, d"
          "CTRL, left,  movefocus, l"

          "CTRL SHIFT, up,    swapwindow, u"
          "CTRL SHIFT, right, swapwindow, r"
          "CTRL SHIFT, down,  swapwindow, d"
          "CTRL SHIFT, left,  swapwindow, l"

          "CTRL ALT, up,    resizeactive, 0 -10"
          "CTRL ALT, right, resizeactive, 10 0"
          "CTRL ALT, down,  resizeactive, 0 10"
          "CTRL ALT, left,  resizeactive, -10 0"

          "CTRL, 1, focusworkspaceoncurrentmonitor, 1"
          "CTRL, 2, focusworkspaceoncurrentmonitor, 2"
          "CTRL, 3, focusworkspaceoncurrentmonitor, 3"
          "CTRL, 4, focusworkspaceoncurrentmonitor, 4"
          "CTRL, 5, focusworkspaceoncurrentmonitor, 5"
          "CTRL, 6, focusworkspaceoncurrentmonitor, 6"
          "CTRL, 7, focusworkspaceoncurrentmonitor, 7"
          "CTRL, 8, focusworkspaceoncurrentmonitor, 8"
          "CTRL, 9, focusworkspaceoncurrentmonitor, 9"

          "CTRL SHIFT, 1, movetoworkspace, 1"
          "CTRL SHIFT, 2, movetoworkspace, 2"
          "CTRL SHIFT, 3, movetoworkspace, 3"
          "CTRL SHIFT, 4, movetoworkspace, 4"
          "CTRL SHIFT, 5, movetoworkspace, 5"
          "CTRL SHIFT, 6, movetoworkspace, 6"
          "CTRL SHIFT, 7, movetoworkspace, 7"
          "CTRL SHIFT, 8, movetoworkspace, 8"
          "CTRL SHIFT, 9, movetoworkspace, 9"
        ];
        bindm = [
          "SHIFT, mouse:272, movewindow"
          "SHIFT, mouse:273, resizewindow"
        ];

        bindl = [
          ", switch:on:Lid Switch, exec, hyprctl keyword monitor '${internal.device},disable'"
          ", switch:on:Lid Switch, exec, sudo ${pkgs.dock}/bin/dock"
          ", switch:off:Lid Switch, exec, hyprctl keyword monitor '${internal.config}'"
          ", switch:off:Lid Switch, exec, sudo ${pkgs.undock}/bin/undock"
        ];

        exec-once = [
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "clipse -listen"
          "hyprlock || hyprctl dispatch exit"
        ];

        input = {
          kb_layout = "us";
          repeat_rate = 150;
          repeat_delay = 200;
          follow_mouse = 1;
          sensitivity = 0;
        };

        general = {
          gaps_in = 10;
          gaps_out = 20;
          border_size = 2;
          "col.active_border" = "0xFFEBDBB2";
          "col.inactive_border" = "0xFF928373";
          layout = "dwindle";
          allow_tearing = false;
        };

        decoration = {
          rounding = 10;
          blur = {
            enabled = false;
          };
          drop_shadow = false;
        };

        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
          no_gaps_when_only = 1;
        };

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          background_color = "0x000000";
        };

        env = [
          "GDK_SCALE,1"
          "WLR_NO_HARDWARE_CURSORS,1"
          "QT_QPA_PLATFORM,wayland;xcb"
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_SESSION_DESKTOP,Hyprland"
          "GDL_BACKEND,wayland"
          "SDL_VIDEODRIVER,wayland"
        ];

        windowrulev2 = [
          "suppressevent maximize,class:steam"
          "suppressevent fullscreen,class:steam"
          "float,class:steam"
          "center,class:steam"
          "size 100% 100%,class:steam"
          "rounding 0,class:steam"
          "noborder,class:steam"

          "suppressevent maximize,class:^steam_app_\\d+$"
          "suppressevent fullscreen,class:^steam_app_\\d+$"
          "fullscreen,class:^steam_app_\\d+$"
          "rounding 0,class:^steam_app_\\d+$"
          "noborder,class:^steam_app_\\d+$"

          "suppressevent maximize,class:^(libreoffice.*)$"
          "suppressevent fullscreen,class:^(libreoffice.*)$"
        ];

        xwayland = {
          force_zero_scaling = true;
        };

        cursor = {
          hide_on_key_press = true;
          inactive_timeout = 1;
        };
      };
    };
  };
}
