{ mkShell, local_overlay }:
mkShell {
  packages = [
    (local_overlay null nixpkgs.legacyPackages.${system}).chipwhisperer
  ];
}
