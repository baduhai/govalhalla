{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;

stdenv.mkDerivation (finalAttrs: {
  pname = "valhalla";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "valhalla";
    repo = "valhalla";
    rev = finalAttrs.version;
    hash = "sha256-v/EwoJA1j8PuF9jOsmxQL6i+MT0rXbyLUE4HvBHUWDo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    pkgsStatic.boost179
    pkgsStatic.geos
    pkgsStatic.protobuf
    pkgsStatic.zlib
    pkgsStatic.lz4
  ];

  cmakeFlags = [
    "-DENABLE_TESTS=OFF"
    "-DENABLE_BENCHMARKS=OFF"
    "-DENABLE_CCACHE=OFF"
    "-DENABLE_SINGLE_FILES_WERROR=OFF"
    "-DCMAKE_C_COMPILER=gcc"
    "-DBUILD_SHARED_LIBS=OFF"
    "-DENABLE_PYTHON_BINDINGS=OFF"
    "-DENABLE_TOOLS=OFF"
    "-DENABLE_SERVICES=OFF"
    "-DENABLE_HTTP=OFF"
    "-DENABLE_CCACHE=OFF"
    "-DENABLE_DATA_TOOLS=OFF"
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed for date submodule with GCC 12 https://github.com/HowardHinnant/date/issues/750
    "-Wno-error=stringop-overflow"
  ];

  postFixup = ''
    substituteInPlace "$out"/lib/pkgconfig/libvalhalla.pc \
      --replace '=''${prefix}//' '=/' \
      --replace '=''${exec_prefix}//' '=/'
  '';

  passthru.tests = {
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  postInstall = ''
    cp -r $out/include/valhalla/third_party/* $out/include/
  '';

  meta = with lib; {
    changelog = "https://github.com/valhalla/valhalla/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Open Source Routing Engine for OpenStreetMap";
    homepage = "https://valhalla.readthedocs.io/";
    license = licenses.mit;
    maintainers = [ maintainers.Thra11 ];
    platforms = platforms.linux;
  };
})
