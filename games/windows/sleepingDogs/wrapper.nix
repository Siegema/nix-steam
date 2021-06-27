{ game, proton, lib, steamcmd, steam, steam-run, writeScript, writeScriptBin, gameFiles, lndir, steamUserInfo, protonWrapperScript, ... }:

writeScriptBin game.name ''
  ${
    protonWrapperScript {
      inherit game gameFiles proton lndir lib steamUserInfo steamcmd steam;
    }
  }

  ${steam-run}/bin/steam-run ${writeScript "fix-${game.name}" ''
    cd $HOME/games/${game.name}
    export WINEDLLOVERRIDES="dxgi=n" 
    export DXVK_HUD=1
    export WINEPREFIX=$HOME/.proton/pfx
    export STEAM_COMPAT_DATA_PATH=$HOME/.proton
    export STEAM_COMPAT_CLIENT_INSTALL_PATH=$HOME/.steam/steam

    $HOME/protons/${proton.name}/proton waitforexitandrun ./SDHDShip.exe	
  ''}
''
