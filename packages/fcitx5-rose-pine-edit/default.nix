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
    rev = "32b9952a5d8ea395e4e0b3e31ecb10193041e080";
    sha256 = "yyK3h/qenLWl3LK22E+OS/beqKaW0WnTXqZR0u/chgg=";
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
