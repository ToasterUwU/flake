let
  aki = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMV93pUyoE8y3oFfFrgPaaObAP7J9O7aChY1gIWKKTMS aki@Barbara"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGAI3RboKHBPPLvDuHEkWHIj+/qZpsS4Ae80Hheoj8wK aki@Gertrude"
  ];
  scarlett = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILrcpx3MX+MeCd/gBsBhnLH3DfaLwkPKWyIB0WgFu8Rm scarlett@Barbara"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICBjBHIPZLCX+F6Crm/B9m09YTOUZJzMdH69zgCbqsZR scarlett@Gertrude"
  ];
  users = aki ++ scarlett;

  Barbara = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEivYBAuarGiTOHscBYXP0LpG6RGCUDjzDCc/5lT+5sZ";
  Gertrude = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIy9n203h4Qwj7qcWXTsMl9cbkc7wBoSA5o5u9l9gqwk";
  systems = [ Barbara Gertrude ];
in
{
  "secrets/common/aki-password.age".publicKeys = aki ++ systems;
  "secrets/common/scarlett-password.age".publicKeys = users ++ systems;
}
