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
    rev = "5c724a895b9ea2abac32f2e14247af2641a6a0b4";
    sha256 = "Bn7+OW4EWJdPOHVoE6qv8+VQzymcN0bXtzmTW6YWS3c=";
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
