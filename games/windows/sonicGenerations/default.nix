{ makeSteamGame, steamUserInfo, gameInfo, proton, gameFileInfo }:

makeSteamGame {
  inherit steamUserInfo;

  game = gameInfo {
    name = "SonicGenerations";
    appId = "71340";
  };

  gameFiles = gameFileInfo {
    name = "SonicGenerations";
    platform = "windows";
    appId = "71340";
    depotId = "71341";
    manifestId = "190831558827569965";
    hash = "wEHntxAGS/p2dt/y6aABLCaZ5EHqIrAihV/OpOm6IRs=";
  };

  proton = proton.proton_6_3;

  drvPath = ./wrapper.nix;
}
