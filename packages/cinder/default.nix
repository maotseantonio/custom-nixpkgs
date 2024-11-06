{ lib
, fetchFromGitHub
, libcxxStdenv
, cmake
, pkg-config
, curl
, fontconfig
, expat
, libglvnd
, libmpg123
, libpulseaudio
, xorg
, zlib
, libsndfile
, boost
, glib
, gst_all_1
}:

libcxxStdenv.mkDerivation rec {
  pname = "cinder";
  version = "174c86b07eed185dca66a5b4918d3545d1c3284f";

  src = fetchFromGitHub {
    owner = "cinder";
    repo = "Cinder";
    rev = "${version}";
    sha256 = "pFu1oKgNo6Mc4UUCn3+gWoq5j6ZywI/GgqppRC7Lmf8=";
    fetchSubmodules = true;
  };

  buildInputs = [
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    curl.dev
    fontconfig.dev
    expat.dev
    libglvnd
    libmpg123
    libmpg123.dev
    libpulseaudio
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    zlib
    libsndfile
    boost
    glib
    gst_all_1.gstreamermm
  ];

  prePatch = ''
    # libmpg123
    export MPG123_INCLUDE_DIR=$(pkg-config --variable=includedir ${libmpg123.dev}/lib/pkgconfig/libmpg123.pc)
    export MPG123_LIBRARY_DIR=$(pkg-config --variable=libdir ${libmpg123.dev}/lib/pkgconfig/libmpg123.pc)

    # libsndfile
    export SNDFILE_INCLUDE_DIR=$(pkg-config --variable=includedir ${libsndfile.dev}/lib/pkgconfig/sndfile.pc)
    export SNDFILE_LIBRARY_DIR=$(pkg-config --variable=libdir ${libsndfile.dev}/lib/pkgconfig/sndfile.pc)
  '';

  postPatch = ''
    # libmpg123
    substituteInPlace proj/cmake/modules/FindMPG123.cmake \
      --replace-fail "set( MPG123_INCLUDE_DIRS" "set( MPG123_INCLUDE_DIRS $MPG123_INCLUDE_DIR"
    substituteInPlace proj/cmake/modules/FindMPG123.cmake \
      --replace-fail "set( MPG123_LIBRARY_DIRS" "set( MPG123_LIBRARY_DIRS $MPG123_LIBRARY_DIR"

    # libsndfile
    substituteInPlace proj/cmake/modules/FindSNDFILE.cmake \
      --replace-fail "set( SNDFILE_INCLUDE_DIRS" "set( SNDFILE_INCLUDE_DIRS $SNDFILE_INCLUDE_DIR"
    substituteInPlace proj/cmake/modules/FindSNDFILE.cmake \
      --replace-fail "set( SNDFILE_LIBRARY_DIRS" "set( SNDFILE_LIBRARY_DIRS $SNDFILE_LIBRARY_DIR"
  '';

  installPhase = ''
    mkdir $out
    cd ..
    cp -r ./* $out/

    substituteInPlace $out/lib/linux/x86_64/ogl/Release/cinderConfig.cmake \
      --replace-fail "/build/source" "$out"

    substituteInPlace $out/build/lib/linux/x86_64/ogl/Release/cinderTargets.cmake \
      --replace-fail "/build/source" "$out"
  '';

  meta = with lib; {
    description = "Cinder is a community-developed, free and open source library for professional-quality creative coding in C++.";
    homepage = "http://libcinder.org/";
    platforms = platforms.x86_64;
  };
}
