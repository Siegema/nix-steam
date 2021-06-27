{ callPackage, steamGameFetcher, lib, symlinkJoin, protonWrapperScript, runCommand }:

{ steamUserInfo, game, gameFiles, drvPath, proton ? null }:

callPackage drvPath {
  inherit game steamUserInfo proton protonWrapperScript;
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
