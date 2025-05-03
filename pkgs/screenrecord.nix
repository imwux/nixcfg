{ pkgs, writeShellScriptBin, ... }:
writeShellScriptBin "screenrecord" ''
    ${pkgs.wf-recorder}/bin/wf-recorder -g "$(${pkgs.slurp}/bin/slurp -c '#ff0000ff')"
''
