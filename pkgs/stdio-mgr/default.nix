{ fetchFromGitHub,
  python3,
  python3Packages,
  lib }:
python3.pkgs.buildPythonPackage rec {
  version = "0.0.1";
  pname = "stdio-mgr";
  src = fetchFromGitHub {
    owner = "bskinn";
    repo = "stdi-_mgr";
    rev = "9bf5a93d4621a3c1973c7ac16b257842e0c01aa0";
    sha256 = "0chnx90ygg7w9n0p4ig23hcyfq8pxgrgrgr0y5dahn5f3dx4d36g";
  };

  doCheck = true;

  checkPhase = ''
                    pytest
                    '';

  checkInputs = with python3Packages; [ pytest ];
  
  propagatedBuildInputs = with python3Packages; [
    numpy
    typing-extensions
  ];

  meta = with lib; {
    description = "Context manager for mocking/wrapping stdin/stdout/stderr.";
    homepage = https://github.com/bskinn/stdio-mgr;
    license = licenses.mit;
  };
}