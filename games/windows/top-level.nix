{ steamUserInfo, helperLib, proton }:

with helperLib;

{
  SonicGenerations = import ./sonicGenerations { inherit steamUserInfo gameInfo proton gameFileInfo makeSteamGame; };
}
