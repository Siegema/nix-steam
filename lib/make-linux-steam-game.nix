{ callPackage, steamGameFetcher }:

{ steamUserInfo, game, drvPath, hash, installPhase ? null }:

callPackage drvPath {
  inherit game steamUserInfo;
  gameFiles = steamGameFetcher {
    inherit game steamUserInfo hash installPhase;
  };
}
