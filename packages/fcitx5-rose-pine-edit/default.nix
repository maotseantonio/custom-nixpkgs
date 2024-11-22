{ stdenvNoCC
, fetchFromGitHub
, lib
}:

stdenvNoCC.mkDerivation {
  pname = "fcitx5-rose-pine-edit";
  version = "0-unstable-2024-11-22";

  src = fetchFromGitHub {
    owner = "lwndhrst";
    repo = "fcitx5-rose-pine-edit";
    rev = "c28b78e49946ea011c803d636b4d81cc7075985b";
    sha256 = "qWmZKgwN7py7nn7vAAZps9+qiqNU+k6JClu5ScskJWc=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -pv $out/share/fcitx5/themes/
    cp -rv rose-pine* $out/share/fcitx5/themes/

    runHook postInstall
  '';


  meta = {
    description = "Fcitx5 themes based on Rosé Pine";
    homepage = "https://github.com/lwndhrst/fcitx5-rose-pine-edit";
    platforms = lib.platforms.all;
  };
}
