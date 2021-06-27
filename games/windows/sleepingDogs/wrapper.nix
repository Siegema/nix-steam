{ game, proton, curl, lib, steamcmd, steam, steam-run, winetricks, wineWowPackages, writeScript, writeScriptBin, gameFiles, lndir, steamUserInfo, protonWrapperScript, ... }:

writeScriptBin game.name ''
  ${
    protonWrapperScript {
      inherit game gameFiles proton lndir lib steamUserInfo steamcmd steam;
    }
  }

  if [[ ! -f $HOME/games/${game.name}/data/DisplaySettings.xml ]]; then
    rm -r $HOME/games/${game.name}/data
    cp -L -r ${gameFiles}/data $HOME/games/${game.name}/
  fi

  unlink $HOME/games/${game.name}/sdhdship.exe
  cp -L ${gameFiles}/sdhdship.exe $HOME/games/${game.name}/

  unlink $HOME/games/${game.name}/buildlab.defaults.dat
  cp -L ${gameFiles}/buildlab.defaults.dat $HOME/games/${game.name}/

  rm -r $HOME/games/${game.name}/buildlab.project.dat
  cp -L ${gameFiles}/buildlab.project.dat $HOME/games/${game.name}/

  rm -r $HOME/games/${game.name}/UserOptions.dat
  cp -L ${gameFiles}/UserOptions.dat $HOME/games/${game.name}/

  rm -r $HOME/games/${game.name}/*.txt
  cp -L ${gameFiles}/*.txt $HOME/games/${game.name}/

  rm -r $HOME/games/${game.name}/reflection.rdb
  cp -L ${gameFiles}/reflection.rdb $HOME/games/${game.name}/

  rm -r $HOME/games/${game.name}/*.vdf
  cp -L ${gameFiles}/*.vdf $HOME/games/${game.name}/

  rm -r $HOME/games/${game.name}/redist
  cp -L -r ${gameFiles}/redist $HOME/games/${game.name}/

  rm -r $HOME/games/${game.name}/*.bix
  cp -L -r ${gameFiles}/*.bix $HOME/games/${game.name}/

  rm -r $HOME/games/${game.name}/Global.big
  cp -L -r ${gameFiles}/Global.big $HOME/games/${game.name}/

  chmod -R +rw $HOME/games/${game.name}

  cp ${./DisplaySettings.xml} $HOME/games/${game.name}/data/DisplaySettings.xml

  export WINEPREFIX=$HOME/.proton/pfx

  ${steam-run}/bin/steam-run ${writeScript "fix-${game.name}" ''
    cd $HOME/games/${game.name}
    export WINEDLLOVERRIDES="dxgi=n" 
    export DXVK_HUD=1
    export WINEDEBUG=+treeview
    export STEAM_COMPAT_DATA_PATH=$HOME/.proton
    export STEAM_COMPAT_CLIENT_INSTALL_PATH=$HOME/.steam/steam
    $PROTON_HOME/proton waitforexitandrun vcredist_x64.exe
    $PROTON_HOME/proton waitforexitandrun ./SDHDShip.exe	
  ''}
''
