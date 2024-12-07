{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./../modules/base
    ./../modules/desktop
    ./../modules/users
    ./../modules/gaming
    ./../modules/server
  ];

  virtualisation.libvirtd.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    virt-manager
    qemu
    qemu_kvm
    compose2nix
  ];

  # Personal Modules
  base = {
    battery.enable = true;
    latestKernel.enable = true;
    tailscaleAutoConnect = {
      enable = true;
      authkeyFile = config.sops.secrets.tailscale_key.path;
      loginServer = "https://login.tailscale.com";
    };
    appimage.enable = true;
  };

  desktop = {
    plasma.enable = false;
    tty-login.enable = false;
    gnome.enable = true;
  };

  gaming = {
    steam.enable = true;
  };

  server = {
    foundryvtt.enable = true;
    nextcloud.enable = true;
  };

  # Believe it or not, if you change this? Straight to jail.
  system.stateVersion = "24.11";
}
