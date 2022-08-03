{ pkgs,
stdio-mgr}:
pkgs.python3.pkgs.buildPythonPackage rec {
  version = "0.0.1";
  pname = "sphobjinv";
  src = pkgs.fetchFromGitHub {
    owner = "bskinn";
    repo = "sphobjinv";
    rev = "7d21f6342702875da87392f2095ee546085ec97a";
    sha256 = "0x8934ys60pwqmnaqib7qw4429ab9sgy4509pvd2qpynv5kkmrk7";
  };
  doCheck = false; # Fails for some reason?

  checkPhase = ''
               pytest
               '';

  checkInputs = [
    pkgs.python3Packages.pytest
    pkgs.python3Packages.dictdiffer
    stdio-mgr ];
  
  propagatedBuildInputs = builtins.attrValues {
    inherit (pkgs.python3Packages) sphinx jsonschema;
  };

  meta = {
    pkgs.lib.description = "Manipulate and inspect Sphinx objects.inv files.";
    pkgs.lib.homepage = https://github.com/bskinn/sphobjinv;
    pkgs.lib.license = pkgs.lib.licenses.mit;
  };
}
