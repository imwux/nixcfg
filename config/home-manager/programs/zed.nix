{ pkgs, ... }:
{
    programs.zed-editor = {
        package = pkgs.zed-editor-fhs;
        extensions = [ "vscode-dark-modern" "nix" "make" "toml" "scheme" "assembly" "meson"];
        userSettings = {
            theme = {
                mode = "dark";
                dark = "VSCode Dark Modern";
                light = "One Light";
            };

            tab_size = 4;

            format_on_save = "on";

            terminal.cursor_shape = "bar";

            edit_predictions.mode = "subtle";

            languages.Nix.language_servers = [ "nil" ];
            lsp.nil.binary.path = "${pkgs.nil}/bin/nil";
        };
    };
}
