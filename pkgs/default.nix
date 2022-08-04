inputs: versions: _: final: rec {
  stdio-mgr = (final.callPackage ./stdio-mgr { }).overridePythonAttrs (oldAttrs: {
    src = inputs.stdio-mgr;
    version = versions.stdio-mgr;
  });

  pyright = (final.callPackage ./pyright { }).overridePythonAttrs (oldAttrs: {
    src = inputs.pyright;
    version = versions.pyright;
  });

  nptyping = (final.callPackage ./nptyping {
    pyright = pyright;
    stdio-mgr = stdio-mgr;
  }).overridePythonAttrs (oldAttrs: {
    src = inputs.nptyping;
    version = versions.nptyping;
  });

  sphobjinv = (final.callPackage ./sphobjinv {
    stdio-mgr = stdio-mgr;
  }).overridePythonAttrs (oldAttrs: {
    src = inputs.sphobjinv;
    version = versions.sphobjinv;
  });

  sphinxcontrib-images = (final.callPackage ./sphinxcontrib-images {
    sphobjinv = sphobjinv;
  }).overridePythonAttrs (oldAttrs: {
    src = inputs.sphinxcontrib-images;
    version = versions.sphinxcontrib-images;
  });

  sphinx-autodoc-typehints = (final.callPackage ./sphinx-autodoc-typehints {
    sphobjinv = sphobjinv;
    nptyping = nptyping;
  }).overridePythonAttrs (oldAttrs: {
    src = inputs.sphinx-autodoc-typehints;
    version = versions.sphinx-autodoc-typehints;
  });

  chipwhisperer = (final.callPackage ./chipwhisperer {
    sphinxcontrib-images = sphinxcontrib-images;
    sphinx-autodoc-typehints = sphinx-autodoc-typehints;
  }).overridePythonAttrs (oldAttrs: {
    src = inputs.chipwhisperer;
    version = versions.chipwhisperer;
  });

  devShells.default = final.callPackage ./shell.nix { };
}
