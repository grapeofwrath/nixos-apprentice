{userName, ...}: {
  home = {
    username = userName;
    homeDirectory = "/home/${userName}";

    # sets a couple network settings to help with steam download speed
    file.".steam/steam/steam_dev.cfg".source = ./modules/files/steam_dev.cfg;

    # Believe it or not, if you change this? Straight to jail.
    stateVersion = "24.05";
  };

  systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;

    bash = {
      enable = true;
    };

    ssh = {
      enable = true;
      addKeysToAgent = "yes";
    };
    services.ssh-agent.enable = true;

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
