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
      extraPkgs = import ./packages { inherit pkgs; };

    in {
      # Can be used via 'nix shell /path/to/this/flake#<package>'
      packages.${system} = extraPkgs;

      # Use overlay for importing packages to another flake
      overlays.default = (self: super: { 
        inherit extraPkgs;
      });
    };
}
