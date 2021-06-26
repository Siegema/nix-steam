{
  description = "Nix-Steam, a nix system for steam games";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/1f91fd1040667e9265a760b0347f8bc416249da7";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
  let
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
  in {
    helperLib = pkgs.callPackage ./lib/top-level.nix {};
    makeSteamStore = steamUserInfo: pkgs.callPackage ./games/top-level.nix {
      inherit steamUserInfo;
      helperLib = self.helperLib."${system}";
    };

    devShell =
      pkgs.mkShell { 
        NIX_PATH = "nixpkgs=${nixpkgs}";
        DOCKER_HOST = "unix:///var/run/podman/podman.sock";
        buildInputs = [ 
          pkgs.arion
          pkgs.nixfmt
          pkgs.ripgrep
        ];
      };
    });
  }
