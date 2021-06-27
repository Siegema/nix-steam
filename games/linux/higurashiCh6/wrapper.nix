{ game, lib, steamcmd, steam-run, writeScript, writeScriptBin, gameFiles, steamUserInfo, symlinkJoin, ... }:

let
  gameExec = symlinkJoin {
    name = "${game.name}-exec";

    paths = [ gameFiles ];

    postBuild = ''
      unlink $out/HigurashiEp06.x86	
      cp ${gameFiles}/HigurashiEp06.x86 $out/HigurashiEp06.x86	
      chmod +x $out/HigurashiEp06.x86
    '';
  };
in writeScriptBin game.name ''
  export SteamAppId=${game.appId}
  export HOME=/tmp/steam-test
  ${steamcmd}/bin/steamcmd +exit

  ${lib.optionalString steamUserInfo.useGuardFiles ''
  cp -r ${steamUserInfo.cachedFileDir}/* $HOME/.steam/steam
  ''}

  chmod -R +rw $HOME/.steam
  ${steamcmd}/bin/steamcmd +login ${steamUserInfo.username} ${steamUserInfo.password} +exit
  ${steam-run}/bin/steam-run ${writeScript "fix-${game.name}" ''
    cd ${gameExec}
    exec ./HigurashiEp06.x86	
  ''}
''
