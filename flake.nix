{
    description = "Grapeofwrath's NixOS & Home Manager configurations";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
        nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-24.05";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        hardware.url = "github:nixos/nixos-hardware";
        sops-nix.url = "github:Mic92/sops-nix";

        nixvim = {
            url = "github:nix-community/nixvim";
            inputs.nixpkgs.follows = "nixpkgs";
        };

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

    gLib = import ./lib {inherit (nixpkgs) lib;};
    gVar = import ./var;
    in {
        formatter.${system} = pkgs.alejandra;

        # nixosModules = import ./modules/nixos;

        # homeManagerModules = import ./modules/home-manager;

        nixosConfigurations = {
            grapelab = let
                hostName = "grapelab";
            in
                nixpkgs.lib.nixosSystem {
                    inherit system;
                    specialArgs = {
                        inherit inputs outputs system pkgs stable gLib gVar hostName;
                    };
                    modules = [
                        ./nixos/grapelab/configuration.nix
                    ];
                };

            grapespire = let
                hostName = "grapespire";
            in
                nixpkgs.lib.nixosSystem {
                    inherit system;
                    specialArgs = {
                        inherit inputs outputs system pkgs stable gLib gVar hostName;
                    };
                    modules = [
                        ./nixos/grapespire/configuration.nix
                    ];
                };

            grapestation = let
                hostName = "grapestation";
            in
                nixpkgs.lib.nixosSystem {
                    inherit system;
                    specialArgs = {
                        inherit inputs outputs system pkgs stable gLib gVar hostName;
                    };
                    modules = [
                        ./nixos/grapestation/configuration.nix
                    ];
                };

            grapecontrol = let
                hostName = "grapecontrol";
            in
                nixpkgs.lib.nixosSystem {
                    inherit system;
                    specialArgs = {
                        inherit inputs outputs system pkgs stable gLib gVar hostName;
                    };
                    modules = [
                        ./nixos/grapecontrol/configuration.nix
                    ];
                };
        };

        homeConfigurations = {
            "marcus-grapelab" = let
                hostName = "grapelab";
            username = "marcus";
            in
                home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
                    extraSpecialArgs = {
                        inherit inputs outputs system gLib gVar hostName username;
                    };
                    modules = [
                        ./home-manager/marcus-grapelab.nix
                    ];
                };

            "marcus-grapespire" = let
                hostName = "grapespire";
            username = "marcus";
            in
                home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
                    extraSpecialArgs = {
                        inherit inputs outputs system gLib gVar hostName username;
                    };
                    modules = [
                        ./home-manager/marcus-grapespire.nix
                    ];
                };

            "marcus-grapestation" = let
                hostName = "grapestation";
            username = "marcus";
            in
                home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
                    extraSpecialArgs = {
                        inherit inputs outputs system gLib gVar hostName username;
                    };
                    modules = [
                        ./home-manager/marcus-grapestation.nix
                    ];
                };
        };
    };
}
