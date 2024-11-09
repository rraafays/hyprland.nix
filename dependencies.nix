{ pkgs, ... }:

let
  USER = "raf";
in
{
  home-manager.users.${USER}.home = {
    packages = with pkgs; [
      grim
      slurp
      tofi
      playerctl
      clipse
      wl-clipboard
    ];
  };
}
