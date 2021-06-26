{ callPackage }:

rec {
  steamUserInfo = import ./steam-user.nix;
  gameInfo = import ./game-info.nix;
  steamGameFetcher = callPackage ./game-files-fetcher.nix {};

  makeLinuxSteamGame = import ./make-linux-steam-game.nix {
    inherit steamGameFetcher callPackage;
  };
}
