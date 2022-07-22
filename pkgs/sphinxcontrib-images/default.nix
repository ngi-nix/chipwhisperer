{ fetchFromGitHub,
  python3,
  python3Packages,
  lib,
  sphobjinv }:
python3.pkgs.buildPythonPackage rec {
  version = "0.0.1";
  pname = "sphinxcontrib-images";
  src = fetchFromGitHub {
    owner = "sphinx-contrib";
    repo = "images";
    rev = "b5747fd3b66a34a8c8c1cee4af4baa8e72286849";
    sha256 = "00h947nyyif4p6v4gwni1x0w9qmy9b5c0dyia12clpw17dr8wkbb";
  };
  doCheck = false;

  checkPhase = ''
               pytest
               '';

  checkInputs = with python3Packages; [ pytest ];
  
  propagatedBuildInputs = with python3Packages; [
    sphobjinv
    sphinx
  ];

  meta = with lib; {
    description = "Easy thumbnails in Sphinx documentation (focused on HTML).";
    homepage = https://github.com/sphinx-contrib/images;
    license = licenses.asl20;
  };
}
