{ makeSteamGame, steamUserInfo, gameInfo, proton, gameFileInfo }:

makeSteamGame {
  inherit steamUserInfo;

  game = gameInfo {
    name = "SleepingDogs";
    appId = "307690";
  };

  gameFiles = [
    (gameFileInfo {
      name = "SleepingDogs-Exec";
      platform = "windows";
      appId = "307690";
      depotId = "307693	";
      manifestId = "521771309705279162";
      hash = "AhXlPKgy5K8C0l3vLyOEDJ25yOeK4QxSW6Ik0teL0i8=";
    })

    (gameFileInfo {
      name = "SleepingDogs-UI";
      platform = "windows";
      appId = "307690";
      depotId = "307692";
      manifestId = "8969342104525223947";
      hash = "MELY+vXmzZ2OUZAqGMPzTHD+W4yD5HZ3p0H9kYwSu60=";
    })

    (gameFileInfo {
      name = "SleepingDogs-Content";
      platform = "windows";
      appId = "307690";
      depotId = "307691";
      manifestId = "1259773366995347002";
      hash = "z2oMoFT+Yevp0TlrF7wvNVgRLohXtlAg7RiEMTAlvJg=";
    })
  ];

  proton = proton.proton_6_3;

  drvPath = ./wrapper.nix;
}
