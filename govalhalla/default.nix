{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;

let
  valhalla = (import ./valhalla) { };
  protobuf = pkgsStatic.protobuf;
  zlib = pkgsStatic.zlib;
  boost179 = pkgsStatic.boost179;
in

stdenv.mkDerivation {
  pname = "govalhalla"; # "govalhalla-${valhallaCustom.rev}";
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

  # preBuildPhase = ''
  #   export PKG_CONFIG_PATH=${pkgs.valhalla}/lib/pkgconfig:$PKG_CONFIG_PATH
  # '';

  buildPhase = ''


      # Debug: Show current directory and contents
      echo "Current directory: $PWD"
      echo "Parent directory contents:"
      echo "GOPATH: $GOPATH"
      # echo "Go version: $(go version)"
      export GOPATH=$PWD/go
      ls -l ${valhalla}/lib
      # ls -l ${valhalla}/include/valhalla/third_party/
      

      # Generate SWIG bindings
      echo "Generating SWIG bindings: ${swig}/share/swig/${swig.version}"
      echo "Compiler : $CXX"
      

    ${swig}/bin/swig -c++ -v -go -cgo -intgosize 64 \
      -I${valhalla}/include \
      -I${swig}/share/swig/${swig.version} \
      -package govalhalla \
      -use-shlib \
      -o govalhalla_wrap.cxx \
      valhalla.i
      
      

      # Compile shared library
      echo "wrapping shared library cd src ....."
      

      $CXX -fPIC -c govalhalla_wrap.cxx \
        -I. \
        -I${valhalla}/include \
        -I${valhalla}/include/valhalla/third_party  \
        -I${protobuf}/include \
        -I${go}/share/go/src/runtime/cgo \
        -I${boost179}/include \
        -I${zlib}/include \
        -std=c++17 

      echo "Compiling shared library cd src ....."

      ls -l

      $CXX -shared govalhalla_wrap.o \
        -o libvalhalla_go.so \
        -Wl,--whole-archive -L${valhalla}/lib -lvalhalla -Wl,--no-whole-archive \
        -L${protobuf}/lib \
        -L${boost179}/lib \
        -std=c++17 \
        -Wl,-Bdynamic -lpthread -lz -lprotobuf -lboost_system -lboost_filesystem\
        -Wl,--verbose
  '';

  installPhase = ''
    mkdir -p $out/{lib,govalhalla}
    cp libvalhalla_go.so $out/lib/
    cp -r *.go $out/govalhalla/
    # cp -r ${valhalla}/include/proto/*.go $out/valhalla/
  '';

  # postFixup = ''
  #   patchelf --set-rpath "${lib.makeLibraryPath [protobuf boost179 valhalla zlib]}:$out/lib" $out/lib/libvalhalla_go.so
  # '';

}
