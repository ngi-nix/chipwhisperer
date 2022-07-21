{ pkgs, isrc, iversion }:
with pkgs; python3.pkgs.buildPythonPackage rec {
  version = iversion;
  pname = "sphinx-autodoc-typehints";
  src = isrc;
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
