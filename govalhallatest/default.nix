{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;

let
  govalhalla = callPackage ../govalhalla { };
in

buildGoModule {
  name = "govalhallatest";
  src = ./.;
  vendorHash = "";

  CGO_ENABLED = "1";

  buildInputs = [ govalhalla ];

  preBuild = ''
    ln -s ${govalhalla} govalhalla
    export CGO_LDFLAGS="-L${govalhalla}/lib -lvalhalla_go"
  '';

  modRoot = ".";
}
