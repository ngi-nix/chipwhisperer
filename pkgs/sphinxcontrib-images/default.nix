{ pkgs, isrc, iversion, sphobjinv }:
with pkgs; python3.pkgs.buildPythonPackage rec {
  version = iversion;
  pname = "sphinxcontrib-images";
  src = isrc;
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
