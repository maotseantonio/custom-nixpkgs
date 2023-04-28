{
  description = "Simple flake with a few custom packages I use";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
  };

  outputs = { self, nixpkgs }: 
    let 
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; }; 

    in {
      # Can be used via 'nix shell /path/to/this/flake#<package>'
      packages.${system} = import ./packages { inherit pkgs; };

      # Use this for importing packages to another flake
      extraPkgs = ./packages;
    };
}
