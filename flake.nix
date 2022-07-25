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
      # url = github:newaetech/chipwhisperer;
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
                    versions =
                      let
                        generateVersion = builtins.substring 0 8;
                      in
                        nixpkgs.lib.genAttrs
                          [ "chipwhisperer" "sphinxcontrib-images" "sphinx-autodoc-typehints"
                            "sphobjinv" "nptyping" "stdio-mgr" "pyright"]
                          (n: generateVersion inputs."${n}-src".lastModifiedDate);
                    
                    # Define the packages
                    stdio-mgr = (pkgs.callPackage ./pkgs/stdio-mgr { }).overridePythonAttrs (oldAttrs: {
                      src = stdio-mgr-src;
                      version = versions.stdio-mgr;
                    });

                    pyright = (pkgs.callPackage ./pkgs/pyright { }).overridePythonAttrs (oldAttrs : {
                      src = pyright-src;
                      version = versions.pyright;
                    });

                    nptyping = (pkgs.callPackage ./pkgs/nptyping {
                      pyright = pyright;
                      stdio-mgr = stdio-mgr;}).overridePythonAttrs (oldAttrs : {
                        src = nptyping-src;
                        version = versions.nptyping;
                      });

                    sphobjinv = (pkgs.callPackage ./pkgs/sphobjinv { }).overridePythonAttrs (oldAttrs : {
                      src = sphobjinv-src;
                      version = versions.sphobjinv;
                    });

                    sphinxcontrib-images = (pkgs.callPackage ./pkgs/sphinxcontrib-images {
                      sphobjinv = sphobjinv;}).overridePythonAttrs (oldAttrs : {
                        src = sphinxcontrib-images-src;
                        version = versions.sphinxcontrib-images;
                      });

                    sphinx-autodoc-typehints = (pkgs.callPackage ./pkgs/sphinx-autodoc-typehints {
                      sphobjinv = sphobjinv;
                      nptyping = nptyping;}).overridePythonAttrs (oldAttrs : {
                        src = sphinx-autodoc-typehints-src;
                        version = versions.sphinx-autodoc-typehints;
                      });

                    chipwhisperer = (pkgs.callPackage ./pkgs/chipwhisperer {
                      # libusb = libusb1;
                      sphinxcontrib-images = sphinxcontrib-images;
                      sphinx-autodoc-typehints = sphinx-autodoc-typehints;}).overridePythonAttrs (oldAttrs: {
                        src = chipwhisperer-src;
                        version = versions.chipwhisperer;
                      });
                    
                  # pythonEnv = pkgs.python39.withPackages (ps: [
                  #   chipwhisperer
                  # ]);
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

                  # Default shell
                  devShells.default = pkgs.mkShell {
                      buildInputs = [
                        chipwhisperer
                      ];
                      # (pkgs.python39.withPackages (p: with p; [ chipwhisperer ]))
                  };
                }) // {
                  overlays = {
                    default = final: prev: {
                      inherit (self.packages) default;
                    };
                    all = final: prev: {
                      inherit (self.packages) chipwhisperer sphinx-autodoc-typehints sphinxcontrib-images sphobjinv nptyping pyright stdio-mgr;
                    };
                  };
                };
}
