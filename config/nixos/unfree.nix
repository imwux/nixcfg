{ lib, config, ... }:
let
    inherit (lib)
        mkOption
        types;
in {
    options = {
        unfree = mkOption {
            type = types.listOf types.str;
            default = [];
            description = "List of allowed unfree packages";
        };
    };

    config = {
        nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.unfree;
    };
}
