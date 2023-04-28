{ lib
, pkgs
, fetchFromGitHub
, stdenvNoCC
}:

let
  packages = import ../../packages { inherit pkgs; };

in stdenvNoCC.mkDerivation rec {
  pname = "ols";
  version = "nightly";
  dontConfigure = true;

  src = fetchFromGitHub {
    owner = "DanielGavin";
    repo = "ols";
    rev = "${version}";
    sha256 = "XeJWW3ro2hTp6VPMaW3RUzNujc2WXLy/ob/0hAsNKc0=";
  };

  buildInputs = [ packages.odin ];

  postPatch = ''
    patchShebangs build.sh
  '';

  buildPhase = ''
    ./build.sh
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ols $out/bin
  '';

  meta = with lib; {
    description = "Language server for Odin";
    homepage = "https://github.com/DanielGavin/ols";
    license = licenses.mit;
    platforms = platforms.x86_64;
  };
}
