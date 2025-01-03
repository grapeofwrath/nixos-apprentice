{pkgs, ...}: {
    imports = [
        ./modules/base
        ./modules/desktop
    ];
    home.packages = with pkgs; [
        brave
        gnome-keyring
    ];

    devUtils.enable = true;
}
