let 
  defaultNix = (import ./default.nix {}).defaultNix;
in (defaultNix.makeSteamStore.x86_64-linux {
  username = "test";
  password = "test";
  useGuardFiles = false;
}).linux.Antichamber
