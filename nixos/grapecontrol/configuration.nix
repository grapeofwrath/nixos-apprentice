{
    config,
    inputs,
    lib,
    ...
}: {
    imports = [
        ./hardware-configuration.nix
        ./../modules/base/sops.nix
        ./../modules/base/tailscale.nix
        ./../modules/base/latestKernel.nix
    ];

    boot.tmp.cleanOnBoot = true;
    zramSwap.enable = true;
    networking.hostName = "grapecontrol";
    networking.domain = "";
    users = {
        mutableUsers = true;
        users = {
            marcus = {
                isNormalUser = true;
                home = "/home/marcus";
                group = "users";
                extraGroups = ["wheel" "networkmanager"];
                openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJX1z3VLktainIni2wvMoNvdWPMVaIDifd0S0KnVXKom marcus@grapespire'' ];
            };
        };
    };
    system.stateVersion = "23.11";

    nix = {
        registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);
        nixPath = ["/etc/nix/path"];
        settings = {
            experimental-features = "nix-command flakes";
            auto-optimise-store = true;
            warn-dirty = false;
        };
        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
        };
    };

    environment = {
        etc = lib.mapAttrs' (name: value: {
            name = "nix/path/${name}";
            value.source = value.flake;
        })
        config.nix.registry;
        variables = {
            EDITOR = "nvim";
        };
    };

    i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

    time.timeZone = lib.mkDefault "America/Los_Angeles";

    programs = {
        fish.enable = true;
    };

    services = {
        caddy = {
            enable = true;
            virtualHosts."hoarder.adventurerstome.com".extraConfig = ''
                reverse_proxy http://grapelab:3000
            '';
        };
        fail2ban.enable = true;
        openssh.enable = true;
    };

    base = {
        latestKernel.enable = true;
        tailscaleAutoConnect = {
            enable = true;
            authkeyFile = config.sops.secrets.tailscale_key.path;
            loginServer = "https://login.tailscale.com";
            advertiseExitNode = true;
        };
    };

  # auto-generated for DigitalOcean
  networking = {
      firewall = {
          enable = true;
          allowedTCPPorts = [ 80 443 22 ];
      };
    nameservers = [ "8.8.8.8"
    ];
    defaultGateway = "161.35.224.1";
    defaultGateway6 = {
      address = "";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
            { address="161.35.226.80"; prefixLength=20; }
            { address="10.48.0.5"; prefixLength=16; }
        ];
        ipv6.addresses = [
          { address="fe80::246b:50ff:fe33:fb6"; prefixLength=64; }
        ];
        ipv4.routes = [ { address = "161.35.224.1"; prefixLength = 32; } ];
        ipv6.routes = [ { address = ""; prefixLength = 128; } ];
      };
            eth1 = {
        ipv4.addresses = [
          { address="10.124.0.2"; prefixLength=20; }
        ];
        ipv6.addresses = [
          { address="fe80::40ea:bfff:fe65:58cb"; prefixLength=64; }
        ];
        };
    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="26:6b:50:33:0f:b6", NAME="eth0"
    ATTR{address}=="42:ea:bf:65:58:cb", NAME="eth1"
  '';

}
