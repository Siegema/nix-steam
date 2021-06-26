{ game, lib, steamcmd, steam-run, writeScript, writeScriptBin, gameFiles, steamUserInfo, ... }:

# Make sure you run it in a directory with no files
writeScriptBin game.name ''
  export SteamAppId=${game.appId}
  ${steamcmd}/bin/steamcmd +exit

  ${lib.optionalString steamUserInfo.useGuardFiles ''
  cp -r ${steamUserInfo.cachedFileDir}/* $HOME/.steam/steam
  ''}

  chmod -R +rw $HOME/.steam
  ${steamcmd}/bin/steamcmd +login ${steamUserInfo.username} ${steamUserInfo.password} +exit
  ${steam-run}/bin/steam-run ${writeScript "fix-${game.name}" ''
    export LD_LIBRARY_PATH=${gameFiles}/Binaries/Linux/lib:$LD_LIBRARY_PATH
    cd ${gameFiles}/Binaries/Linux
    ./UDKGame-Linux
  ''}
''
