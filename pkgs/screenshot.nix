{ pkgs, writeShellScriptBin, ... }:
writeShellScriptBin "screenshot" ''
    ${pkgs.grim}/bin/grim \
        -g "\$(${pkgs.slurp} -o -r -c '#ff0000ff')" \
        -t ppm - \
    | satty \
        --filename - \
        --fullscreen
''
