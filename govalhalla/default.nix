{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;

let
  protobuf = pkgsStatic.protobuf;
  zlib = pkgsStatic.zlib;
  boost179 = pkgsStatic.boost179;
in

stdenv.mkDerivation {
  pname = "govalhalla";
  version = "0.0.1";
  src = ./.;

  nativeBuildInputs = [ swig ];
  buildInputs = [
    valhalla
    go
    protobuf
    zlib
    boost179
    stdenv.cc.cc.lib
  ];

  buildPhase = ''
    # SWIG generation
    ${swig}/bin/swig -c++ -v -go -cgo -intgosize 64 \
      -I${valhalla}/include \
      -I${swig}/share/swig/${swig.version} \
      -package govalhalla \
      -o govalhalla_wrap.cxx \
      valhalla.i
    # Compile object file
    echo "wrapping shared library cd src ....."
    $CXX -c govalhalla_wrap.cxx \
        -I. \
        -I${valhalla}/include \
        -I${valhalla}/include/valhalla/third_party  \
        -I${protobuf}/include \
        -I${go}/share/go/src/runtime/cgo \
        -I${boost179}/include \
        -I${zlib}/include \
        -std=c++17 

    ar rcs libvalhalla_go.a govalhalla_wrap.o
    ar x ${valhalla}/lib/libvalhalla.a
    ar r libvalhalla_go.a *.o
    ranlib libvalhalla_go.a
  '';

  installPhase = ''
    mkdir -p $out/{lib,govalhalla}
    cp libvalhalla_go.a $out/lib/
    cp -r *.go $out/govalhalla/
  '';
}
