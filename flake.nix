{
  description = "Flake for ChipWhisperer";

  # Nixpkgs / NixOS version to use.
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
    
    # Upstream source tree(s).
    chipwhisperer-src = {
      # TODO: Change to "github:newaetech/chipwhisperer" when PR is resolved
      url = github:S-Vaes/chipwhisperer-fork;
      flake = false;
    };
    chipwhisperer-jupyter-src = {
      url = github:newaetech/chipwhisperer-jupyter;
      flake = false;
    };
    
    sphinxcontrib-images-src = {
      url = github:sphinx-contrib/images;
      flake = false;
    };
    sphinx-autodoc-typehints-src = {
      url = github:tox-dev/sphinx-autodoc-typehints;
      flake = false;
    };
    sphobjinv-src = {
      url = github:bskinn/sphobjinv;
      flake = false;
    };
    nptyping-src = {
      url = github:ramonhagenaars/nptyping;
      flake = false;
    };
    stdio-mgr-src = {
      url = github:bskinn/stdio-mgr;
      flake = false;
    };
    pyright-src = {
      url = github:RobertCraigie/pyright-python;
      flake = false;
    };
  };
  outputs = { self, nixpkgs, flake-utils,
              chipwhisperer-src, chipwhisperer-jupyter-src,
              sphinxcontrib-images-src,
              sphinx-autodoc-typehints-src,
              sphobjinv-src,
              nptyping-src,
              stdio-mgr-src,
              pyright-src}@inputs:
                flake-utils.lib.eachDefaultSystem (system:
                  let
                    pkgs = import nixpkgs {
					            inherit system;
				            };
                    python = "python39";

                    # Generate a user-friendly version numer.
                    # version = builtins.substring 0 8 chipwhisperer-src.lastModifiedDate;
                    versions =
                      let
                        generateVersion = builtins.substring 0 8;
                      in
                        nixpkgs.lib.genAttrs
                          [ "chipwhisperer" "sphinxcontrib-images" "sphinx-autodoc-typehints"
                            "sphobjinv" "nptyping" "stdio-mgr" "pyright"]
                          (n: generateVersion inputs."${n}-src".lastModifiedDate);

                    nptyping = pkgs.callPackage ./pkgs/nptyping { pkgs = pkgs;
                      isrc = nptyping-src;
                      iversion = versions.nptyping;
                      pyright = pyright;
                      stdio-mgr = stdio-mgr; };

                    stdio-mgr = pkgs.callPackage ./pkgs/stdio-mgr { pkgs = pkgs;
                      isrc = stdio-mgr-src;
                      iversion = versions.stdio-mgr; };

                    pyright = pkgs.callPackage ./pkgs/pyright { pkgs = pkgs;
                      isrc = pyright-src;
                      iversion = versions.pyright; };

                    sphobjinv = pkgs.callPackage ./pkgs/sphobjinv { pkgs = pkgs;
                      isrc = sphobjinv-src;
                      iversion = versions.sphobjinv; };

                    sphinxcontrib-images = pkgs.callPackage ./pkgs/sphinxcontrib-images { pkgs = pkgs;
                      isrc = sphinxcontrib-images-src;
                      iversion = versions.sphinxcontrib-images;
                      sphobjinv = sphobjinv; };

                    sphinx-autodoc-typehints = pkgs.callPackage ./pkgs/sphinx-autodoc-typehints { pkgs = pkgs;
                      isrc = sphinx-autodoc-typehints-src;
                      iversion = versions.sphinx-autodoc-typehints;
                      sphobjinv = sphobjinv;
                      nptyping = nptyping; };

                    chipwhisperer = pkgs.callPackage ./pkgs/chipwhisperer { pkgs = pkgs;
                      isrc = chipwhisperer-src;
                      iversion = versions.chipwhisperer;
                      sphinxcontrib-images = sphinxcontrib-images;
                      sphinx-autodoc-typehints = sphinx-autodoc-typehints; };
                    
                  pythonEnv = pkgs.python39.withPackages (ps: [
                    chipwhisperer
                  ]);
                in {
                  # The default package for 'nix build'. This makes sense if the
                  # flake provides only one package or there is a clear "main"
                  # Provide some binary packages for selected system types.
                  packages = flake-utils.lib.flattenTree {
                    default = chipwhisperer;
                    chipwhisperer = chipwhisperer;
                    sphinx-autodoc-typehints = sphinx-autodoc-typehints;
                    sphinxcontrib-images = sphinxcontrib-images;
                    sphobjinv = sphobjinv;
                    nptyping = nptyping;
                    stdio-mgr = stdio-mgr;
                    pyright = pyright;
                  };

                  devShells.default = pkgs.mkShell {
                    buildInputs = [
                      (pkgs.python39.withPackages (p: with p; [ chipwhisperer ]))
                    ];
                  };
                }) // {
                  overlays = {
                    default = final: prev: {
                      inherit (self.packages) chipwhisperer;
                    };
                  };
                };
}
