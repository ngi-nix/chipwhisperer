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
    sphinxcontrib-autodoc-typehints-src = {
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
              sphinxcontrib-autodoc-typehints-src,
              sphobjinv-src,
              nptyping-src,
              stdio-mgr-src,
              pyright-src}:
                flake-utils.lib.eachDefaultSystem (system:
                  let
                    pkgs = import nixpkgs {
					            inherit system;
				            };
                    python = "python39";

                    # Generate a user-friendly version numer.
                    # version = builtins.substring 0 8 chipwhisperer-src.lastModifiedDate;
                    chipwhisperer-version = builtins.substring 0 8 chipwhisperer-src.lastModifiedDate;
                    sphinxcontrib-images-version = builtins.substring 0 8 sphinxcontrib-images-src.lastModifiedDate;
                    sphinxcontrib-autodoc-typehints-version = builtins.substring 0 8 sphinxcontrib-autodoc-typehints-src.lastModifiedDate;
                    sphobjinv-version = builtins.substring 0 8 sphobjinv-src.lastModifiedDate;
                    nptyping-version = builtins.substring 0 8 nptyping-src.lastModifiedDate;
                    stdio-mgr-version = builtins.substring 0 8 stdio-mgr-src.lastModifiedDate;
                    pyright-version = builtins.substring 0 8 pyright-src.lastModifiedDate;

                    # --- pyright ---
                    pyright = with pkgs; python3.pkgs.buildPythonPackage rec {
                      version = pyright-version;
                      pname = "pyright";
                      src = pyright-src;
                      doCheck = false;

                      checkPhase = ''
                    pytest
                    '';

                      checkInputs = with python3Packages; [ pytest pytest-subprocess ];
                      
                      propagatedBuildInputs = with python3Packages; [
                        nodeenv
                        typing-extensions
                      ];

                      meta = with lib; {
                        description = "Pyright for Python is a Python command-line wrapper over pyright, a static type checker for Python.";
                        homepage = https://github.com/RobertCraigie/pyright-python;
                        license = licenses.mit;
                      };
                    };
                    # ---

                    # --- stdio-mgr ---
                    stdio-mgr = with pkgs; python3.pkgs.buildPythonPackage rec {
                      version = stdio-mgr-version;
                      pname = "stdio-mgr";
                      src = stdio-mgr-src;
                      doCheck = true;

                      checkPhase = ''
                    pytest
                    '';

                      checkInputs = with python3Packages; [ pytest ];
                      
                      propagatedBuildInputs = with python3Packages; [
                        numpy
                        typing-extensions
                      ];

                      meta = with lib; {
                        description = "Context manager for mocking/wrapping stdin/stdout/stderr.";
                        homepage = https://github.com/bskinn/stdio-mgr;
                        license = licenses.mit;
                      };
                    };
                    # ---

                    # --- nptyping ---
                    nptyping = with pkgs; python3.pkgs.buildPythonPackage rec {
                      version = nptyping-version;
                      pname = "nptyping";
                      src = nptyping-src;
                      doCheck = false;

                      checkPhase = ''
                    pytest
                    '';
                      
                      checkInputs = with python3Packages; [ pytest typeguard pyright stdio-mgr mypy feedparser beartype ];
                      
                      propagatedBuildInputs = with python3Packages; [
                        numpy
                        typing-extensions
                      ];

                      meta = with lib; {
                        description = "Extensive dynamic type checks for dtypes and shapes of arrays.";
                        homepage = https://github.com/ramonhagenaars/nptyping;
                        license = licenses.mit;
                      };
                    };
                    # ---

                    # --- sphobjinv ---
                    sphobjinv = with pkgs; python3.pkgs.buildPythonPackage rec {
                      version = sphobjinv-version;
                      pname = "sphobjinv";
                      src = sphobjinv-src;
                      doCheck = false;

                      checkPhase = ''
                    pytest
                    '';

                      checkInputs = with python3Packages; [ pytest stdio-mgr dictdiffer ];
                      
                      propagatedBuildInputs = with python3Packages; [
                        sphinx
                        jsonschema
                      ];

                      meta = with lib; {
                        description = "Manipulate and inspect Sphinx objects.inv files.";
                        homepage = https://github.com/bskinn/sphobjinv;
                        license = licenses.mit;
                      };
                    };
                    # ---

                    # --- sphinxcontrib-images ---
                    sphinxcontrib-images = with pkgs; python3.pkgs.buildPythonPackage rec {
                      version = sphinxcontrib-images-version;
                      pname = "sphinxcontrib-images";
                      src = sphinxcontrib-images-src;
                      doCheck = false;

                      checkPhase = ''
                    pytest
                    '';

                      checkInputs = with python3Packages; [ pytest ];
                      
                      propagatedBuildInputs = with python3Packages; [
                        sphobjinv
                        sphinx
                      ];

                      meta = with lib; {
                        description = "Easy thumbnails in Sphinx documentation (focused on HTML).";
                        homepage = https://github.com/sphinx-contrib/images;
                        license = licenses.asl20;
                      };
                    };
                    # ---

                    # --- sphinx-autodoc-typehints ---
                    sphinx-autodoc-typehints = with pkgs; python3.pkgs.buildPythonPackage rec {
                      version = sphinxcontrib-autodoc-typehints-version;
                      pname = "sphinx-autodoc-typehints";
                      src = sphinxcontrib-autodoc-typehints-src;
                      doCheck = false;

                      checkPhase = ''
                    pytest
                    '';
                      
                      checkInputs = with python3Packages; [ pytest sphobjinv nptyping ];

                      propagatedBuildInputs = with python3Packages; [
                        sphinx
                      ];
                      
                      meta = with lib; {
                        description = "This extension allows you to use Python 3 annotations for documenting acceptable argument types and return value types of functions.";
                        homepage = https://github.com/tox-dev/sphinx-autodoc-typehints;
                        license = licenses.mit;
                      };
                    };
                    # ---

                    # --- chipwhisperer ---
                    chipwhisperer = with pkgs; python3.pkgs.buildPythonPackage rec {
                      version = chipwhisperer-version;
                      name = "chipwhisperer";
                      pname = "chipwhisperer";
                      src = chipwhisperer-src;
                      doCheck = false;

                      checkInputs = with python3Packages; [ pytest ];
                      checkPhase = ''
                    export HOME="$(mktemp -d)"
                    python3 -m pytest ./tests/
                    '';

                      # buildPhase = ''
                      # python3 setup.py develop
                      # '';

                      preInstallPhase = ''
                    mkdir -p $out/lib/udev/rules.d
                    cp hardware/50-newae.rules $out/lib/udev/rules.d
                    '';
                      
                      # installPhase = ''
                      # mkdir -p $out/lib/udev/rules.d
                      # cp hardware/50-newae.rules $out/lib/udev/rules.d
                      # pip install *.whl
                      # '';
                      
                      buildInputs = [
                        pkgs.libusb1
                      ];
                      
                      propagatedBuildInputs = with python3Packages; [
                        libusb1
                        configobj
                        iso8601
                        numpy
                        pycryptodome
                        pyparsing
                        python-dateutil
                        pytz
                        pyusb
                        scipy
                        sphinx
                        sphinx_rtd_theme
                        sphinxcontrib-images
                        pyserial
                        fastdtw
                        cython
                        pypandoc
                        tqdm
                        ipython #needed for rtd
                        ecpy
                        sphinx-autodoc-typehints
                      ];

                      meta = with lib; {
                        description = "Open source toolchain dedicated to hardware security research.";
                        homepage = https://github.com/newaetech/chipwhisperer;
                        license = licenses.gpl2Plus;
                      };
                    };
                    
                  pythonEnv = pkgs.python39.withPackages (ps: [
                    chipwhisperer
                  ]);
                in {
                  # The default package for 'nix build'. This makes sense if the
                  # flake provides only one package or there is a clear "main"
                  # Provide some binary packages for selected system types.
                  # packages.chipwhisperer = chipwhisperer;
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
                    # packages = [ pythonEnv ];
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
