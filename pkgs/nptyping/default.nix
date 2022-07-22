{ fetchFromGitHub,
  python3,
  python3Packages,
  lib,
  pyright, stdio-mgr }:
python3.pkgs.buildPythonPackage rec {
  version = "0.0.1";
  pname = "nptyping";
  src = fetchFromGitHub {
    owner = "ramonhagenaars";
    repo = "nptyping";
    rev = "260da2696fbf9172658d3c4363bfb50478b9068b";
    sha256 = "1fglzpc4x0hsqrkcji3d7n843rpl3prckdn9mp2iablgdg2h8xgf";
  };
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
}
