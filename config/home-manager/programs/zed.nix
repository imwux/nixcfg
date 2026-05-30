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
            "scss"
        ];
        mutableUserKeymaps = false;
        mutableUserSettings = false;
        userSettings = {
            # Appearance
            theme = {
                mode = "dark";
                dark = "VSCode Dark Modern";
                light = "One Light";
            };

            "experimental.theme_overrides" = {
                "background.appearance" = "transparent";
                "background" = "#1F1F1FF0";
                "editor.background" = "#00000000";
                "editor.gutter.background" = "#00000000";
                "editor.active_line.background" = "#12121220";
            };

            # Panels
            terminal = {
                shell.program = "/run/current-system/sw/bin/bash";
                dock = "right";
            };

            debugger.dock = "right";
            agent.dock = "right";

            project_panel.dock = "left";
            git_panel.dock = "left";
            collaboration_panel.dock = "left";
            outline_panel.dock = "left";

            # Misc
            tab_size = 4;
            format_on_save = "on";
            minimap.show = "always";

            edit_predictions.provider = "none";

            calls.mute_on_join = true;

            terminal.cursor_shape = "bar";

            auto_install_extensions = false;

            # Agent Servers
            agent_servers = {
                claude-acp = {
                    type = "custom";
                    command = "${pkgs.claude-agent-acp}/bin/claude-agent-acp";
                };
                codex-acp = {
                    type = "custom";
                    command = "${pkgs.codex-acp}/bin/codex-acp";
                };
            };

            # Language Servers
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
                rust-analyzer.binary.path = "${pkgs.unstable.rust-analyzer}/bin/rust-analyzer";
                clangd.binary.path = "${pkgs.unstable.llvmPackages_22.clang-tools}/bin/clangd";
                lua-language-server.binary.path = "${pkgs.lua-language-server}/bin/lua-language-server";
                pylsp.binary.path = "${pkgs.python312Packages.python-lsp-server}/bin/pylsp";
                ols.binary.path = "${pkgs.ols}/bin/ols";
                gopls.binary.path = "${pkgs.gopls}/bin/gopls";
                package-version-server.binary.path = "${pkgs.package-version-server}/bin/package-version-server";
                pest.binary.path = "${pkgs.pest-ide-tools}/bin/pest-language-server";
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
                    "ctrl-shift-space" = "editor::ShowSignatureHelp";
                };
            }
        ];
    };
}
