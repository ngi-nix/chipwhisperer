{ pkgs,
  sphobjinv }:
pkgs.python3.pkgs.buildPythonPackage rec {
  version = "0.0.1";
  pname = "sphinxcontrib-images";
  src = pkgs.fetchFromGitHub {
    owner = "sphinx-contrib";
    repo = "images";
    rev = "b5747fd3b66a34a8c8c1cee4af4baa8e72286849";
    sha256 = "00h947nyyif4p6v4gwni1x0w9qmy9b5c0dyia12clpw17dr8wkbb";
  };
  doCheck = false; # There are no tests for this package

  checkPhase = ''
               pytest
               '';

  checkInputs = [ pkgs.python3Packages.pytest ];
  
  propagatedBuildInputs = [
    sphobjinv
    pkgs.python3Packages.sphinx
  ];

  meta = {
    pkgs.lib.description = "Easy thumbnails in Sphinx documentation (focused on HTML).";
    pkgs.lib.homepage = https://github.com/sphinx-contrib/images;
    pkgs.lib.license = pkgs.lib.licenses.asl20;
  };
}
