{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = [
    pkgs.nodePackages.web-ext
    pkgs.go
  ];
}
