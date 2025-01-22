{
  description = "Simple in process language server";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }: let
    plugin-overlay = final: prev: {
      fake-nvim = (final.pkgs.vimUtils.buildVimPlugin {
        name = "fake.nvim";
        src = self;
      }).overrideAttrs {
        doCheck = false;
      };
    };

    supportedSystems = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  in
    flake-utils.lib.eachSystem supportedSystems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          plugin-overlay
        ];
      };
    in {
      packages = rec {
        default = fake-nvim;
        inherit (pkgs) fake-nvim;
      };
    })
    // {
      overlays.default = plugin-overlay;
    };
}
