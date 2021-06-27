{ makeSteamGame, steamUserInfo, gameInfo, proton, gameFileInfo }:

makeSteamGame {
  inherit steamUserInfo;

  game = gameInfo {
    name = "JustCause";
    appId = "6880";
  };

  gameFiles = [
    (gameFileInfo {
      name = "JustCause-Binaries";
      platform = "windows";
      appId = "6880";
      depotId = "6881";
      manifestId = "6527771220312814148";
      hash = "yOh6xHkRG+FCKHnMkEF1o9/gNGPRKt37Tr8EHcUxyiE=";
    })

    (gameFileInfo {
      name = "JustCause-FMV1";
      platform = "windows";
      appId = "6880";
      depotId = "6882";
      manifestId = "4589612640979803544";
      hash = "3OCJN7p4mfJtnJa7T98kt9xNoabPD36ls7WlJ/qOibQ=";
    })

    (gameFileInfo {
      name = "JustCause-FMV2";
      platform = "windows";
      appId = "6880";
      depotId = "6883";
      manifestId = "4806707053551780261";
      hash = "N+tCrxPwfcTsEt+JfB8SsBV4jM9B0DLL7mqLpz+fGAM=";
    })

    (gameFileInfo {
      name = "JustCause-PC01";
      platform = "windows";
      appId = "6880";
      depotId = "6888";
      manifestId = "70519445597708639";
      hash = "xma8Gr6NXehe8guEl15htxlOL/gznYaIus8X7ykB6hM=";
    })

    (gameFileInfo {
      name = "JustCause-PC02";
      platform = "windows";
      appId = "6880";
      depotId = "6889";
      manifestId = "6899635947800562820";
      hash = "7ENcnf9cwDF/39EgGmkv6Xt83t6vfMkkq+1sHDNJc1A=";
    })

    (gameFileInfo {
      name = "JustCause-PC03";
      platform = "windows";
      appId = "6880";
      depotId = "6890";
      manifestId = "332007685201679804";
      hash = "i0l5N4lVQlR7izPL00XMzQeAcRXGSbNhcCZ//2lX6q0=";
    })

    (gameFileInfo {
      name = "JustCause-PC04";
      platform = "windows";
      appId = "6880";
      depotId = "6891";
      manifestId = "4619176749946730386";
      hash = "kfZdy9BEwsp1Vr6er/OFFZP7IPyy45bqsw/RyyfF0bk=";
    })
  ];

  proton = proton.proton_6_3;

  drvPath = ./wrapper.nix;
}
