{
    config,
    lib,
    ...
}:
with lib; let
    cfg = config.ttyLogin;
in {
    options.ttyLogin = {
        enable = mkEnableOption "Enable TTY login";
    };
    config = mkIf cfg.enable {
        services = {
            # getty.autologinUser = gVar.username;
            xserver = {
                displayManager.startx.enable = true;
            };
        };
    };
}
