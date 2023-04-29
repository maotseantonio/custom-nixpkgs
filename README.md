# nix-extra-pkgs

Simple flake with additional packages I use personally, that are not available
in [Nixpkgs](https://github.com/NixOS/nixpkgs).



## Usage

### Example for dev shell with odin tools (with `nix develop`)
```nix 
{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    nix-extra-pkgs = {
      url = "github:lwndhrst/nix-extra-pkgs";
    };
  };

  outputs = { self, nixpkgs, nix-extra-pkgs }:
    let 
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nix-extra-pkgs.overlays.default ];
      };

    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          nixExtraPkgs.ols

          # This flake should not affect normal nixpkgs at all
          sl
        ];

        buildInputs = with pkgs; [
          nixExtraPkgs.odin
        ];
      };
    };
}
```



## With `nix shell`

For use with `nix shell`, add this flake to the registry:

```
nix registry add extra github:lwndhrst/nix-extra-pkgs
```

Packages from this flake can then be run like so:

```
nix shell extra#<package>
```



## List of packages in this flake

- [odin](https://github.com/odin-lang/Odin)
- [ols](https://github.com/DanielGavin/ols)
- [papirus-icon-theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) (with scuffed steam tray icon fix)
- [path-of-building](https://github.com/PathOfBuildingCommunity/PathOfBuilding)
- [sddm-rose-pine-theme](https://github.com/lwndhrst/sddm-rose-pine) (SDDM theme based on [SDDM Sugar Dark](https://github.com/MarianArlt/sddm-sugar-dark) with [Rose Pine](https://rosepinetheme.com/) palette)
