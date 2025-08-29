{ ... }: {
    imports = [
        ./hypr.nix

        ./programs/zed.nix
        ./programs/git.nix
        ./programs/vscode.nix
        ./programs/bash.nix
        ./programs/alacritty.nix
        ./programs/bemenu.nix
        ./programs/neovim
    ];
}
