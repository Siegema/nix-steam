{ callPackage, steamUserInfo, helperLib }:

rec {
  linux = callPackage ./linux/top-level.nix {
    inherit steamUserInfo helperLib;
  };

  proton = callPackage ./proton/top-level.nix {
    inherit steamUserInfo helperLib;
  };

  windows = callPackage ./windows/top-level.nix {
    inherit steamUserInfo helperLib proton;
  };
}
