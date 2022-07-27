{ pkgs,
  # libusb,
  sphinxcontrib-images,
  sphinx-autodoc-typehints }:
pkgs.python3.pkgs.buildPythonPackage rec {
  version = "0.0.1";
  pname = "chipwhisperer";
  src = pkgs.fetchFromGitHub {
    owner = "newaetech";
    repo = "chipwhisperer";
    rev = "4bf6a266d717ad27cfef16065604b663dd6c2aef";
    sha256 = "1mnbw2crrj34bba4kadxmd5iqrjqyfr90hgd9fkwsafdzy53dmjh";
  };
  doCheck = false;

  checkInputs = builtins.attrValues { inherit (pkgs.python3Packages) pytest; };
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
  
  propagatedBuildInputs = [
    pkgs.python3Packages.libusb1
    pkgs.python3Packages.configobj
    pkgs.python3Packages.iso8601
    pkgs.python3Packages.numpy
    pkgs.python3Packages.pycryptodome
    pkgs.python3Packages.pyparsing
    pkgs.python3Packages.python-dateutil
    pkgs.python3Packages.pytz
    pkgs.python3Packages.pyusb
    pkgs.python3Packages.scipy
    pkgs.python3Packages.sphinx
    pkgs.python3Packages.sphinx_rtd_theme
    pkgs.python3Packages.pyserial
    pkgs.python3Packages.fastdtw
    pkgs.python3Packages.cython
    pkgs.python3Packages.pypandoc
    pkgs.python3Packages.tqdm
    pkgs.python3Packages.ipython
    pkgs.python3Packages.ecpy
    sphinxcontrib-images
    sphinx-autodoc-typehints
  ];

  meta = {
    pkgs.lib.description = "Open source toolchain dedicated to hardware security research.";
    pkgs.lib.homepage = https://github.com/newaetech/chipwhisperer;
    pkgs.lib.license = pkgs.lib.licenses.gpl2Plus;
  };
}
