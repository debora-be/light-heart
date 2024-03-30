{
  description = "A basic flake to run an Gleam Project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (pkgs.lib) optional optionals;
        pkgs = import nixpkgs { inherit system; };

        inputs = with pkgs;
          [ gleam glibcLocales ]
          ++ optional stdenv.isLinux [ inotify-tools ]
          ++ optional stdenv.isDarwin terminal-notifier
          ++ optionals stdenv.isDarwin
          (with darwin.apple_sdk.frameworks; [ CoreFoundation CoreServices ]);
      in with pkgs; {
        devShells.default = mkShell {
          name = "Light Heart";
          packages = inputs;
        };
      });
}
