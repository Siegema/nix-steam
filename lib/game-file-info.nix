let
  defaultInstallPhase = ''
    mkdir -p $out
    cp -a game/* $out
  '';
in { name, appId, depotId, manifestId, platform ? "linux", installPhase ? defaultInstallPhase, hash }: {
  inherit name appId platform depotId manifestId installPhase hash;
}
