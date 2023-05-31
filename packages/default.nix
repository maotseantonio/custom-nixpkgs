{ pkgs, ... }:

{
  nitch                   = pkgs.callPackage ./nitch {};
  odin                    = pkgs.callPackage ./odin {};
  ols                     = pkgs.callPackage ./ols {};
  path-of-building        = pkgs.callPackage ./path-of-building {};
  sddm-rose-pine          = pkgs.callPackage ./sddm-rose-pine {};
}
