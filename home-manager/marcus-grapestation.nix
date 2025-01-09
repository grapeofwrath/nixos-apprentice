{gVar, ...}: {
  imports = [
    ./modules/base
    ./modules/desktop
  ];
  home = {
    username = gVar.defaultUser;
    file.".steam/steam/steam_dev.cfg".source = ./modules/config/steam_dev.cfg;
  };
}
