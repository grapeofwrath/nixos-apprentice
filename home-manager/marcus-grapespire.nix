{defaultUser, ...}: {
  imports = [
    ./modules/base
    ./modules/desktop
  ];
  home = {
    username = defaultUser;
  };

  devUtils.enable = true;
}
