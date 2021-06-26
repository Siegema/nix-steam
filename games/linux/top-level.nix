{ steamUserInfo, helperLib }:

with helperLib;

{
  Antichamber = import ./antichamber { inherit steamUserInfo gameInfo makeLinuxSteamGame; };
}
