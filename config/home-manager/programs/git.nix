{ ... }:
{
    programs.git = {
        settings = {
            user = {
                name = "WuX";
                email = "wux@thenest.dev";
            };

            gpg.format = "ssh";

            alias = {
                rewrite-commits = ''!f() { VAR=$1; OLD=$2; NEW=$3; shift 3; git filter-branch --env-filter "if [[ \"$`echo $VAR`\" = '$OLD' ]]; then export $VAR='$NEW'; fi" $@; }; f '';
            };
        };

        signing = {
            key = "~/.ssh/id_ed25519.pub";
            signByDefault = true;
        };
    };
}
