{ pkgs }:

let
  steam-tray-icon = "share/icons/Papirus/16x16/panel/steam_tray_mono.svg";

in pkgs.papirus-icon-theme.overrideAttrs (p: {
  installPhase = builtins.replaceStrings ["runHook postInstall"] [''
    # convert steam tray icon to png cuz smth seems to be broken otherwise
    ${pkgs.librsvg}/bin/rsvg-convert -w 14 -h 14 $out/${steam-tray-icon} > $out/share/icons/Papirus/16x16/panel/steam_tray_mono.png

    runHook postInstall
  ''] p.installPhase;
})
