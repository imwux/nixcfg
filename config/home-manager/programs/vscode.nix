{ inputs, pkgs, ... }:
{
    programs.vscode = {
        userSettings = {
            "update.mode" = "none";

            "window.commandCenter" = true;
            "window.menuBarVisibility" = "classic";

            "workbench.colorTheme" = "Default Dark Modern";
            "workbench.startupEditor" = "none";
            "workbench.activityBar.location" = "top";

            "editor.renderWhitespace" = "trailing";
            "editor.cursorSmoothCaretAnimation" = "on";
            "editor.cursorBlinking" = "phase";
            "editor.bracketPairColorization.enabled" = false;
            "editor.quickSuggestionsDelay" = 0;
            "editor.minimap.renderCharacters" = false;
            "editor.fontFamily" = "RandyGG, Consolas, monospace";
            "editor.fontSize" = 15;
            "editor.selectionClipboard" = false;
            "editor.emptySelectionClipboard" = false;

            "terminal.integrated.cursorStyle" = "line";
            "files.autoSave" = "off";
            "files.associations" = { "*.h" = "c"; };
            "extensions.ignoreRecommendations" = true;
            "remote.autoForwardPorts" = false;

            "git.confirmSync" = false;

            "todo-tree.regex.regex" = "(//|/\\*|\\s\\*|#|<!--|;|^|^[ \\t]*(-|\\d+.))\\s*($TAGS)";
            "todo-tree.general.tags" = [
                "TODO"      "@todo"
                "BUG"       "@bug"
                "CRITICAL"  "@critical"
                "OPTIMIZE"  "@optimize"
            ];
            "todo-tree.highlights.backgroundColourScheme" = [
                "yellow"    "yellow"
                "orange"    "orange"
                "red"       "red"
                "green"     "green"
            ];
            "todo-tree.highlights.foregroundColourScheme" = [
                "black" "black"
                "black" "black"
                "white" "white"
                "black" "black"
            ];
            "todo-tree.general.revealBehaviour" = "start of todo";
            "todo-tree.highlights.highlightDelay" = 0;
            "todo-tree.highlights.useColourScheme" = true;

            "C_Cpp.clang_format_path" = "${pkgs.llvmPackages_19.clang-tools}/bin/clang-format";

            "asm-code-lens.enableCodeLenses" = false;
        };
        extensions = with pkgs.vscode-extensions; [
            bbenoist.nix
            gruntfuggly.todo-tree
            tamasfe.even-better-toml
        ];
    };
}
