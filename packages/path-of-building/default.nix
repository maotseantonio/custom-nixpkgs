{ stdenvNoCC
, fetchzip
, wineWowPackages
, lib
}:

let
  cmd = "path-of-building";
  winePrefix = "~/.local/share/PathOfBuilding/.wine";
  dataPathUnix = "${winePrefix}/drive_c/ProgramData/PathOfBuilding/Builds";
  dataPathWine = "C:\\ProgramData\\PathOfBuilding\\Builds\\";

in stdenvNoCC.mkDerivation rec {
  pname = "path-of-building";
  version = "2.30.1";
  dontBuild = true;

  propagatedBuildInputs = [
    wineWowPackages.stableFull
  ];

  src = fetchzip {
    url = "https://github.com/PathOfBuildingCommunity/PathOfBuilding/releases/download/v${version}/PathOfBuildingCommunity-Portable-${version}.zip";
    sha256 = "WUF6JZY/ehGO2kH/YPKKH1WMPuRcEjXmdCa3jAXyeNY=";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/src
    cp -r $src/* $out/src

    # The build path has to be set to a writeable directory via PoB's Settings.xml. 
    # In this case we use a dir on the wine C:\ drive, which is located at $HOME/.local/share/PathOfBuilding/wine/drive_c/.
    echo '
      <?xml version="1.0" encoding="UTF-8"?>
      <PathOfBuilding>
        <Mode mode="LIST">
        </Mode>
        <Accounts lastRealm="PC">
        </Accounts>
        <SharedItems/>
        <Misc 
          betaTest="false"
          connectionProtocol="0"
          thousandsSeparator=","
          showThousandsSeparators="true"
          slotOnlyTooltips="true"
          invertSliderScrollDirection="false"
          showTitlebarName="true"
          disableDevAutoSave="false"
          defaultCharLevel="1"
          nodePowerTheme="RED/BLUE"
          buildSortMode="EDITED"
          showWarnings="true"
          defaultItemAffixQuality="0.5"
          defaultGemQuality="20"
          decimalSeparator="."
          buildPath="${dataPathWine}"
        />
      </PathOfBuilding>
    ' > $out/src/Settings.xml

    # Replace PoB's update script, since the version is controlled by this package.
    # The replacement update script will simply display a notification if a new version is available.
    chmod +w $out/src/UpdateCheck.lua
    echo '${lib.strings.fileContents ./UpdateCheck.lua}' > $out/src/UpdateCheck.lua

    # Remove PoB's builtin update error message.
    # The messages defined in ./UpdateCheck.lua will be used instead.
    chmod +w $out/src/Modules $out/src/Modules/Main.lua
    sed -i 's/Update check failed!\\n//g' $out/src/Modules/Main.lua

    # This is the script that will be added to PATH.
    # It will run PoB via wine and create the data dir on wine's C:\ drive if it doesn't exist yet.
    mkdir -p $out/bin
    echo "
      WINEPREFIX=${winePrefix} ${wineWowPackages.stableFull}/bin/wine $out/src/Path\ Of\ Building.exe &
      if [ ! -d ${dataPathUnix} ]; then
        mkdir -p ${dataPathUnix}
      fi

      if [ ! -e ${winePrefix}/../builds ]; then
        ln -s ${dataPathUnix} ${winePrefix}/../builds
      fi
    " > $out/bin/${cmd}
    chmod +x $out/bin/${cmd}

    # Add a desktop file for PoB so it can be launched as a desktop app.
    mkdir -p $out/share/applications
    echo "
      [Desktop Entry]
      Encoding=UTF-8
      Version=${version}
      Type=Application
      Terminal=false
      Exec=$out/bin/${cmd}
      Name=Path of Building
    " > $out/share/applications/path-of-building.desktop
  '';

  meta = with lib; {
    description = "Offline build planner for Path of Exile";
    homepage = "https://github.com/PathOfBuildingCommunity/PathOfBuilding";
  };
}
