{ pkgs }:
pkgs.python3.pkgs.buildPythonPackage rec {
  version = "0.0.1";
  pname = "stdio-mgr";
  src = pkgs.fetchFromGitHub {
    owner = "bskinn";
    repo = "stdi-_mgr";
    rev = "9bf5a93d4621a3c1973c7ac16b257842e0c01aa0";
    sha256 = "0chnx90ygg7w9n0p4ig23hcyfq8pxgrgrgr0y5dahn5f3dx4d36g";
  };

  doCheck = true;

  checkPhase = ''
               pytest
               '';

  checkInputs = builtins.attrValues { inherit (pkgs.python3Packages) pytest; };
  
  propagatedBuildInputs =  builtins.attrValues {
    inherit (pkgs.python3Packages) numpy typing-extensions;
  };

  meta = {
    pkgs.lib.description = "Context manager for mocking/wrapping stdin/stdout/stderr.";
    pkgs.lib.homepage = https://github.com/bskinn/stdio-mgr;
    pkgs.lib.license = pkgs.lib.licenses.mit;
  };
}
