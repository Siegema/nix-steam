{ steamUserInfo, helperLib }:

with helperLib;

{
  Antichamber = import ./antichamber { inherit steamUserInfo gameInfo gameFileInfo makeLinuxSteamGame; };
  Amorous = import ./amorous { inherit steamUserInfo gameInfo gameFileInfo makeLinuxSteamGame; };
  HigurashiCh6 = import ./higurashiCh6 { inherit steamUserInfo gameInfo gameFileInfo makeLinuxSteamGame; };
}
