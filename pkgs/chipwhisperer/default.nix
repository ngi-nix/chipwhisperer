{ pkgs, isrc, iversion, sphinxcontrib-images, sphinx-autodoc-typehints }:
with pkgs; python3.pkgs.buildPythonPackage rec {
  version = iversion;
  name = "chipwhisperer";
  pname = "chipwhisperer";
  src = isrc;
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
}
