{ enableAdult ? false, game, lib, steamcmd, steam-run, writeScript, writeScriptBin, gameFiles, steamUserInfo, lndir, ... }:

# Make sure you run it in a directory with no files
writeScriptBin game.name ''
  export SteamAppId=${game.appId}
  export HOME=/tmp/steam-test
  mkdir -p $HOME/games/${game.name}
  ${lndir}/bin/lndir ${gameFiles} $HOME/games/${game.name}
  chmod -R +rw $HOME/games/${game.name}
  unlink $HOME/games/${game.name}/Amorous.Game.Unix.bin.x86_64
  unlink $HOME/games/${game.name}/Amorous.Game.Unix
  cp -L ${gameFiles}/Amorous.Game.Unix $HOME/games/${game.name}/Amorous.Game.Unix
  cp -L ${gameFiles}/Amorous.Game.Unix.bin.x86_64 $HOME/games/${game.name}/Amorous.Game.Unix.bin.x86_64
  chmod +x $HOME/games/${game.name}/Amorous.Game.Unix*

  ${if enableAdult then ''
    touch $HOME/games/${game.name}/ShowMeSomeBooty.txt 
  '' else ''
    rm $HOME/games/${game.name}/ShowMeSomeBooty.txt
  ''}

  ${steamcmd}/bin/steamcmd +exit

  ${lib.optionalString steamUserInfo.useGuardFiles ''
    cp -r ${steamUserInfo.cachedFileDir}/* $HOME/.steam/steam
  ''}

  chmod -R +rw $HOME/.steam
  ${steamcmd}/bin/steamcmd +login ${steamUserInfo.username} ${steamUserInfo.password} +exit
  ${steam-run}/bin/steam-run ${writeScript "fix-${game.name}" ''
    export LD_LIBRARY_PATH=${gameFiles}/lib:${gameFiles}/lib64:$LD_LIBRARY_PATH
    export MONO_IOMAP=case
    cd $HOME/games/${game.name}
    exec ./Amorous.Game.Unix
  ''}
''
