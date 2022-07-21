{ pkgs, isrc, iversion }:
with pkgs; python3.pkgs.buildPythonPackage rec {
  version = iversion;
  pname = "pyright";
  src = isrc;
  doCheck = false;

  checkPhase = ''
             pytest
             '';

  checkInputs = with python3Packages; [ pytest pytest-subprocess ];
  
  propagatedBuildInputs = with python3Packages; [
    nodeenv
    typing-extensions
  ];

  meta = with lib; {
    description = "Pyright for Python is a Python command-line wrapper over pyright, a static type checker for Python.";
    homepage = https://github.com/RobertCraigie/pyright-python;
    license = licenses.mit;
  };
}
