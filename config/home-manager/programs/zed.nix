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
        mutableUserKeymaps = false;
        mutableUserSettings = false;
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

            auto_install_extensions = false;

            languages = {
                Nix.language_servers = [
                    "nil"
                    "!nixd"
                ];
                Assembly.language_servers = [ "!asm-lsp" ];
            };

            lsp = {
                nil = {
                    binary.path = "${pkgs.nil}/bin/nil";
                    initialization_options = {
                        formatting = {
                            command = [
                                "${pkgs.nixfmt}/bin/nixfmt"
                                "--indent=4"
                                "--width=200"
                            ];
                        };
                    };
                };
                ruff.binary = {
                    path = "${pkgs.ruff}/bin/ruff";
                    arguments = [ "server" ];
                };
                basedpyright.binary = {
                    path = "${pkgs.basedpyright}/bin/basedpyright-langserver";
                    arguments = [ "--stdio" ];
                };
                rust-analyzer.binary.path = "${pkgs.rust-analyzer}/bin/rust-analyzer";
                clangd.binary.path = "${pkgs.llvmPackages_19.clang-tools}/bin/clangd";
                lua-language-server.binary.path = "${pkgs.lua-language-server}/bin/lua-language-server";
                pylsp.binary.path = "${pkgs.python312Packages.python-lsp-server}/bin/pylsp";
                ols.binary.path = "${pkgs.ols}/bin/ols";
                gopls.binary.path = "${pkgs.gopls}/bin/gopls";
                package-version-server.binary.path = "${pkgs.package-version-server}/bin/package-version-server";
            };
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
