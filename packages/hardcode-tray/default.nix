{ fetchFromGitHub
, gobject-introspection
, gtk3
, meson
, ninja
, pkg-config
, python3
, stdenvNoCC
, wrapGAppsHook
}:

let
  pname = "hardcode-tray";

  # None of this is working and i have no clue why at this point
  steam-data = ''
    {
      \"name\": \"Steam\",
      \"app_path\": [
        \"{userhome}/.steam/\"
      ],
      \"icons_path\": [
        \"/run/current-system/sw/share/pixmaps/\"
      ],
      \"icons\": {
        \"indicator\": {
          \"original\": \"steam_tray_mono.png\",
          \"theme\": \"steam_tray_mono\"
        }
      }
    }
  '';

in stdenvNoCC.mkDerivation rec {
  inherit pname;
  version = "4.3";
  dontUseCmakeConfigure = true;

  src = fetchFromGitHub {
    owner = "bilelmoussaoui";
    repo = pname;
    rev = "v${version}";
    sha256 = "VY2pySi/sCqc9Mx+azj2fR3a46w+fcmPuK+jTBj9018=";
  };

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
    wrapGAppsHook
    gtk3
  ];

  buildInputs = [
    meson
    ninja
  ];

  propagatedUserEnvPkgs = [
    (python3.withPackages (p: with p; [ pygobject3 cairosvg ] ))
  ];

  installPhase = ''
    runHook preInstall

    cd $src
    mkdir -p $out/tmp

    meson $out/tmp/builddir --prefix=$out
    ninja -C $out/tmp/builddir install

    # Only trying to use this for steam atm
    echo "${steam-data}" > $out/share/hardcode-tray/database/steam.json

    export PATH=$out/bin:$PATH

    runHook postInstall
  '';
}
