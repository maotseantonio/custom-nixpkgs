{ pkgs, ... }:

{
  nitch                 = pkgs.callPackage ./nitch {};
  odin                  = pkgs.callPackage ./odin {};
  ols                   = pkgs.callPackage ./ols {};
  papirus-icon-theme    = pkgs.callPackage ./papirus-icon-theme {};
  path-of-building      = pkgs.callPackage ./path-of-building {};
  sddm-rose-pine-theme  = pkgs.callPackage ./sddm-rose-pine-theme {};
}
