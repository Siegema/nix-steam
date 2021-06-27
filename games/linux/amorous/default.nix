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
      hash = "bgMK4ookHvywLLier2SbXJtUILz+MnnkwfrzPhXCi7E=";

      installPhase = ''
        mkdir -p $out
        cp -a game/* $out
        chmod +x $out/*.bin*
      '';
    })

    (gameFileInfo {
      name = "Amorous-Content";
      appId = "778700";
      depotId = "778701";
      manifestId = "9201582490132012031";
      hash = "pKcl7Fqq9JHuEF6pHwJvNzx9O+mpeT7/hlBHZzaCJ1o=";
    })
  ];

  drvPath = ./wrapper.nix;
}
