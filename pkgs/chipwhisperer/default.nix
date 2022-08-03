{ python3Packages, fetchFromGitHub,
  libusb1,
  sphinxcontrib-images,
  sphinx-autodoc-typehints }:
python3Packages.buildPythonPackage rec {
  version = "0.0.1";
  pname = "chipwhisperer";
  src = fetchFromGitHub {
    owner = "newaetech";
    repo = "chipwhisperer";
    rev = "4bf6a266d717ad27cfef16065604b663dd6c2aef";
    sha256 = "1mnbw2crrj34bba4kadxmd5iqrjqyfr90hgd9fkwsafdzy53dmjh";
  };
  
  doCheck = false; # False because hardware needs to be connected to test/check

  checkInputs = builtins.attrValues { inherit (python3Packages) pytest; };
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
  
  buildInputs = [
    libusb1
  ];
  
  propagatedBuildInputs = [
    python3Packages.libusb1
    python3Packages.configobj
    python3Packages.iso8601
    python3Packages.numpy
    python3Packages.pycryptodome
    python3Packages.pyparsing
    python3Packages.python-dateutil
    python3Packages.pytz
    python3Packages.pyusb
    python3Packages.scipy
    python3Packages.sphinx
    python3Packages.sphinx_rtd_theme
    python3Packages.pyserial
    python3Packages.fastdtw
    python3Packages.cython
    python3Packages.pypandoc
    python3Packages.tqdm
    python3Packages.ipython
    python3Packages.ecpy
    sphinxcontrib-images
    sphinx-autodoc-typehints
  ];

  meta = {
    meta.description = "Open source toolchain dedicated to hardware security research.";
    meta.homepage = https://github.com/newaetech/chipwhisperer;
    meta.license = meta.licenses.gpl2Plus;
  };
}
