{
  python3,
  lib,
  ...
}:
python3.pkgs.buildPythonApplication {
  pname = "checkhash";
  version = "0.1.0";
  format = "other";

  src = ./.;

  dontBuild = true;

  installPhase = ''
    install -Dm755 checkhash.py $out/bin/checkhash
  '';

  meta = {
    description = "A tool to check file hashes against known values.";
    licenses = lib.licenses.mit;
  };
}
