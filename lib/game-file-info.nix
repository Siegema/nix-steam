{ name, appId, depotId, manifestId, platform ? "linux", extraAction ? "", hash }: {
  inherit name appId platform depotId manifestId extraAction hash;
}
