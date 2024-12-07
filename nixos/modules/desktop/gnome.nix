{
  config,
  pkgs,
  lib,
  ...
}: with lib; let
  cfg = config.desktop.gnome;
in {
  options.desktop.gnome = {
    enable = mkEnableOption "gnome";
    autoLogin = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gnome-tweaks
    ];
    services.xserver = {
      desktopManager.gnome.enable = true;
      displayManager = {
        gdm = {
          enable = true;
        };
      };
    };
  };
}
