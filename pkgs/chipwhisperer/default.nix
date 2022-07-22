{ libusb,
  fetchFromGitHub,
  python3,
  python3Packages,
  lib,
  sphinxcontrib-images,
  sphinx-autodoc-typehints }:
python3.pkgs.buildPythonPackage rec {
  version = "0.0.1";
  pname = "chipwhisperer";
  src = fetchFromGitHub {
    owner = "newaetech";
    repo = "chipwhisperer";
    rev = "4bf6a266d717ad27cfef16065604b663dd6c2aef";
    sha256 = "1mnbw2crrj34bba4kadxmd5iqrjqyfr90hgd9fkwsafdzy53dmjh";
  };
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
    libusb
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
}
