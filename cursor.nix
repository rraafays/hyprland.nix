{ pkgs, ... }:

let
  USER = "raf";

  cursor_size = 24;
in
{
  environment = {
    variables = {
      XCURSOR_SIZE = cursor_size;
      GTK_CURSOR_SIZE = cursor_size;
    };
  };

  home-manager.users.${USER} = {
    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          cursor-size = cursor_size;
        };
      };
    };

    home = {
      pointerCursor =
        let
          getFrom = url: hash: name: {
            gtk.enable = true;
            x11.enable = true;
            name = name;
            size = cursor_size;
            package = pkgs.runCommand "moveUp" { } ''
              mkdir -p $out/share/icons
              ln -s ${
                pkgs.fetchzip {
                  url = url;
                  hash = hash;
                }
              } $out/share/icons/${name}
            '';
          };
        in
        getFrom "https://github.com/ful1e5/fuchsia-cursor/releases/download/v2.0.0/Fuchsia-Pop.tar.gz"
          "sha256-BvVE9qupMjw7JRqFUj1J0a4ys6kc9fOLBPx2bGaapTk="
          "Fuchsia-Pop";
    };
  };
}
