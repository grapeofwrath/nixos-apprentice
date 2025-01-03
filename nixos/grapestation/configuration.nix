{
    config,
    pkgs,
    gVar,
    ...
}: {
    imports = [
        ./hardware-configuration.nix
        ./../modules/base
        ./../modules/users
    ];

    virtualisation.libvirtd.enable = true;

    environment.systemPackages = with pkgs; [
        vim
        curl
        wget
        virt-manager
        qemu
        qemu_kvm
        unzip
        xdotool
        xorg.xwininfo
        yad
        # gaming specific
        steam-run
        protonup-qt
        wineWowPackages.unstableFull
    ];

    users.users.${gVar.defaultUser} = {
        extraGroups = [
            "wheel"
            "networkmanager"
            "libvirtd"
            "input"
        ];
        packages = with pkgs; [
            brave
            discord
            spotify
            filezilla
            foliate
        ];
    };

    jovian = {
        decky-loader = {
            user = gVar.defaultUser;
            enable = true;
        };
        hardware = {
            has.amd.gpu = true;
            amd.gpu.enableBacklightControl = false;
        };
        steam = {
            updater.splash = "steamos";
            enable = true;
            autoStart = true;
            user = gVar.defaultUser;
            desktopSession = "plasma";
        };
        steamos = {
            useSteamOSConfig = true;
        };
    };

    # Personal Modules
    tailscaleAutoConnect = {
        enable = true;
        authkeyFile = config.sops.secrets.tailscale_key.path;
        loginServer = "https://login.tailscale.com";
    };

    # Believe it or not, if you change this? Straight to jail.
    system.stateVersion = "24.05";
}
