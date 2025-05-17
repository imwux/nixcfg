{ pkgs, ... }:
{
    programs.bash = {
        historyFile = null;
        shellAliases = {
            c = "clear";
            la = "ls -a";
            ll = "ls -l";
            lla = "ls -la";

            grep = "grep --color=auto";

            # Rebuild NixOS
            rb = "sudo nixos-rebuild switch --flake /home/wux/nixcfg";

            # Edit sops secret file with ssh key
            esops = ''SOPS_AGE_KEY="$(cat ~/.ssh/id_ed25519 | ssh-to-age -private-key)" sops'';

            # Reset terminal cursor to a line
            rc = ''echo -ne "\e[5 q"'';
        };
        initExtra = ''
            case $(tty) in
            /dev/tty[0-9]*)
                PS1="\u@\h \w $ "
                ;;
            *)
                echo_list() {
                    IFS=""
                    ${pkgs.coreutils}/bin/echo -ne "$*"
                }

                escape() {
                    local VALUE=$(</dev/stdin)
                    ${pkgs.coreutils}/bin/echo -ne "\[$VALUE\]"
                }

                COL_RESET=$(${pkgs.ncurses}/bin/tput sgr0 | escape)
                COL_PRIMARY=$(${pkgs.ncurses}/bin/tput sgr0 bold setaf 11 | escape)
                COL_ERROR=$(${pkgs.ncurses}/bin/tput sgr0 bold setaf 1 | escape)
                COL_CWD=$(${pkgs.ncurses}/bin/tput sgr0 setaf 14 | escape)
                COL_BRANCH=$(${pkgs.ncurses}/bin/tput sgr0 setaf 9 | escape)
                COL_WORKSPACE=$(${pkgs.ncurses}/bin/tput sgr0 bold setaf 13 | escape)
                RESET_CURSOR=$(${pkgs.coreutils}/bin/echo -ne "\e[5 q" | escape)

                git_branch() {
                    ${pkgs.git}/bin/git branch 2> /dev/null | ${pkgs.gnused}/bin/sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
                }

                make_ps1() {
                    local COL_STATE=$COL_PRIMARY
                    if [ $1 -ne 0 ]; then
                        COL_STATE=$COL_ERROR
                    fi

                    local PARTS=(
                        $COL_STATE      "╭"
                        $COL_PRIMARY     " \u@\h"
                        $COL_CWD        " \w "
                        $COL_BRANCH     $(git_branch)
                        " "
                        $COL_WORKSPACE  $NIX_SHELL_NAME
                        "\n"
                        $COL_STATE      "╰ λ "
                        $COL_RESET
                    )

                    echo_list "''${PARTS[@]}"
                }

                PROMPT_COMMAND='PS1=$(make_ps1 $?)'
                ;;
            esac
        '';
    };
}
