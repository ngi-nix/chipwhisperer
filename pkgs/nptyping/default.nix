{ python3Packages, fetchFromGitHub, maintainers, lib,
  pyright, stdio-mgr }:
python3Packages.buildPythonPackage rec {
  version = "0.0.1";
  pname = "nptyping";
  src = fetchFromGitHub {
    owner = "ramonhagenaars";
    repo = "nptyping";
    rev = "260da2696fbf9172658d3c4363bfb50478b9068b";
    sha256 = "1fglzpc4x0hsqrkcji3d7n843rpl3prckdn9mp2iablgdg2h8xgf";
  };
  doCheck = true;

  checkPhase = ''
               pytest
               '';
  
  checkInputs =  [
    python3Packages.pytest
    python3Packages.typeguard
    python3Packages.mypy
    python3Packages.feedparser
    python3Packages.beartype
    pyright
    stdio-mgr ];
  
  propagatedBuildInputs = builtins.attrValues {
    inherit (python3Packages) numpy typing-extensions;
  };

  meta = {
    description = "Extensive dynamic type checks for dtypes and shapes of arrays.";
    homepage = https://github.com/ramonhagenaars/nptyping;
    license = lib.licenses.mit;
    maintainers = [ maintainers.svaes ];
  };
}
