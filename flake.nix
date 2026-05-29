{
  description = "BlankOS Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    homeConfigurations = {

      # 🪶 Minimal
      "blank-minimal" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./profiles/minimal.nix ];
      };

      # 💻 Dev
      "blank-dev" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./profiles/dev.nix ];
      };

      # 🧠 ML
      "blank-ml" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./profiles/ml.nix ];
      };

      # 🌕 Full
      "blank-full" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./profiles/full.nix ];
      };

    };
  };
}
