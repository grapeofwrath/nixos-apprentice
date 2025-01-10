{
  config,
  lib,
  inputs,
  outputs,
  pkgs,
  hostName,
  userName,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  time.timeZone = lib.mkDefault "America/Los_Angeles";

  # any apps that might be needed system-wide can be installed here
  environment.systemPackages = with pkgs; [
    inputs.home-manager.packages.${pkgs.system}.default
    xdotool
    xorg.xwininfo
    yad
    font-awesome
    polkit
    curl
    wget
    unzip
    kdePackages.discover
    # gaming specific
    steam-run
    protonup-qt
    wineWowPackages.unstableFull
  ];

  ##### users
  users = {
    mutableUsers = true;
    users = {
      # you can add additional users by copying the following section
      # note that you'll need to manually set the password
      ${userName} = {
        name = "${userName}";
        isNormalUser = true;
        home = "/home/${userName}";
        group = "users";
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
        # similar to systemPackages but for the user
        # KDE Discover is also a simple way to install apps
        # which is the recommended way for apps such as discord
        # packages = with pkgs; [];
      };
    };
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs outputs hostName userName;
    };
    users = {
      ${userName} = import ./../../../home-manager/${userName}-${hostName}.nix;
    };
  };

  ##### networking
  networking = {
    inherit hostName;
    networkmanager = {
      enable = true;
    };
    firewall = {
      enable = true;
    };
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
  };

  # AMD RADV driver
  hardware.graphics = {
    enable32Bit = true;
  };

  services.flatpak.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  ##### audio
  security.rtkit.enable = true;
  services = {
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };

  ##### desktop environment
  services = {
    desktopManager.plasma6.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        autoNumlock = true;
        wayland.enable = true;
      };
    };
  };
  programs.dconf.enable = true;
  services = {
    xserver = {
      enable = true;
      xkb.layout = lib.mkDefault "us";
    };
  };

  ##### battery
  services = {
    # set to true if your system has a battery
    system76-scheduler.settings.cfsProfiles.enable = false;
    # set to true if your system has a battery and an Intel CPU
    thermald.enable = false;
  };

  # set to true if your system has a battery
  powerManagement.powertop.enable = false;

  ##### nix settings
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
    etc =
      lib.mapAttrs' (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;
  };

  ##### boot loader
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
      };
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    # only necessary for OBS Studio
    kernelModules = ["v4l2loopback"];
    extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
  };

  # Believe it or not, if you change this? Straight to jail.
  system.stateVersion = "24.05";
}
