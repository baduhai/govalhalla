{
  description = "govalhalla";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      # System types to support.
      supportedSystems = [
        "x86_64-linux"
        # "x86_64-darwin"
        # "aarch64-linux"
        # "aarch64-darwin"
      ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      # Essentially allows to define the package once for all systems, instead of once per
      # system.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs currently has valhalla 3.4.0, to get the up-to-date version, an overlay
      # with the custom valhalla package is created. This
      overlay = final: prev: {
        valhalla = final.callPackage ./pkgs/valhalla.nix { };
      };

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          overlays = [ overlay ]; # Overlay is applied.
        }
      );

    in
    {

      # Provide some binary packages for selected system types.
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          govalhalla = pkgs.callPackage ./govalhalla { };
          govalhallatest = pkgs.callPackage ./govalhallatest { };
        }
      );

      # Add dependencies that are only needed for development
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              go
              gopls
              gotools
              go-tools
              self.packages.${system}.govalhalla
            ];
          };
        }
      );
    };
}
