{ lib
, fetchFromGitHub
, stdenv
, cmake
, libglvnd
, xorg
, libGLU
}:

stdenv.mkDerivation rec {
  pname = "cgv-framework";
  version = "b24861c5bb9ee6722ca143ecd61c17484ded1ee3";

  src = fetchFromGitHub {
    owner = "sgumhold";
    repo = "cgv";
    rev = "${version}";
    sha256 = "WLL08lBAsy5psBmLEuYwtjaOOya2hrrbq+pC2CP0xQc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libglvnd
    xorg.libX11
    xorg.libXi
    xorg.libXinerama
    libGLU
  ];

  propagatedBuildInputs = [
    # xorg.libXi
    # xorg.libXinerama
  ];

  installPhase = ''
    mkdir $out
    cd ..
    cp -r ./* $out/
  '';

  meta = with lib; {
    description = "The Computer Graphics and Visualization Framework";
    homepage = "https://sgumhold.github.io/cgv/index.html";
    platforms = platforms.x86_64;
  };
}
