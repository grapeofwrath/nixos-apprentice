{
    config,
    lib,
    gVar,
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
                };
                themes = {
                    campfire = {
                        background = gVar.palette.base00;
                        cursor-color = gVar.palette.base07;
                        foreground = gVar.palette.base05;
                        selection-background = gVar.palette.base05;
                        selection-foreground = gVar.palette.base00;
                        palette = [
                            "0=#${gVar.palette.base00}"
                            "1=#${gVar.palette.base08}"
                            "2=#${gVar.palette.base0B}"
                            "3=#${gVar.palette.base0A}"
                            "4=#${gVar.palette.base0D}"
                            "5=#${gVar.palette.base0E}"
                            "6=#${gVar.palette.base0C}"
                            "7=#${gVar.palette.base05}"
                            "8=#${gVar.palette.base03}"
                            "9=#${gVar.palette.base08}"
                            "10=#${gVar.palette.base0B}"
                            "11=#${gVar.palette.base0A}"
                            "12=#${gVar.palette.base0D}"
                            "13=#${gVar.palette.base0E}"
                            "14=#${gVar.palette.base0C}"
                            "15=#${gVar.palette.base07}"
                        ];
                    };
                };
            };

            kitty = {
                enable = true;
                font = {
                    name = "CaskaydiaCove Nerd Font";
                    size = cfg.fontSize;
                };
                settings = {
                    scrollback_lines = 2000;
                    wheel_scroll_min_lines = 1;
                    window_padding_width = 9;
                    confirm_os_window_close = 0;
                    background = "#${gVar.palette.base00}";
                    foreground = "#${gVar.palette.base05}";
                    selection_background = "none";
                    selection_foreground = "none";
                    color0 = "#${gVar.palette.base00}";
                    color1 = "#${gVar.palette.base08}";
                    color2 = "#${gVar.palette.base0B}";
                    color3 = "#${gVar.palette.base0A}";
                    color4 = "#${gVar.palette.base0D}";
                    color5 = "#${gVar.palette.base0E}";
                    color6 = "#${gVar.palette.base0C}";
                    color7 = "#${gVar.palette.base05}";
                    color8 = "#${gVar.palette.base03}";
                    color9 = "#${gVar.palette.base08}";
                    color10 = "#${gVar.palette.base0B}";
                    color11 = "#${gVar.palette.base0A}";
                    color12 = "#${gVar.palette.base0D}";
                    color13 = "#${gVar.palette.base0E}";
                    color14 = "#${gVar.palette.base0C}";
                    color15 = "#${gVar.palette.base07}";
                };
            };
        };
    };
}
