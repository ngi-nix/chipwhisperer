{ fetchFromGitHub,
  python3,
  python3Packages,
  lib }:
python3.pkgs.buildPythonPackage rec {
  version = "0.0.1";
  pname = "sphobjinv";
  src = fetchFromGitHub {
    owner = "bskinn";
    repo = "sphobjinv";
    rev = "7d21f6342702875da87392f2095ee546085ec97a";
    sha256 = "0x8934ys60pwqmnaqib7qw4429ab9sgy4509pvd2qpynv5kkmrk7";
  };
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
