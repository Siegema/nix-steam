{ callPackage, steamUserInfo, helperLib }:

{
  linux = callPackage ./linux/top-level.nix {
    inherit steamUserInfo helperLib;
  };
}
