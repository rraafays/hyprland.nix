{ pkgs, ... }:

let
  USER = "raf";
in
{
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "${USER}";
      };
      default_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "${USER}";
      };
    };
  };
}
