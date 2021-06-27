{ runCommand, jq, nixUnstable, lib, cacert, depotdownloader, ...  }:

{ game, steamUserInfo, ... }:

runCommand "${game.name}-links" {

  preferLocalBuild = true;
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = game.hash;
  requiredSystemFeatures = [ "recursive-nix" ];

  buildInputs = [
    jq
    nixUnstable
    cacert
    depotdownloader
  ];
} ''
    export HOME=$PWD
    mkdir -p $HOME/.local/share/IsolatedStorage
    cp -r ${steamUserInfo.depotdownloaderStorage}/* $HOME/.local/share/IsolatedStorage/
    chmod -R +rw $HOME/.local/share/IsolatedStorage/

    depotdownloader -os ${game.platform} -username ${steamUserInfo.username} -password ${steamUserInfo.password} -dir $PWD/game -app ${game.appId} -depot ${game.depotId} -manifest ${game.manifestId}
    rm -r game/.DepotDownloader

    ${game.extraAction}
  
    mkdir -p $out
    cd game

    find * -type f -exec bash -c 'echo "{ \"name\": \"{}\", \"path\": \"$(file="{}"; nix store add-file --name $(basename "{}" | sed "s/[^a-zA-Z]*//g") "$file")\" }"' \; >> $out/paths.json
    cat $out/paths.json | jq -s '.' > temp
    mv temp $out/paths.json
''
