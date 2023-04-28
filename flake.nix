{
  description = "Simple flake with a few custom packages I use";

  outputs = { self }: {
    extraPkgs = ./packages;
  };
}
