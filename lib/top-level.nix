{ callPackage }:

rec {
  steamUserInfo = import ./steam-user.nix;
  gameInfo = import ./game-info.nix;
  gameFileInfo = import ./game-file-info.nix;
  steamGameFetcher = callPackage ./game-files-fetcher.nix {};

  makeLinuxSteamGame = callPackage ./make-linux-steam-game.nix {
    inherit steamGameFetcher callPackage;
  };
}
