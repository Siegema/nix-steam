{ makeLinuxSteamGame, steamUserInfo, gameInfo }:

makeLinuxSteamGame {
  inherit steamUserInfo;

  game = gameInfo {
    appId = "219890";
    name = "Antichamber";
  };

  drvPath = ./wrapper.nix;

  hash = "wlHfcucp9/BVAYILtwH1kwkjMNpfyXNjYyJXTOlujkM=";

  installPhase = ''
    mkdir -p $out
    cp -a game/* $out
    cd $out/Binaries/Linux/lib/
    rm libogg.so libvorbis* libSDL2-2.0.so.0
  '';
}
