{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.orion.dev;
in {
  options.orion.dev = {
    enable = lib.mkEnableOption "Enable dev utilities";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # common
      gnumake
      tailwindcss
      # go
      go
      gopls
      gotools
      golangci-lint
      air
      templ
    ];
  };
}
