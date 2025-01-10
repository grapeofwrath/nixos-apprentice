{
  description = "Grapeofwrath's NixOS & Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";

    nvf.url = "github:notashelf/nvf";

    jot.url = "github:grapeofwrath/jot";
    phortune.url = "github:grapeofwrath/phortune";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
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

    stable = import nixpkgs-stable {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };

    gVimConfig = inputs.nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [./pkgs/neovim];
    };

    gLib = {
      scanPaths = path:
        map (f: (path + "/${f}"))
        (builtins.attrNames
          (nixpkgs.lib.attrsets.filterAttrs
            (
              path: _type:
                (_type == "directory")
                || (
                  (path != "default.nix") && (nixpkgs.lib.strings.hasSuffix ".nix" path)
                )
            ) (builtins.readDir path)));
      scanFiles = path:
        map (f: (path + "/${f}")) (builtins.attrNames (builtins.readDir path));
    };

    # vars
    defaultUser = "marcus";
    systems = [
      "grapecontrol"
      "grapelab"
      "grapespire"
      "grapestation"
    ];
    campfire = {
      base = "#14171F";
      surface = "#2A2F3C";
      overlay = "#323848";
      muted = "#3F475A";
      subtle = "#6D7A88";
      highlight = "#97A4AF";
      moon = "#DDD7CA";
      text = "#EFC164";
      ember = "#F3835D";
      dawn = "#F35955";
      dusk = "#A885C1";
      shore = "#3A8098";
      foam = "#70ADC2";
      evergreen = "#468966";
      fern = "#67CC8E";
    };
  in {
    formatter.${system} = pkgs.alejandra;

    packages.${system}.gVim = gVimConfig.neovim;

    nixosConfigurations = builtins.listToAttrs (map (hostName: {
        name = hostName;
        value = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs outputs system pkgs stable;
            inherit gLib gVimConfig defaultUser hostName campfire;
          };
          modules = [
            ./nixos/${hostName}/configuration.nix
          ];
        };
      })
      systems);

    homeConfigurations = builtins.listToAttrs (map (hostName: {
        name = "${defaultUser}-${hostName}";
        value = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs outputs system;
            inherit gLib defaultUser hostName campfire;
          };
          modules = [
            ./home-manager/${defaultUser}-${hostName}.nix
          ];
        };
      })
      systems);
  };
}
