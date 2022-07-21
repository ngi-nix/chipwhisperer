{ pkgs, isrc, iversion }:
with pkgs; python3.pkgs.buildPythonPackage rec {
  version = iversion;
  pname = "stdio-mgr";
  src = isrc;
  doCheck = true;

  checkPhase = ''
                    pytest
                    '';

  checkInputs = with python3Packages; [ pytest ];
  
  propagatedBuildInputs = with python3Packages; [
    numpy
    typing-extensions
  ];

  meta = with lib; {
    description = "Context manager for mocking/wrapping stdin/stdout/stderr.";
    homepage = https://github.com/bskinn/stdio-mgr;
    license = licenses.mit;
  };
}
