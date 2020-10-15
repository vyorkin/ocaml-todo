with import <nixpkgs> { };

pkgs.mkShell {
  buildInputs = [
    gmp pkg-config postgresql
  ];
}
