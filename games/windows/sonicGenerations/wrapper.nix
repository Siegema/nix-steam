{ game, proton, lib, steamcmd, steam, writeText, steam-run, writeScript, writeScriptBin, gameFiles, lndir, steamUserInfo, ... }:

let
  sonicReg = writeText "sonic-generation.reg" ''
REGEDIT4

[HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Sega]

[HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Sega\Sonic Generations]
"locale"="en-us"
"SaveLocation"="%UserProfile%\\Saved Games\\Sonic Generations"
  '';
in writeScriptBin game.name ''
  export SteamAppId=${game.appId}
  export HOME=/tmp/steam-test
  mkdir -p $HOME/{protons/${proton.name},.proton,games/${game.name}}
  ${steamcmd}/bin/steamcmd +exit
  ${lndir}/bin/lndir ${gameFiles} $HOME/games/${game.name}
  ${lndir}/bin/lndir ${proton} $HOME/protons/${proton.name}

  ${lib.optionalString steamUserInfo.useGuardFiles ''
  cp -r ${steamUserInfo.cachedFileDir}/* $HOME/.steam/steam
  ''}

  chmod -R +rw $HOME/.steam
  ${steamcmd}/bin/steamcmd +login ${steamUserInfo.username} ${steamUserInfo.password} +exit

  STEAM_RUNNING="$(pgrep steam -c)"

  if [[ $STEAM_RUNNING == 0 ]]; then
    ${steam}/bin/steam -silent -login ${steamUserInfo.username} ${steamUserInfo.password} &
    sleep 30
  fi

  ${steam-run}/bin/steam-run ${writeScript "fix-${game.name}" ''
    cd $HOME/games/${game.name}
    export WINEDLLOVERRIDES="dxgi=n" 
    export DXVK_HUD=1
    export WINEPREFIX=$HOME/.proton/pfx
    export STEAM_COMPAT_DATA_PATH=$HOME/.proton
    export STEAM_COMPAT_CLIENT_INSTALL_PATH=$HOME/.steam/steam

    # Audio fix
    export PROTON_NO_ESYNC=1 PROTON_USE_D9VK=1

    $HOME/protons/${proton.name}/proton waitforexitandrun regedit.exe ${sonicReg}
    $HOME/protons/${proton.name}/proton waitforexitandrun ./ConfigurationTool.exe	
    $HOME/protons/${proton.name}/proton waitforexitandrun ./SonicGenerations.exe	
  ''}
''
