inputs: versions: _: final: rec {
  maintainers.svaes = {
    email = "sil.g.vaes@gmail.com";
    matrix = "@egyptian_cowboy:matrix";
    name = "Sil Vaes";
    github = "s-vaes";
    githubId = 8971074;
  };
  
  cw = {
    stdio-mgr = (final.callPackage ./stdio-mgr { }).overridePythonAttrs (oldAttrs: {
      src = inputs.stdio-mgr;
      version = versions.stdio-mgr;
    });

    pyright = (final.callPackage ./pyright { }).overridePythonAttrs (oldAttrs: {
      src = inputs.pyright;
      version = versions.pyright;
    });

    nptyping = (final.callPackage ./nptyping {
      pyright = cw.pyright;
      stdio-mgr = cw.stdio-mgr;
    }).overridePythonAttrs (oldAttrs: {
      src = inputs.nptyping;
      version = versions.nptyping;
    });

    sphobjinv = (final.callPackage ./sphobjinv {
      stdio-mgr = cw.stdio-mgr;
    }).overridePythonAttrs (oldAttrs: {
      src = inputs.sphobjinv;
      version = versions.sphobjinv;
    });

    sphinxcontrib-images = (final.callPackage ./sphinxcontrib-images {
      sphobjinv = cw.sphobjinv;
    }).overridePythonAttrs (oldAttrs: {
      src = inputs.sphinxcontrib-images;
      version = versions.sphinxcontrib-images;
    });

    sphinx-autodoc-typehints = (final.callPackage ./sphinx-autodoc-typehints {
      sphobjinv = cw.sphobjinv;
      nptyping = cw.nptyping;
    }).overridePythonAttrs (oldAttrs: {
      src = inputs.sphinx-autodoc-typehints;
      version = versions.sphinx-autodoc-typehints;
    });

    chipwhisperer = (final.callPackage ./chipwhisperer {
      sphinxcontrib-images = cw.sphinxcontrib-images;
      sphinx-autodoc-typehints = cw.sphinx-autodoc-typehints;
    }).overridePythonAttrs (oldAttrs: {
      src = inputs.chipwhisperer;
      version = versions.chipwhisperer;
    });
  };

  default = cw.chipwhisperer;

  devShells.default = final.callPackage ./shell.nix { };
}
