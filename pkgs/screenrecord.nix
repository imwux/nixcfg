{ pkgs, writeShellScriptBin, ... }:
writeShellScriptBin "screenrecord" ''
    ${pkgs.wf-recorder}/bin/wf-recorder -g "$(${pkgs.slurp}/bin/slurp)" -m mp4 --file="''${1:-recording.mp4}"
''
