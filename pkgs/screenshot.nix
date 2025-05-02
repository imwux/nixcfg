{ pkgs, writeShellScriptBin, ... }:
writeShellScriptBin "screenshot" ''
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -c '#ff0000ff')" -t ppm - | ${pkgs.satty}/bin/satty --filename -
''
