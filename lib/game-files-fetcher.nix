{ stdenv, lib, cacert, depotdownloader, ...  }:

{ game, steamUserInfo, ... }:

stdenv.mkDerivation {
  name = "${game.name}-src";

  installPhase = game.installPhase;

  unpackPhase = "true";

  buildInputs = [
    cacert
    depotdownloader
  ];

  buildPhase = ''
    export HOME=$PWD
    mkdir -p $HOME/.local/share/IsolatedStorage
    cp -r ${steamUserInfo.depotdownloaderStorage}/* $HOME/.local/share/IsolatedStorage/
    chmod -R +rw $HOME/.local/share/IsolatedStorage/

    depotdownloader -os ${game.platform} -username ${steamUserInfo.username} -password ${steamUserInfo.password} -dir $PWD/game -app ${game.appId} -depot ${game.depotId} -manifest ${game.manifestId}
    rm -r game/.DepotDownloader
  '';

  dontMoveLib64 = true;
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = game.hash;
}
