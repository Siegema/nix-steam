{ makeSteamGame, steamUserInfo, gameInfo, proton, gameFileInfo }:

makeSteamGame {
  inherit steamUserInfo;

  game = gameInfo {
    name = "SleepingDogs";
    appId = "307690";
  };

  gameFiles = [
#    (gameFileInfo {
#      name = "SleepingDogs-Exec";
#      platform = "windows";
#      appId = "307690";
#      depotId = "307693	";
#      manifestId = "521771309705279162";
#      hash = "";
#    })
#
#    (gameFileInfo {
#      name = "SleepingDogs-UI";
#      platform = "windows";
#      appId = "307690";
#      depotId = "307692";
#      manifestId = "8969342104525223947";
#      hash = "";
#    })

    (gameFileInfo {
      name = "SleepingDogs-Content";
      platform = "windows";
      appId = "307690";
      depotId = "307691";
      manifestId = "1259773366995347002";
      hash = "";
    })
  ];

  proton = proton.proton_6_3;

  drvPath = ./wrapper.nix;
}
