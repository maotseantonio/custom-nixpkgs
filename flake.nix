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
      # This can be run via the 'nix shell' command
      packages.${system} = import ./packages { inherit pkgs; };

      # Use this for importing packages to another flake
      extraPkgs = ./packages;
    };
}
