{ pkgs, writeShellScriptBin, ... }:
writeShellScriptBin "status" ''
    print_battery() {
        command -v upower >/dev/null 2>&1 || return 0

        local DEV="$(${pkgs.upower}/bin/upower -e | awk '/battery/ {print; exit}')"
        [[ -n "''${DEV:-}" ]] || return 1

        local INFO="$(upower -i "$DEV")"

        local STATE="$(awk -F': *' '/^[[:space:]]*state:/ {print $2; exit}' <<< "$INFO" || true)"
        local PCT="$(awk -F': *' '/^[[:space:]]*percentage:/ {print $2; exit}' <<< "$INFO" || true)"

        local TTE="$(awk -F': *' '/^[[:space:]]*time to empty:/ {print $2; exit}' <<< "$INFO" || true)"
        local TTF="$(awk -F': *' '/^[[:space:]]*time to full:/ {print $2; exit}' <<< "$INFO" || true)"
        local ETA=""
        if [[ "''${STATE:-}" == "discharging" && -n "''${TTE:-}" ]]; then
            ETA=" (ETA $TTE)"
        elif [[ "''${STATE:-}" == "charging" && -n "''${TTF:-}" ]]; then
            ETA=" (ETA $TTF)"
        fi

        printf '%s, %s%s\n' "''${STATE:-unknown}" "''${PCT:-unknown}" "$ETA"
    }

    echo -en "\033[1;36m"
    date '+%Y-%m-%d %H:%M:%S %Z'
    print_battery
    echo -en "\033[0m"
''
