{
  inputs = {
    nixpkgs.url = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      supportedSystems = nixpkgs.lib.platforms.all;
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
      forAll =
        f:
        forAllSystems (
          system:
          f {
            inherit system;
            pkgs = nixpkgsFor.${system};
          }
        );
    in
    {
      formatter = forAll ({ pkgs, ... }: pkgs.nixfmt-rfc-style);

      packages = forAll (
        { pkgs, ... }:
        with pkgs;
        {
          aqualung = callPackage ./aqualung.nix { };
        }
      );
    };
}
