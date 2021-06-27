{ callPackage, steamGameFetcher, lib, symlinkJoin }:

{ steamUserInfo, game, gameFiles, drvPath, proton ? null }:
callPackage drvPath {
  inherit game steamUserInfo proton;
  gameFiles = if !(lib.isList gameFiles) then steamGameFetcher {
    inherit steamUserInfo;
    game = gameFiles;
  } else symlinkJoin {
    name = "${game.name}-files";

    paths = lib.forEach gameFiles (gameFile:
    steamGameFetcher {
      inherit steamUserInfo;
      game = gameFile;
    });
  };
}
