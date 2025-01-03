{
    config,
    pkgs,
    gVar,
    ...
}: {
    imports = [
        ./hardware-configuration.nix
        ./../modules/base
        ./../modules/desktop
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
        kdePackages.discover
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
            spotify
            filezilla
            foliate
        ];
    };

    programs = {
        steam = {
            enable = true;
            remotePlay.openFirewall = true;
        };
    };

    hardware.graphics = {
        enable32Bit = true;
        # extraPackages = [ pkgs.amdvlk ];
        # extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
    };

    services.flatpak.enable = true;

# Personal Modules
    plasma = {
        enable = true;
        autoLogin = true;
    };

    tailscaleAutoConnect = {
        enable = true;
        authkeyFile = config.sops.secrets.tailscale_key.path;
        loginServer = "https://login.tailscale.com";
    };

# Believe it or not, if you change this? Straight to jail.
    system.stateVersion = "24.05";
}
