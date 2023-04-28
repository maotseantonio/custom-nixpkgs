{ pkgs, ... }:

{
  colloid-gtk-theme     = pkgs.callPackage ./colloid-gtk-theme { tweaks = [ "rose_pine" ]; };
  hardcode-tray         = pkgs.callPackage ./hardcode-tray {};
  odin                  = pkgs.callPackage ./odin {};
  ols                   = pkgs.callPackage ./ols {};
  papirus-icon-theme    = pkgs.callPackage ./papirus-icon-theme {};
  path-of-building      = pkgs.callPackage ./path-of-building {};
  rose-pine-icon-theme  = pkgs.callPackage ./rose-pine-icon-theme {};
  sddm-rose-pine-theme  = pkgs.callPackage ./sddm-rose-pine-theme {};
}
