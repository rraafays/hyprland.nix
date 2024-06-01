{ pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in
{
  imports = [ "${home-manager}/nixos" ];

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  fonts.packages = with pkgs; [
    (iosevka-bin.override { variant = "sgr-iosevka-term-curly"; })
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    sarasa-gothic
    sarabun-font
    noto-fonts-emoji
  ];

  security.polkit.enable = true;
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  home-manager.users.raf = {
    home.enableNixpkgsReleaseCheck = false;
    dconf.enable = true;
    xdg.desktopEntries.Steam = {
      name = "Steam (Big Picture)";
      exec = "gamescope --adaptive-sync -r 175 -W 3440 -H 1440 -f -e -- steam steam://open/bigpicture";
    };
    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      xwayland.enable = true;
      systemd.enable = true;
      settings = {
        monitor = ",highrr,auto,1,vrr,0";
        bind = [
          "CTRL ALT, DELETE, exec, shutdown now"
          "CTRL ALT, RETURN, exec, beep;beep;beep; reboot"

          "CTRL, q, killactive"
          "CTRL, RETURN, exec, kitty"
          "CTRL, SPACE, exec, rofi -show drun -display-drun \"\""

          "CTRL, code:34, movefocus, u"
          "CTRL, code:48, movefocus, r"
          "CTRL, code:61, movefocus, d"
          "CTRL, code:47, movefocus, l"

          "CTRL SHIFT, code:34, swapwindow, u"
          "CTRL SHIFT, code:48, swapwindow, r"
          "CTRL SHIFT, code:61, swapwindow, d"
          "CTRL SHIFT, code:47, swapwindow, l"

          "CTRL ALT, code:34, resizeactive, 0 -10"
          "CTRL ALT, code:48, resizeactive, 10 0"
          "CTRL ALT, code:61, resizeactive, 0 10"
          "CTRL ALT, code:47, resizeactive, -10 0"

          ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          "CTRL, p, exec, playerctl play-pause"

          "CTRL, 1, workspace, 1"
          "CTRL, 2, workspace, 2"
          "CTRL, 3, workspace, 3"
          "CTRL, 4, workspace, 4"
          "CTRL, 5, workspace, 5"
          "CTRL, 6, workspace, 6"
          "CTRL, 7, workspace, 7"
          "CTRL, 8, workspace, 8"
          "CTRL, 9, workspace, 9"

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

        exec = [
          "pactl set-sink-volume @DEFAULT_SINK@ 100%"
          "wpctl set-volume @DEFAULT_SINK@ 100%"
          "mouseless"
        ];

        exec-once = [
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
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
          cursor_inactive_timeout = 1;
          no_cursor_warps = 0;
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
          "XCURSOR_SIZE,24"
          "GDK_SCALE,1"
          "WLR_NO_HARDWARE_CURSORS,1"
          "GDK_BACKEND,wayland,x11"
          "QT_QPA_PLATFORM,wayland;xcb"
          "SDL_VIDEODRIVER,wayland"
          "CLUTTER_BACKEND,wayland"
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_SESSION_DESKTOP,Hyprland"
          "BROWSER,firefox"
          "MOZ_ENABLE_WAYLAND,1"
        ];
      };
    };
  };
}
