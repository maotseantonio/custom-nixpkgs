{ pkgs, ... }:

{
  amdsmi                  = pkgs.callPackage ./amdsmi {};
  cgv = {
    master                = pkgs.callPackage ./cgv { gitCommit = "master"; };
    develop               = pkgs.callPackage ./cgv { gitCommit = "develop"; };
    font-fix              = pkgs.callPackage ./cgv { gitCommit = "font-fix"; };
  };
  cinder                  = pkgs.callPackage ./cinder {};
  fcitx5-rose-pine-edit   = pkgs.callPackage ./fcitx5-rose-pine-edit {};
  nitch                   = pkgs.callPackage ./nitch {};
  odin                    = pkgs.callPackage ./odin {};
  ols                     = pkgs.callPackage ./ols {};
  path-of-building        = pkgs.callPackage ./path-of-building {};
  sddm-rose-pine          = pkgs.callPackage ./sddm-rose-pine {};
  sddm-astronaut-theme     = pkgs.callPackage ./sddm-astronaut-theme {};

  vimPlugins = {
    harpoon               = pkgs.callPackage ./vim/plugins/harpoon {};
    ranger-nvim           = pkgs.callPackage ./vim/plugins/ranger-nvim {};
  };
}
