{ lib
, fetchFromGitHub
, stdenv
, cmake
, libglvnd
, xorg
, libGLU
, gitBranch ? "master" # valid options are "master" or "develop"
}:

assert lib.asserts.assertOneOf "gitBranch" gitBranch [
  "master"
  "develop"
];

let
  gitBranchMaster = {
    commit = "b24861c5bb9ee6722ca143ecd61c17484ded1ee3";
    sha256 = "WLL08lBAsy5psBmLEuYwtjaOOya2hrrbq+pC2CP0xQc=";
  };
  gitBranchDevelop = {
    commit = "b24861c5bb9ee6722ca143ecd61c17484ded1ee3";
    sha256 = "WLL08lBAsy5psBmLEuYwtjaOOya2hrrbq+pC2CP0xQc=";
  };
  branch =
    if gitBranch == "master"
    then gitBranchMaster
    else if gitBranch == "develop"
    then gitBranchDevelop
    else abort "invalid branch";

in stdenv.mkDerivation rec {
  pname = "cgv-framework";
  version = "${branch.commit}";

  src = fetchFromGitHub {
    owner = "sgumhold";
    repo = "cgv";
    rev = "${version}";
    sha256 = "${branch.sha256}";
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
    libglvnd
    xorg.libX11
    xorg.libXi
    xorg.libXinerama
    libGLU
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
