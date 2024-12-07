{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.server.foundryvtt;
in {
  options.server.foundryvtt = {
    enable = lib.mkEnableOption "Enable Foundryvtt";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ nodejs ];
    systemd.user.services.foundryvtt = {
      description = "Foundry VTT";
      # requires = ["network.target"];
      # after = ["network.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "simple";
        # Restart = "always";
        # RestartSec = 1;
        ExecStart = "${pkgs.nodejs} ~/srv/foundry/foundryvtt/resources/app/main.js --dataPath=~/srv/foundrydata";
      };
    };
  };
}
