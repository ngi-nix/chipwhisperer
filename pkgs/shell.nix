{ legacyPackages }:
legacyPackages.mkShell {
  packages = [
    legacyPackages.chipwhisperer
  ];
}
