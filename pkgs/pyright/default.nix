{ python3Packages, fetchFromGitHub }:
python3Packages.buildPythonPackage rec {
  version = "0.0.1";
  pname = "pyright";
  src = fetchFromGitHub {
    owner = "RobertCraigie";
    repo = "pyright-python";
    rev = "6adecdd3ecf61c8fe5fa87df56ca278f94c0f14f";
    sha256 = "0pjy44381ib06y8r0csh04ryi78m6734z0s98cgrwyr1w99l0xv9";
  };
  
  doCheck = true;

  checkPhase = ''
             pytest
             '';

  checkInputs = builtins.attrValues {
    inherit (python3Packages) pytest pytest-subprocess;
  };
  
  propagatedBuildInputs = builtins.attrValues {
    inherit (python3Packages) nodeenv typing-extensions;
  };

  meta = {
    meta.description = "Pyright for Python is a Python command-line wrapper over pyright, a static type checker for Python.";
    meta.homepage = https://github.com/RobertCraigie/pyright-python;
    meta.license = meta.licenses.mit;
  };
}
