{config,pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./../modules/base
    ./../modules/desktop
    ./../modules/users
    ./../modules/server
  ];

  virtualisation.libvirtd.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    wget
    virt-manager
    qemu
    qemu_kvm
  ];

  # Personal Modules
  base = {
    appimage.enable = true;
    bluetooth.enable = true;
    latestKernel.enable = true;
    tailscaleAutoConnect = {
      enable = true;
      authkeyFile = config.sops.secrets.tailscale_key.path;
      loginServer = "https://login.tailscale.com";
      exitNode = "grapecontrol";
      exitNodeAllowLanAccess = true;
    };
  };

  desktop = {
      plasma = {
          enable = true;
          autoLogin = true;
      };
    tty-login.enable = false;
  };

  server = {
    foundryvtt.enable = true;
    hoarder.enable = true;
    nextcloud.enable = true;
  };

  # Believe it or not, if you change this? Straight to jail.
  system.stateVersion = "24.11";
}
