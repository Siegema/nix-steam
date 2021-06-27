{ callPackage, steamGameFetcher, lib, symlinkJoin, protonWrapperScript, linkFarm, runCommand }:

{ steamUserInfo, game, gameFiles, drvPath, proton ? null }:

callPackage drvPath {
  inherit game steamUserInfo proton protonWrapperScript;
  gameFiles = if !(lib.isList gameFiles) then linkFarm "${gameFiles.name}-linkfarm" (builtins.fromJSON (builtins.readFile "${steamGameFetcher {
    inherit steamUserInfo;
    game = gameFiles;
  }}/paths.json")) else symlinkJoin {
    name = "${game.name}-files";

    paths = lib.forEach gameFiles (gameFile:
    (linkFarm "${gameFile.name}-linkfarm" (builtins.fromJSON (builtins.readFile("${steamGameFetcher {
      inherit steamUserInfo;
      game = gameFile;
    }}/paths.json")))));
  };
}
