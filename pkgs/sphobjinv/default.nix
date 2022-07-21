{ pkgs, isrc, iversion }:
with pkgs; python3.pkgs.buildPythonPackage rec {
  version = iversion;
  pname = "sphobjinv";
  src = isrc;
  doCheck = false;

  checkPhase = ''
                    pytest
                    '';

  checkInputs = with python3Packages; [ pytest stdio-mgr dictdiffer ];
  
  propagatedBuildInputs = with python3Packages; [
    sphinx
    jsonschema
  ];

  meta = with lib; {
    description = "Manipulate and inspect Sphinx objects.inv files.";
    homepage = https://github.com/bskinn/sphobjinv;
    license = licenses.mit;
  };
}
