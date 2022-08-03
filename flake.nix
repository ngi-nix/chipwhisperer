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
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };

          python = "python39";

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

          # Define the overlays
          overlays.all = import ./pkgs inputs versions;
          overlays.default = (overlays.all null nixpkgs.legacyPackages.${system}).chipwhisperer;
        in
        {
          # The default package for 'nix build'. This makes sense if the
          # flake provides only one package or there is a clear "main"
          # Provide some binary packages for selected system types.
          packages = flake-utils.lib.flattenTree {
            default = (overlays.all null nixpkgs.legacyPackages.${system}).chipwhisperer;
            chipwhisperer = (overlays.all null nixpkgs.legacyPackages.${system}).chipwhisperer;
            sphinx-autodoc-typehints = (overlays.all null nixpkgs.legacyPackages.${system}).sphinx-autodoc-typehints;
            sphinxcontrib-images = (overlays.all null nixpkgs.legacyPackages.${system}).sphinxcontrib-images;
            sphobjinv = (overlays.all null nixpkgs.legacyPackages.${system}).sphobjinv;
            nptyping = (overlays.all null nixpkgs.legacyPackages.${system}).nptyping;
            stdio-mgr = (overlays.all null nixpkgs.legacyPackages.${system}).stdio-mgr;
            pyright = (overlays.all null nixpkgs.legacyPackages.${system}).pyright;
          };

          # Default shell
          devShells.default = pkgs.mkShell {
            packages = [
              (overlays.all null nixpkgs.legacyPackages.${system}).chipwhisperer
            ];
          };

          overlays = final: prev: {
            default = (overlays.default final nixpkgs.legacyPackages.${system});
            all = (overlays.all final nixpkgs.legacyPackages.${system});
          };
        });
}
