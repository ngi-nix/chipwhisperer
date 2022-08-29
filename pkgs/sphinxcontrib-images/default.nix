{ python3Packages, fetchFromGitHub, maintainers, lib,
  sphobjinv }:
python3Packages.buildPythonPackage rec {
  version = "0.0.1";
  pname = "sphinxcontrib-images";
  src = fetchFromGitHub {
    owner = "sphinx-contrib";
    repo = "images";
    rev = "b5747fd3b66a34a8c8c1cee4af4baa8e72286849";
    sha256 = "00h947nyyif4p6v4gwni1x0w9qmy9b5c0dyia12clpw17dr8wkbb";
  };
  doCheck = false; # There are no tests for this package

  checkPhase = ''
               pytest
               '';

  checkInputs = [ python3Packages.pytest ];
  
  propagatedBuildInputs = [
    sphobjinv
    python3Packages.sphinx
  ];

  meta = {
    description = "Easy thumbnails in Sphinx documentation (focused on HTML).";
    homepage = https://github.com/sphinx-contrib/images;
    license = lib.licenses.asl20;
    maintainers = [ maintainers.svaes ];
  };
}
