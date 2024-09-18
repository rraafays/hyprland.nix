{ pkgs, ... }:

let
  USER = "raf";
in
{
  home-manager.users.${USER}.home = {
    packages = with pkgs; [
      kitty
      grim
      slurp
      tofi
      playerctl
      clipse
      wl-clipboard
    ];
  };
}
