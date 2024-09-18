{ ... }:

let
  USER = "raf";
in
{
  security = {
    polkit.enable = true;
    pam.services.hyprlock = { };
  };

  home-manager.users.${USER} = {
    programs.hyprlock = {
      enable = true;
      settings = {
        background = {
          color = "rgb(0,0,0)";
        };
        label = [
          {
            text = ''cmd[update:1000] echo "<b><big> $(date +"%H") </big></b>"'';
            color = "rgb(235,219,178)";
            font_family = "Iosevka Term Curly";
            font_size = 112;
            position = "0, 200";
            halign = "center";
            valign = "center";
          }
          {
            text = ''cmd[update:1000] echo "<b><big> $(date +"%M") </big></b>"'';
            color = "rgb(235,219,178)";
            font_family = "Iosevka Term Curly";
            font_size = 112;
            position = "0, 76";
            halign = "center";
            valign = "center";
          }
          {
            text = ''cmd[update:18000000] echo "<b><big> "$(date +'%A')" </big></b>"'';
            color = "rgb(235,219,178)";
            font_family = "Iosevka Term Curly";
            font_size = 22;
            position = "0, 30";
            halign = "center";
            valign = "center";
          }
        ];
        input-field = {
          size = "300, 56";
          outline_thickness = 3;
          dots_size = 0.26;
          dots_spacing = 0.64;
          dots_center = true;
          dots_rounding = -1;
          outer_color = "rgb(0,0,0)";
          inner_color = "rgb(0,0,0)";
          font_color = "rgb(235,219,178)";
          font_family = "Iosevka Term Curly";
          fade_on_empty = false;
          rounding = 22;
          placeholder_text = ''<span foreground="##ebdbb2">Input Password...</span>'';
          hide_input = false;
          position = "0, -200";
          halign = "center";
          valign = "center";
          check_color = "rgb(254,128,25)";
          fail_color = "rgb(251,72,51)";
          fail_text = "<i>Sorry, try again.</i>";
        };
      };
    };
  };
}
