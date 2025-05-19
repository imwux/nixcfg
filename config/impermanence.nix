{ ... }:
let
    passwordFile = "/persistent/password.txt";
in {
    users.mutableUsers = false;

    users.users.root.hashedPasswordFile = passwordFile;
    users.users.wux.hashedPasswordFile = passwordFile;
}
