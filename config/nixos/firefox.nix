{ ... }: {
    programs.firefox = {
        preferencesStatus = "locked";
        languagePacks = [ "en-US" "sv-SE" "fi" ];
        preferences = {
            "layout.css.prefers-color-scheme.content-override" = 0;
            "browser.shell.checkDefaultBrowser" = false;
            "browser.contentblocking.category" = "strict";
            "extensions.pocket.enabled" = false;
            "identity.fxaccounts.enabled" = false;
            "extensions.screenshots.disabled" = true;
            "browser.formfill.enable" = false;
            "browser.search.suggest.enabled" = false;
            "browser.search.suggest.enabled.private" = false;
            "browser.urlbar.suggest.searches" = false;
            "browser.urlbar.showSearchSuggestionsFirst" = false;
            "browser.topsites.contile.enabled" = false;
            "browser.toolbars.bookmarks.visibility" = "never";
            "browser.newtabpage.activity-stream.feeds.topsites" = false;
            "browser.newtabpage.activity-stream.newtabWallpapers.wallpaper" = "dark-fox-anniversary";
            "browser.newtabpage.activity-stream.newtabWallpapers.wallpaper-dark" = "dark-fox-anniversary";
            "browser.newtabpage.activity-stream.newtabWallpapers.wallpaper-light" = "dark-fox-anniversary";
            "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
            "browser.newtabpage.activity-stream.feeds.snippets" = false;
            "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
            "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
            "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
            "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
            "browser.newtabpage.activity-stream.showSponsored" = false;
            "browser.newtabpage.activity-stream.system.showSponsored" = false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        };
        policies = {
            DisableTelemetry = true;
            DisableFirefoxStudies = true;
            EnableTrackingProtection = {
                Value = true;
                Locked = true;
                Cryptomining = true;
                Fingerprinting = true;
            };
            DisablePocket = true;
            DisableFirefoxAccounts = true;
            DisableAccounts = true;
            DisableFirefoxScreenshots = true;
            OverrideFirstRunPage = "";
            OverridePostUpdatePage = "";
            DontCheckDefaultBrowser = true;
            DisplayBookmarksToolbar = "never";
            DisplayMenuBar = "default-off";
            SearchBar = "unified";

            ExtensionSettings = {
                "*".installation_mode = "blocked";
                "uBlock0@raymondhill.net" = {
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                    installation_mode = "force_installed";
                };
                "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
                    installation_mode = "force_installed";
                };
                "addon@darkreader.org" = {
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
                    installation_mode = "force_installed";
                };
                "{eceab40b-230a-4560-98ed-185ad010633f}" = {
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/nixos-packages-search-engine/latest.xpi";
                    installation_mode = "force_installed";
                };
                "simple-tab-groups@drive4ik" = {
                    install_url = "https://addons.mozilla.org/firefox/downloads/latest/simple-tab-groups/latest.xpi";
                    installation_mode = "force_installed";
                };
            };
        };
    };
}
