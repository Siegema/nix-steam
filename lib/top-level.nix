{ callPackage }:

rec {
  steamUserInfo = import ./steam-user.nix;
  gameInfo = import ./game-info.nix;
  gameFileInfo = import ./game-file-info.nix;
  steamGameFetcher = callPackage ./game-files-fetcher.nix {};

  protonWrapperScript = { game, gameFiles, proton, lndir, lib, steamUserInfo, steamcmd, steam }: ''
    export SteamAppId=${game.appId}
    export HOME=/tmp/steam-test
    mkdir -p $HOME/{protons/${proton.name},.proton,games/${game.name}}
    ${steamcmd}/bin/steamcmd +exit
    ${lndir}/bin/lndir ${gameFiles} $HOME/games/${game.name}
    ${lndir}/bin/lndir ${proton} $HOME/protons/${proton.name}

    ${lib.optionalString steamUserInfo.useGuardFiles ''
    cp -r ${steamUserInfo.cachedFileDir}/* $HOME/.steam/steam
    ''}

    chmod -R +rw $HOME/.steam
    ${steamcmd}/bin/steamcmd +login ${steamUserInfo.username} ${steamUserInfo.password} +exit

    STEAM_RUNNING="$(pgrep steam -c)"

    if [[ $STEAM_RUNNING == 0 ]]; then
      (${steam}/bin/steam -silent -login ${steamUserInfo.username} ${steamUserInfo.password} &)
      sleep 30
    fi
  '';

  makeSteamGame = callPackage ./make-steam-game.nix {
    inherit steamGameFetcher callPackage protonWrapperScript;
  };
}
