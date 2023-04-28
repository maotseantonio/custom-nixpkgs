{ stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "rose-pine-icon-theme";
  version = "2.1.0";
  dontBuild = true;

  src = fetchFromGitHub {
    owner = "rose-pine";
    repo = "gtk";
    rev = "v${version}";
    sha256 = "MT8AeC+uGRZS4zFNvAqxqSLVYpd9h64RdSvr6Ky4HA4=";
  };

  installPhase = ''
    mkdir -p $out/share/icons
    cp -aR $src/icons/rose-pine-icons $out/share/icons/rose-pine
  '';
}
