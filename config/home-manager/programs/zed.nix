{ pkgs, ... }:
{
    programs.zed-editor = {
        package = pkgs.unstable.zed-editor;
        extensions = [
            "vscode-dark-modern"
            "git-firefly"
            "nix"
            "make"
            "toml"
            "scheme"
            "assembly"
            "meson"
            "lua"
        ];
        userSettings = {
            theme = {
                mode = "dark";
                dark = "VSCode Dark Modern";
                light = "One Light";
            };

            features.edit_prediction_provider = "none";

            tab_size = 4;
            format_on_save = "on";
            terminal.cursor_shape = "bar";

            minimap.show = "always";

            "experimental.theme_overrides" = {
                "background.appearance" = "blurred";
                "background" = "#1F1F1FF0";
                "editor.background" = "#00000000";
                "editor.gutter.background" = "#00000000";
                "editor.active_line.background" = "#212121F0";
            };

            debugger.dock = "right";

            languages.Nix.language_servers = [
                "nil"
                "!nixd"
            ];

            lsp.nil = {
                binary.path = "${pkgs.nil}/bin/nil";
                initialization_options = {
                    formatting = {
                        command = [
                            "${pkgs.nixfmt-rfc-style}/bin/nixfmt"
                            "--indent=4"
                            "--width=200"
                        ];
                    };
                };
            };
            lsp.clangd.binary.path = "${pkgs.llvmPackages_19.clang-tools}/bin/clangd";
            lsp.rust-analyzer.binary.path = "${pkgs.rust-analyzer}/bin/rust-analyzer";
            lsp.lua-language-server.binary.path = "${pkgs.lua-language-server}/bin/lua-language-server";
            lsp.pylsp.binary.path = "${pkgs.python312Packages.python-lsp-server}/bin/pylsp";
            lsp.ols.binary.path = "${pkgs.ols}/bin/ols";
            lsp.gopls.binary.path = "${pkgs.gopls}/bin/gopls";
            lsp.asm-lsp.binary.path = "${pkgs.asm-lsp}/bin/asm-lsp";
            lsp.ruff.binary = {
                path = "${pkgs.ruff}/bin/ruff";
                arguments = [ "server" ];
            };
            lsp.basedpyright.binary = {
                path = "${pkgs.basedpyright}/bin/basedpyright-langserver";
                arguments = [ "--stdio" ];
            };
            lsp.package-version-server.enabled = false;
        };
        userKeymaps = [
            {
                context = "Editor";
                bindings = {
                    "ctrl-alt-down" = "editor::AddSelectionBelow";
                    "ctrl-alt-up" = "editor::AddSelectionAbove";
                    "alt-shift-up" = "editor::DuplicateLineUp";
                    "alt-shift-down" = "editor::DuplicateLineDown";
                };
            }
        ];
    };
}
