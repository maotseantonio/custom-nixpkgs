# nix-extra-pkgs

Simple flake with additional packages I use personally, that are not available
in [Nixpkgs](https://github.com/NixOS/nixpkgs).



## Usage

### Example for dev shell with odin tools
```nix 
{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    nix-extra-pkgs = {
      url = "github:lwndhrst/nix-extra-pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-extra-pkgs }:
    let 
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      extraPkgs = nix-extra-pkgs;

    in {
      devShell.${system} = pkgs.mkShell {
        buildInputs = with pkgs; [
          extraPkgs.odin
          extraPkgs.ols

          # This flake should not affect normal nixpkgs at all
          sl
        ];
      };
    };
}
```



## List of packages in this flake

- [odin](https://github.com/odin-lang/Odin)
- [ols](https://github.com/DanielGavin/ols)
- [papirus-icon-theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)
- [path-of-building](https://github.com/PathOfBuildingCommunity/PathOfBuilding)
- sddm-rose-pine-theme (SDDM theme based on [SDDM Sugar Dark](https://github.com/MarianArlt/sddm-sugar-dark) with [Rose Pine](https://rosepinetheme.com/) palette)
