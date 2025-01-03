{
    pkgs,
    gLib,
    ...
}: {
    imports = gLib.scanPaths ./.;
    home = {
        file = {
            ".config/phortune/phortunes".source = ./../../../assets/phortunes;
            "Pictures/wallpaper.png".source = ./../../../assets/wallpaper.png;
            "Pictures/profile.png".source = ./../../../assets/profile.png;
            "Pictures/lockscreen.png".source = ./../../../assets/lockscreen.png;
        };
        packages = with pkgs; [
            nautilus
        ];
    };

}
