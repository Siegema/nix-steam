{ callPackage, steamGameFetcher, lib, symlinkJoin }:

{ steamUserInfo, game, gameFiles, drvPath }:
callPackage drvPath {
  inherit game steamUserInfo;
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
