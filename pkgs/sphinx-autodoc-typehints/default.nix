{ python3Packages, fetchFromGitHub, pkgs,
  sphobjinv,
  nptyping }:
python3Packages.buildPythonPackage rec {
  version = "0.0.1";
  pname = "sphinx-autodoc-typehints";
  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "sphinx-autodoc-typehints";
    rev = "e0daa14b9d169bd5738e18b401c39a07ac5964f7";
    sha256 = "01rzvm9xan4f1xh8hb5mv8ic3adkkshlc4fw21j4y94lc0vdqd6i";
  };
  doCheck = false; # There is no version module

  checkPhase = ''
               pytest
               '';
  
  checkInputs = [
    python3Packages.pytest
    sphobjinv
    nptyping ];

  propagatedBuildInputs = builtins.attrValues {
    inherit (python3Packages) sphinx;
  };
  
  meta = {
    meta.description = "This extension allows you to use Python 3 annotations for documenting acceptable argument types and return value types of functions.";
    meta.homepage = https://github.com/tox-dev/sphinx-autodoc-typehints;
    meta.license = meta.licenses.mit;
  };
}
