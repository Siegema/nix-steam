{ protonWrapperScript, game, proton, lib, steamcmd, steam, writeText, steam-run, writeScript, writeScriptBin, gameFiles, lndir, steamUserInfo, fullCopy ? true, ... }:

writeScriptBin game.name ''
  ${
    protonWrapperScript {
      inherit game gameFiles proton lndir lib steamUserInfo steamcmd steam;
    }
  }
  ${lib.optionalString fullCopy ''
    if [[ ! -f "$HOME/games/${game.name}/.fullCopy" ]]; then
      rm -r $HOME/games/${game.name}/*
      cp -L -r ${gameFiles}/* $HOME/games/${game.name}/
      touch $HOME/games/${game.name}/.fullCopy
    fi
  ''}

  chmod -R +rw $HOME/games/${game.name}

  ${steam-run}/bin/steam-run ${writeScript "fix-${game.name}" ''
    cd $HOME/games/${game.name}/
    export WINEDLLOVERRIDES="dxgi=n" 
    export DXVK_HUD=1
    export WINEPREFIX=$HOME/.proton/pfx
    export STEAM_COMPAT_DATA_PATH=$HOME/.proton
    export STEAM_COMPAT_CLIENT_INSTALL_PATH=$HOME/.steam/steam

    $HOME/protons/${proton.name}/proton waitforexitandrun ./Tools/Launcher.exe -cluster:public -registry:Steam
  ''}
''
