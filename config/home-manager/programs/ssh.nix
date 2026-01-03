{ ... }:
{
    programs.ssh.matchBlocks = {
        "*".setEnv = {
            TERM = "xterm-256color";
        };
    };
}
