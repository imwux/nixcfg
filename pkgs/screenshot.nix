{ pkgs, writeShellScriptBin, ... }:
writeShellScriptBin "screenshot" ''
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" -t ppm - | ${pkgs.satty}/bin/satty --filename -
''
