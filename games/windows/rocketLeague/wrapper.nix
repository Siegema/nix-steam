{ protonWrapperScript, game, proton, lib, steamcmd, steam, writeText, steam-run, writeScript, writeScriptBin, gameFiles, lndir, steamUserInfo, ... }:

writeScriptBin game.name ''
  ${
    protonWrapperScript {
      inherit game gameFiles proton lndir lib steamUserInfo steamcmd steam;
    }
  }

  rm -r $HOME/games/${game.name}/Engine/*
  cp -L -r ${gameFiles}/Engine/* $HOME/games/${game.name}/Engine/

  rm -r $HOME/games/${game.name}/TAGame/Config/*
  cp -L -r ${gameFiles}/TAGame/Config/* $HOME/games/${game.name}/TAGame/Config/

  chmod -R +rw $HOME/games/${game.name} 

  ${steam-run}/bin/steam-run ${writeScript "fix-${game.name}" ''
    cd $HOME/games/${game.name}/Binaries/Win64
    export WINEDLLOVERRIDES="dxgi=n" 
    export DXVK_HUD=1
    export WINEPREFIX=$HOME/.proton/pfx
    export STEAM_COMPAT_DATA_PATH=$HOME/.proton
    export STEAM_COMPAT_CLIENT_INSTALL_PATH=$HOME/.steam/steam

    $HOME/protons/${proton.name}/proton waitforexitandrun ./RocketLeague.exe		
  ''}
''
