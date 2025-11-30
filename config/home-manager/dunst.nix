{ pkgs, ... }:
{
    services.dunst.settings = {
        global = {
            monitor = 1;
            follow = "none";

            origin = "top-center";
            offset = "(0, 10)";

            dmenu = "${pkgs.bemenu}/bin/bemenu-run -p dunst";
            browser = "${pkgs.xdg-utils}/bin/xdg-open";
        };
    };
}
