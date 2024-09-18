{ pkgs, ... }:

let
  USER = "raf";
in
{
  home-manager.users.${USER} = {
    home.packages = [ pkgs.nur.repos.wolfangaukang.mouseless ];
    systemd.user.services.mouseless = {
      Unit = {
        Description = "mouseless";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.writeShellScript "mouseless" ''
          #!/run/current-system/sw/bin/bash
          ${pkgs.nur.repos.wolfangaukang.mouseless}/bin/mouseless --config ~/.config/mouseless/config.yaml
        ''}";
      };
    };
  };
}
