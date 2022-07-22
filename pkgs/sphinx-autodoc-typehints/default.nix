{ fetchFromGitHub,
  python3,
  python3Packages,
  lib,
  sphobjinv,
  nptyping }:
python3.pkgs.buildPythonPackage rec {
  version = "0.0.1";
  pname = "sphinx-autodoc-typehints";
  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "sphinx-autodoc-typehints";
    rev = "e0daa14b9d169bd5738e18b401c39a07ac5964f7";
    sha256 = "01rzvm9xan4f1xh8hb5mv8ic3adkkshlc4fw21j4y94lc0vdqd6i";
  };
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
}
