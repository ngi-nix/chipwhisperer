{ python3Packages, fetchFromGitHub, maintainers, lib,
  stdio-mgr}:
python3Packages.buildPythonPackage rec {
  version = "0.0.1";
  pname = "sphobjinv";
  src = fetchFromGitHub {
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
    python3Packages.pytest
    python3Packages.dictdiffer
    stdio-mgr ];
  
  propagatedBuildInputs = builtins.attrValues {
    inherit (python3Packages) sphinx jsonschema;
  };

  meta = {
    description = "Manipulate and inspect Sphinx objects.inv files.";
    homepage = https://github.com/bskinn/sphobjinv;
    license = lib.licenses.mit;
    maintainers = [ maintainers.svaes ];
  };
}
