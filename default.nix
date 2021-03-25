{ pkgs ? import <nixpkgs> { } }:

let

  inherit (pkgs) stdenv lib go;

in stdenv.mkDerivation {
  pname = "eink-firefox";
  version = "0.1";
  src = lib.cleanSource ./.;

  nativeBuildInputs = [ go ];

  buildPhase = ''
    runHook preBuild
    env HOME=$(mktemp -d) go build
    runHook postBuild
  '';

  installPhase = ''
    runHook preBuild
    mkdir -p $out/bin
    install -m 755 einkmode-firefox $out/bin

    mkdir -p $out/lib/mozilla/native-messaging-hosts
    sed s!'@execpath@'!$out/bin/einkmode-firefox! com.bladis.einkmode.native.json > $out/lib/mozilla/native-messaging-hosts/com.bladis.einkmode.native.json

    runHook postBuild
  '';

}
