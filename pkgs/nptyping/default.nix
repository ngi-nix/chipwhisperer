{ pkgs,
  pyright, stdio-mgr }:
pkgs.python3.pkgs.buildPythonPackage rec {
  version = "0.0.1";
  pname = "nptyping";
  src = pkgs.fetchFromGitHub {
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
    pkgs.python3Packages.pytest
    pkgs.python3Packages.typeguard
    pkgs.python3Packages.mypy
    pkgs.python3Packages.feedparser
    pkgs.python3Packages.beartype
    pyright
    stdio-mgr ];
  
  propagatedBuildInputs = builtins.attrValues {
    inherit (pkgs.python3Packages) numpy typing-extensions;
  };

  meta = {
    pkgs.lib.description = "Extensive dynamic type checks for dtypes and shapes of arrays.";
    pkgs.lib.homepage = https://github.com/ramonhagenaars/nptyping;
    pkgs.lib.license = pkgs.lib.licenses.mit;
  };
}
