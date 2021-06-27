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
    hash = "dKMeLT3yPtjEEPvSa4AExUjK9CX54yPUhgdvjYx8on4=";
  };

  proton = proton.proton_6_3;

  drvPath = ./wrapper.nix;
}
