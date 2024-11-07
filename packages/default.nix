{ pkgs, ... }:

{
  cgv = {
    master                = pkgs.callPackage ./cgv { gitBranch = "master"; };
    develop               = pkgs.callPackage ./cgv { gitBranch = "develop"; };
  };
  cinder                  = pkgs.callPackage ./cinder {};
  nitch                   = pkgs.callPackage ./nitch {};
  odin                    = pkgs.callPackage ./odin {};
  ols                     = pkgs.callPackage ./ols {};
  path-of-building        = pkgs.callPackage ./path-of-building {};
  sddm-rose-pine          = pkgs.callPackage ./sddm-rose-pine {};

  vimPlugins = {
    harpoon               = pkgs.callPackage ./vim/plugins/harpoon {};
    ranger-nvim           = pkgs.callPackage ./vim/plugins/ranger-nvim {};
  };
}
