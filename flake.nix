{
  description = "Flake for ChipWhisperer";

  # Nixpkgs / NixOS version to use.
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";

    # Upstream source tree(s).
    chipwhisperer = {
      url = github:newaetech/chipwhisperer;
      flake = false;
    };
    chipwhisperer-jupyter = {
      url = github:newaetech/chipwhisperer-jupyter;
      flake = false;
    };

    sphinxcontrib-images = {
      url = github:sphinx-contrib/images/0.9.4;
      flake = false;
    };
    sphinx-autodoc-typehints = {
      url = github:tox-dev/sphinx-autodoc-typehints/1.19.1;
      flake = false;
    };
    sphobjinv = {
      url = github:bskinn/sphobjinv/v2.2.2;
      flake = false;
    };
    nptyping = {
      url = github:ramonhagenaars/nptyping/v2.2.0;
      flake = false;
    };
    stdio-mgr = {
      url = github:bskinn/stdio-mgr;
      flake = false;
    };
    pyright = {
      url = github:RobertCraigie/pyright-python/v1.1.264;
      flake = false;
    };
  };
  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    let
      # Generate a user-friendly version numer.
      versions =
        let
          generateVersion = builtins.substring 0 8;
        in
          nixpkgs.lib.genAttrs
            [
              "chipwhisperer"
              "sphinxcontrib-images"
              "sphinx-autodoc-typehints"
              "sphobjinv"
              "nptyping"
              "stdio-mgr"
              "pyright"
            ]
            (n: generateVersion inputs."${n}".lastModifiedDate);
      local_overlay = import ./pkgs inputs versions;

      pkgsForSystem = system: import nixpkgs {
        # if you have additional overlays, you may add them here
        overlays = [
          local_overlay # this should expose devShell
        ];
        inherit system;
      };
    in flake-utils.lib.eachDefaultSystem (system:
      {
          # The default package for 'nix build'. This makes sense if the
          # flake provides only one package or there is a clear "main"
          # Provide some binary packages for selected system types.
          packages = flake-utils.lib.flattenTree {
            default = (local_overlay null nixpkgs.legacyPackages.${system}).chipwhisperer;
            chipwhisperer = (local_overlay null nixpkgs.legacyPackages.${system}).chipwhisperer;
            sphinx-autodoc-typehints = (local_overlay null nixpkgs.legacyPackages.${system}).sphinx-autodoc-typehints;
            sphinxcontrib-images = (local_overlay null nixpkgs.legacyPackages.${system}).sphinxcontrib-images;
            sphobjinv = (local_overlay null nixpkgs.legacyPackages.${system}).sphobjinv;
            nptyping = (local_overlay null nixpkgs.legacyPackages.${system}).nptyping;
            stdio-mgr = (local_overlay null nixpkgs.legacyPackages.${system}).stdio-mgr;
            pyright = (local_overlay null nixpkgs.legacyPackages.${system}).pyright;
          };

          # Default shell
          # devShells.default = pkgs.mkShell {
          #   packages = [
          #     (local_overlay null nixpkgs.legacyPackages.${system}).chipwhisperer
          #   ];
          # };

          # overlays = final: prev: {
          #   default = (overlays.default final nixpkgs.legacyPackages.${system});
          #   all = (overlays.all final nixpkgs.legacyPackages.${system});
          # };
        });
}
