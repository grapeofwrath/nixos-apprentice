{
  config,
  lib,
  campfire,
  ...
}: let
  cfg = config.terminal;
in {
  options.terminal = with lib; {
    fontSize = mkOption {
      type = types.int;
      default = 12;
    };
  };

  config = {
    programs = {
      ghostty = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        installVimSyntax = true;
        settings = {
          font-size = cfg.fontSize;
          theme = "campfire";
          window-padding-x = 2;
          window-padding-y = 2;
          window-padding-balance = true;
        };
        themes = {
          campfire = let
            c = campfire;
          in {
            background = c.base;
            cursor-color = c.text;
            foreground = c.text;
            selection-background = c.text;
            selection-foreground = c.base;
            palette = [
              "0=${c.base}"
              "1=${c.dusk}"
              "2=${c.evergreen}"
              "3=${c.ember}"
              "4=${c.foam}"
              "5=${c.fern}"
              "6=${c.shore}"
              "7=${c.text}"
              "8=${c.subtle}"
              "9=${c.dusk}"
              "10=${c.evergreen}"
              "11=${c.ember}"
              "12=${c.foam}"
              "13=${c.fern}"
              "14=${c.shore}"
              "15=${c.moon}"
            ];
          };
        };
      };
    };
  };
}
