{ makeSteamGame, proton, steamUserInfo, gameInfo, gameFileInfo }:

makeSteamGame {
  inherit steamUserInfo;

  game = gameInfo {
    name = "RocketLeague";
    appId = "252950";
  };

  gameFiles = gameFileInfo {
    name = "RocketLeague";
    appId = "252950";
    platform = "windows";
    depotId = "252951";
    manifestId = "2273576982621900744";
    hash = "xDeGDqdAW6c7kYkSJWTOTR4Ff0HXuPSfLXb1xQT7Y5I=";
  };

  proton = proton.proton_6_3;

  drvPath = ./wrapper.nix;
}
