{ makeSteamGame, steamUserInfo, gameInfo, gameFileInfo }:

makeSteamGame {
  inherit steamUserInfo;

  game = gameInfo {
    name = "Amorous";
    appId = "778700";
  };

  gameFiles = [
    (gameFileInfo {
      name = "Amorous";
      appId = "778700";
      depotId = "778704";
      manifestId = "1910947975998266938";
      hash = "Z1QvxH5rHMf40tP2v08SeMs3lbTVTWRETZ8Gr+u7RYo=";

      extraAction = ''
        chmod +x game/*.bin*
      '';
    })

    (gameFileInfo {
      name = "Amorous-Content";
      appId = "778700";
      depotId = "778701";
      manifestId = "9201582490132012031";
      hash = "LQPuw+aFzizBJbESj9LYNXl33TCk5ig9+qMsaTEiHw8=";
    })
  ];

  drvPath = ./wrapper.nix;
}
