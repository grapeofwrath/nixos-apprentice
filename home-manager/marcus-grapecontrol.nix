{...}: {
  imports = [
    ./modules/base
  ];
  # home.packages = with pkgs; [
  # ];

  # Personal modules
  base = {
    fish.enable = true;
  };
}
