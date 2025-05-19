{
    description = "NixOS Configuration by WuX";

    inputs = {
        # nixpkgs
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

        # Home manager
        home-manager.url = "github:nix-community/home-manager/release-25.05";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        # Lanzaboote (Secure Boot)
        lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
        lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

        # WuX UI
        wuxs-ui.url = "github:imwux/ui";
        wuxs-ui.inputs.nixpkgs.follows = "nixpkgs";

        # NixOS Private Configuration
        nixcfg-private.url = "git+ssh://git@github.com/imwux/nixcfg-private.git?ref=main";
        nixcfg-private.inputs.nixpkgs.follows = "nixpkgs";
        nixcfg-private.inputs.home-manager.follows = "home-manager";
    };

    outputs = { self, ... } @ inputs: let
        mkSystem = import ./mksystem.nix { inherit inputs; inherit (self) outputs; };
    in {
        overlays = import ./overlays.nix { inherit inputs; };

        config.common = import ./config/common.nix;

        nixosConfigurations.Odin = mkSystem { id = "odin"; name = "Odin"; system = "x86_64-linux"; };
        nixosConfigurations.HQ = mkSystem { id = "hq"; name = "HQ"; system = "x86_64-linux"; };
    };
}
