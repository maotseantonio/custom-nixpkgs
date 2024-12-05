{ lib
, fetchFromGitHub
, stdenv
, libglvnd
, xorg
, libGLU
, gitCommit ? "master" # valid options are "master", "develop" or "font-fix"
}:

assert lib.asserts.assertOneOf "gitBranch" gitCommit [
  "master"
  "develop"
  "font-fix"
];

let
  gitCommitMaster = {
    commit = "b24861c5bb9ee6722ca143ecd61c17484ded1ee3";
    sha256 = "WLL08lBAsy5psBmLEuYwtjaOOya2hrrbq+pC2CP0xQc=";
  };
  gitCommitDevelop = {
    commit = "6549a32bd04e7059ee244d81c102c5122df2cbd6";
    sha256 = "NbWBSoQvN56BlYympwxADfUkLEBAO0uGssUNzUFBv2k=";
  };
  gitCommitFontFix = {
    commit = "137577dbc0177a8d1ad20b8109c0ee9b94f0dbb7";
    sha256 = "ZF0cs7YopR9oOXpl4e2xuKno6OV5OW09HwXuaHdGolo=";
  };
  commit =
    if gitCommit == "master"
    then gitCommitMaster
    else if gitCommit == "develop"
    then gitCommitDevelop
    else if gitCommit == "font-fix"
    then gitCommitFontFix
    else abort "invalid branch";

in stdenv.mkDerivation rec {
  pname = "cgv";
  version = "${commit.commit}";
  dontConfigure = true;
  dontBuild = true;

  src = fetchFromGitHub {
    owner = "sgumhold";
    repo = "cgv";
    rev = "${version}";
    sha256 = "${commit.sha256}";
    fetchSubmodules = true;
  };

  propagatedBuildInputs = [
    libglvnd
    xorg.libX11
    xorg.libXi
    xorg.libXinerama
    libGLU
  ];

  patchPhase = if commit != gitCommitFontFix then ''
    substituteInPlace libs/plot/plot_base.cxx \
      --replace-fail "std::string font_name = cgv::media::font::default_font(false)->get_name();" \
                     "std::string font_name = cgv::media::font::default_font(true)->get_name();"

    substituteInPlace CMakeLists.txt \
      --replace-fail "add_subdirectory(doc)" ""
  '' else "";

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
