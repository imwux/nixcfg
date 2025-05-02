{ ... }:
{
    programs.git = {
        userName = "WuX";
        userEmail = "wux@thenest.dev";
        aliases = {
            rewrite-commits = ''!f() { VAR=$1; OLD=$2; NEW=$3; shift 3; git filter-branch --env-filter "if [[ \"$`echo $VAR`\" = '$OLD' ]]; then export $VAR='$NEW'; fi" $@; }; f '';
        };
        extraConfig.gpg.format = "ssh";
        signing = {
            key = "~/.ssh/id_ed25519.pub";
            signByDefault = true;
        };
    };
}
