{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, pantheon
, breeze-icons
, gnome-icon-theme
, hicolor-icon-theme
, papirus-folders
, librsvg
, color ? null 
}:

let
  steam-tray-icon = "share/icons/Papirus/16x16/panel/steam_tray_mono.svg";

in stdenvNoCC.mkDerivation rec {
  pname = "papirus-icon-theme";
  version = "20230301";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = pname;
    rev = version;
    sha256 = "iIvynt8Qg9PmR2q7JsLtRlYxfHGaShMD8kbbPL89DzE=";
  };

  nativeBuildInputs = [ 
    gtk3 
    papirus-folders
    librsvg
  ];

  propagatedBuildInputs = [
    pantheon.elementary-icon-theme
    breeze-icons
    gnome-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    mv {,e}Papirus* $out/share/icons

    # convert steam tray icon to png cuz smth seems to be broken otherwise
    rsvg-convert -w 14 -h 14 $out/${steam-tray-icon} > $out/share/icons/Papirus/16x16/panel/steam_tray_mono.png

    for theme in $out/share/icons/*; do
      ${lib.optionalString (color != null) "${papirus-folders}/bin/papirus-folders -t $theme -o -C ${color}"}
      gtk-update-icon-cache --force $theme
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Papirus icon theme";
    homepage = "https://github.com/PapirusDevelopmentTeam/papirus-icon-theme";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo fortuneteller2k ];
  };
}
