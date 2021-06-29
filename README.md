# Nix Steam System

## What is Nix-Steam

nix-steam is a nix repo that contains steam games in both Linux and Windows(via proton) to install and run declaratively in Linux distros(both nixos, and non-nixos)

**It is experimental and constant improvement will be happening**

## Requirements

- it need to support cgroup due to steam-run

- it need the `ca-derivation` and `recursive-nix` features of your nix configuration


## Logging in for Steam

### No SteamGuard

without steamguard is pretty straightforward

```nix
let 
  defaultNix = (import ../default.nix {}).defaultNix;
in (defaultNix.makeSteamStore.x86_64-linux {
  username = "<username>";
  password = "<password>";
  useGuardFiles = false;
})
```

### With SteamGuard

with steamguard enabled, you will need to get two file sets(one time per machine)

1. files from running a basic steamcmd +login 

```
$HOME/.steam/steam/config/config.vdf
$HOME/.steam/steam/config/libraryfolders.vdf
$HOME/.steam/steam/ssfn*
```

2. folder from running a basic depotdownloader -username -password

```
$HOME/.local/share/IsolatedStorage
```

after you have these files, you can login via this

```nix
let 
  defaultNix = (import ../nix-steam/default.nix {}).defaultNix;
in (defaultNix.makeSteamStore.x86_64-linux {
  username = "<username>";
  password = "<password>";
  useGuardFiles = true;
  cachedFileDir = <path-to>/steamFiles;
  depotdownloaderStorage = <path-to>/IsolatedStorage;
})
```

## Adding a Game(Linux/Windows)

### Step 1: SteamDB is your friend

Steam game are made from single/multiple depots, this normally happen in the background for both normal steam download and steamcmd +app_update command, however since we want locking, we have to construct the games ourself.

#### Find info of game and depot

we will use [Helltaker](https://steamdb.info/app/1289310) as a example

first we need to find out what depots it have, which can be found under the [Depots](https://steamdb.info/app/1289310/depots/) section, we see there are two depots that we need(logically), `Helltaker Content Linux` and `Helltaker Local`.

we will have the following the template

```nix
{ makeSteamGame, steamUserInfo, gameInfo, gameFileInfo }:

makeSteamGame {
  inherit steamUserInfo;

  game = gameInfo {
    name = "Helltaker";
    appId = "1289310"; # You can findout the appId from the steamdb page
  };

  gameFiles = [
  ];

  drvPath = ./wrapper.nix;

  # proton = proton.<version> # This option is only for Windows game
}
```

#### Construct Depots

the `gameFiles` param accept either a list or a single entry, for games with a singular or multiple depots

now lets construct with depots

both depotid and manifestid can be found on their own page

- [Helltaker Content Linux](https://steamdb.info/depot/1289314/) DepotId: 1289314, ManifestId: 8723838119065609357
- [Helltaker Local](https://steamdb.info/depot/1289315/) DepotId: 1289315, ManifestId: 8723838119065609357

```nix
{ makeSteamGame, steamUserInfo, gameInfo, gameFileInfo }:

makeSteamGame {
  inherit steamUserInfo;

  game = gameInfo {
    name = "Helltaker";
    appId = "1289310";
  };

  gameFiles = [
    (gameFileInfo {
      name = "Helltaker";
      appId = "1289310"; # same AppId from above
      depotId = "1289314";
      manifestId = "8723838119065609357";
      hash = "";
      # platform = "windows"; # This option is only for Windows game
    })

    (gameFileInfo {
      name = "Helltaker-Local";
      appId = "1289310"; # same AppId from above
      depotId = "1289315";
      manifestId = "6394422377711576735";
      hash = "";
      # platform = "windows"; # This option is only for Windows game
    })
  ];

  drvPath = ./wrapper.nix;
  # proton = proton.<version> # This option is only for Windows game
}
```

#### Build Hashes

now we are ready to get the hashes

run it with `nix-build --max-jobs 1`, once it finish, fill it in, rerun it(it will trigger another build to make it content addressed)

to end up with this

```nix
{ makeSteamGame, steamUserInfo, gameInfo, gameFileInfo }:

makeSteamGame {
  inherit steamUserInfo;

  game = gameInfo {
    name = "Helltaker";
    appId = "1289310";
  };

  gameFiles = [
    (gameFileInfo {
      name = "Helltaker";
      appId = "1289310";
      depotId = "1289314";
      manifestId = "8723838119065609357";
      hash = "M0f1etPT2RvFP5iyJtWAje2C5BENQZqopiQzsGCa8lw=";
    })

    (gameFileInfo {
      name = "Helltaker-Local";
      appId = "1289310";
      depotId = "1289315";
      manifestId = "6394422377711576735";
      hash = "kKSwK5mGr4IhjPB4PcK26U7GacDUravU5wtOsNs8VMI=";
    })
  ];

  drvPath = ./wrapper.nix;
}
```

### Step 2: Wrapper time

for most games the wrapper following a similar template of these

the information about launcher can be found under [Configuration](https://steamdb.info/app/1289310/config/) section

#### Linux Games

```nix
{ game, lib, steamcmd, steam-run-native, writeScript, writeScriptBin, gameFiles, steamUserInfo, lndir, ... }:

writeScriptBin game.name ''
  export SteamAppId=${game.appId}
  export HOME=/tmp/steam-test
  ${steamcmd}/bin/steamcmd +exit

  mkdir -p $HOME/games/${game.name}

  ${lndir}/bin/lndir ${gameFiles} $HOME/games/${game.name}
  chmod -R +rw $HOME/games/${game.name}
  rm $HOME/games/${game.name}/<binary>	
  cp -L ${gameFiles}/<binary> $HOME/games/${game.name}/
  chmod +rwx $HOME/games/${game.name}/<binary>

  ${lib.optionalString steamUserInfo.useGuardFiles ''
    cp -r ${steamUserInfo.cachedFileDir}/* $HOME/.steam/steam
  ''}

  chmod -R +rw $HOME/.steam
  ${steamcmd}/bin/steamcmd +login ${steamUserInfo.username} ${steamUserInfo.password} +exit
  ${steam-run-native}/bin/steam-run ${writeScript "fix-${game.name}" ''
    cd $HOME/games/${game.name}/
    exec ./<binary>
  ''}
''
```

#### Windows Games

```nix
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

    $HOME/protons/${proton.name}/proton waitforexitandrun ./<exe>	
  ''}
''
```

Of course, you can do anything you want in the wrapper for game-specific fixes or feature setting

### Step 3: Add it to packages list

Lastly, make sure you have the new game under the platform's top-level.nix

## Caveats

- due to a bug/issue(not sure what is causing it), it will require double build for the hash getting process(not the actual game building/installing part)

- right now the password is plaintext in the running process, hopefully there will be a improvement via read file or other method

- some games, especially multiplayer/mmo games require double space due to those games do checking for updates against the assets which won't be possible via symlink

- right now the target folder for is at /tmp/steam-test this will become a param later on

- due to steam restriction, it need to be run with --max-jobs 1
