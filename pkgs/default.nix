pkgs:
{
    wallpaper = import ./wallpaper { inherit pkgs; };
    screenshot = pkgs.callPackage ./screenshot.nix {};
}
