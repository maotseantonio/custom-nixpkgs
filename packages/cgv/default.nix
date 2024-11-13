{ lib
, fetchFromGitHub
, stdenv
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
    commit = "6549a32bd04e7059ee244d81c102c5122df2cbd6";
    sha256 = "NbWBSoQvN56BlYympwxADfUkLEBAO0uGssUNzUFBv2k=";
  };
  branch =
    if gitBranch == "master"
    then gitBranchMaster
    else if gitBranch == "develop"
    then gitBranchDevelop
    else abort "invalid branch";

in stdenv.mkDerivation rec {
  pname = "cgv";
  version = "${branch.commit}";

  src = fetchFromGitHub {
    owner = "sgumhold";
    repo = "cgv";
    rev = "${version}";
    sha256 = "${branch.sha256}";
    fetchSubmodules = true;
  };

  propagatedBuildInputs = [
    libglvnd
    xorg.libX11
    xorg.libXi
    xorg.libXinerama
    libGLU
  ];

  patchPhase = ''
    substituteInPlace libs/plot/plot_base.cxx \
      --replace-fail "std::string font_name = cgv::media::font::default_font(false)->get_name();" \
                     "std::string font_name = cgv::media::font::default_font(true)->get_name();"

    substituteInPlace CMakeLists.txt \
      --replace-fail "add_subdirectory(doc)" ""
  '';

  installPhase = ''
    mkdir $out
    cp -r ./* $out/
  '';

  meta = with lib; {
    description = "The Computer Graphics and Visualization Framework";
    homepage = "https://sgumhold.github.io/cgv/index.html";
    platforms = platforms.x86_64;
  };
}
