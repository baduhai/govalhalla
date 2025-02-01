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
  vendorHash = "sha256-FLv7j8NcIZVBWzTv2BJ7MeVas7P3a5UfiRSAMr7jOyA=";

  CGO_ENABLED = "1";

  buildInputs = [ govalhalla ];

  preBuild = ''
    ln -s ${govalhalla} govalhalla
    export CGO_LDFLAGS="-L${govalhalla}/lib -lvalhalla_go"
  '';

  modRoot = ".";
}
