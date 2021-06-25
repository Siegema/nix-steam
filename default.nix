with import <nixpkgs> {};

let
  game = "Antichamber";
  appId = "219890";
  launchFile = "Binaries/Linux/UDKGame-Linux";
  username = "juliosueiras";
  password = "";
  steamFilesDir = ./steamFiles;

  gameFiles = stdenv.mkDerivation {
    name = game;

    unpackPhase = "true";

    buildPhase = ''
      export HOME=$PWD
      mkdir -p $HOME/.steam/steam
      cp -r ${steamFilesDir}/* $HOME/.steam/steam
      steamcmd +login ${username} ${password} +force_install_dir $PWD/game +app_update ${appId} validate +exit
      rm -r game/steamapps
      rm game/steam_appid.txt || true
    '';

    installPhase = ''
      mkdir -p $out
      cp -a game/* $out
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "33d5450cd967e267722b39a660a1d6074235722da7adbdef2cf3f4a8f023c273";
  };
in writeScriptBin game ''
  export SteamAppId=${appId}
  export HOME=/tmp/steam-test
  ${steam-run}/bin/steam-run ${gameFiles}/${launchFile}
''
