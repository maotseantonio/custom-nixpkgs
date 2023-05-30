{ pkgs, ... }:

{
  nitch                   = pkgs.callPackage ./nitch {};
  odin                    = pkgs.callPackage ./odin {};
  ols                     = pkgs.callPackage ./ols {};
  papirus-icon-theme      = pkgs.callPackage ./papirus-icon-theme { inherit pkgs; };
  path-of-building        = pkgs.callPackage ./path-of-building {};
  sddm-rose-pine          = pkgs.callPackage ./sddm-rose-pine {};
  tela-circle-icon-theme  = pkgs.callPackage ./tela-circle-icon-theme { inherit pkgs; };
}
