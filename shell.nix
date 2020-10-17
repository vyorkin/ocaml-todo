with import <nixpkgs> { };

pkgs.mkShell {
  buildInputs = [
    gmp pcre libffi pkg-config postgresql
  ];
}
