{pkgs, ...}: {
    imports = [
        ./modules/base
        ./modules/desktop
    ];
    home = {
        username = "marcus";
        packages = with pkgs; [
            blender
        ];
    };

    devUtils.enable = true;
}
