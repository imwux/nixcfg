{ pkgs, ... }:
{
    programs.zed-editor = {
        package = pkgs.unstable.zed-editor;
        extensions = [ "nix" "make" "toml" "scheme" "assembly" "meson"];
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

            languages = {
                Meson.enable_language_server = false;
                Nix.language_servers = [ "nil" ];
            };

            lsp.clangd.binary.path = "${pkgs.llvmPackages_19.clang-tools}/bin/clangd";
            lsp.rust-analyzer.binary.path = "${pkgs.rust-analyzer}/bin/rust-analyzer";
            lsp.lua-language-server.binary.path = "${pkgs.lua-language-server}/bin/lua-language-server";
            lsp.pylsp.binary.path = "${pkgs.python312Packages.python-lsp-server}/bin/pylsp";
            lsp.nil.binary.path = "${pkgs.nil}/bin/nil";
        };
    };
}
