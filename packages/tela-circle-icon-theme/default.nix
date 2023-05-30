{ pkgs }:

let
  tray-icon-dir = "share/icons/Tela-circle/16/panel";

in pkgs.tela-circle-icon-theme.overrideAttrs (p: {
  installPhase = builtins.replaceStrings ["runHook postInstall"] [''
    # convert steam tray icon to png cuz smth seems to be broken otherwise
    ${pkgs.librsvg}/bin/rsvg-convert -w 14 -h 14 $out/${tray-icon-dir}/steam_tray_mono.svg > $out/${tray-icon-dir}/steam_tray_mono.png

    runHook postInstall
  ''] p.installPhase;
})
