{ pkgs, isrc, iversion, pyright, stdio-mgr }:
with pkgs; python3.pkgs.buildPythonPackage rec {
  version = iversion;
  pname = "nptyping";
  src = isrc;
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
