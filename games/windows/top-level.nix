{ steamUserInfo, helperLib, proton }:

with helperLib;

let
  normalList = { inherit steamUserInfo gameInfo proton gameFileInfo makeSteamGame; };
in {
  SonicGenerations = import ./sonicGenerations normalList;
  JustCause = import ./justCause normalList;
  SleepingDogs = import ./sleepingDogs normalList;
  RocketLeague = import ./rocketLeague normalList;
  Warframe = import ./warframe normalList;
}
