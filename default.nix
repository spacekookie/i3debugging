{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
  test_server = pkgs.rustPlatform.buildRustPackage {
    name = "test-server";
    version = "1.0.0";
    src = ./.;
    cargoSha256 = "0gpwakfw89xbqgrh7zx2y0niax4050i89w1nj8r57bp7kr6v3b7l";
  };
in
pkgs.stdenv.mkDerivation {
    name = "i3debugger";
    src = ./.;
    installPhase = ''
      mkdir -p $out
      cp ${test_server}/bin/test-server $out/server
      cp debug.lua $out/debug.lua
      cp bisect.sh $out/bisect.sh
    '';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "0pd4z72qfqnv42c6imzhi4xip4dxb46xx26l449ydk9660jzansa";
  }
