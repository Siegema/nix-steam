{ stdenv, lib, steamcmd, ...  }:

{ game, steamUserInfo, hash, ... } @ args:

stdenv.mkDerivation {
  name = "${game.name}-src";

  unpackPhase = "true";

  buildInputs = [
    steamcmd
  ];

  buildPhase = ''
    export HOME=$PWD
    mkdir -p $HOME/.steam/steam

    ${lib.optionalString steamUserInfo.useGuardFiles ''
    cp -r ${steamUserInfo.cachedFileDir}/* $HOME/.steam/steam
    ''}

    steamcmd +@sSteamCmdForcePlatformType ${game.platform} +login ${steamUserInfo.username} ${steamUserInfo.password} +force_install_dir $PWD/game +app_update ${game.appId} validate +exit
    rm -r game/steamapps
    rm game/steam_appid.txt || true
  '';

  installPhase = args.installPhase or ''
    mkdir -p $out
    cp -a game/* $out
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = hash;
}
