{ pkgs,
  sphobjinv,
  nptyping }:
pkgs.python3.pkgs.buildPythonPackage rec {
  version = "0.0.1";
  pname = "sphinx-autodoc-typehints";
  src = pkgs.fetchFromGitHub {
    owner = "tox-dev";
    repo = "sphinx-autodoc-typehints";
    rev = "e0daa14b9d169bd5738e18b401c39a07ac5964f7";
    sha256 = "01rzvm9xan4f1xh8hb5mv8ic3adkkshlc4fw21j4y94lc0vdqd6i";
  };
  doCheck = false;

  checkPhase = ''
               pytest
               '';
  
  checkInputs = builtins.attrValues { inherit (pkgs.python3Packages) pytest sphobjinv nptyping; };

  propagatedBuildInputs = builtins.attrValues {
    inherit (pkgs.python3Packages) sphinx;
  };
  
  meta = {
    pkgs.lib.description = "This extension allows you to use Python 3 annotations for documenting acceptable argument types and return value types of functions.";
    pkgs.lib.homepage = https://github.com/tox-dev/sphinx-autodoc-typehints;
    pkgs.lib.license = pkgs.lib.licenses.mit;
  };
}
