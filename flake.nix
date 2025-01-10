{
  description = "Grapeofwrath's NixOS & Home Manager configurations";

  inputs = {
    # switch these if you want to use stable (you probably don't, trust me bro)
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
      # overlays = [];
    };

    # vars
    hostName = "nixos";
    userName = "apprentice";
  in {
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations = {
      ${hostName} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs outputs pkgs hostName userName;
        };
        modules = [
          ./nixos/${hostName}/configuration.nix
        ];
      };
    };
  };
}
