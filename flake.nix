{
    description = "NixOS Common Configuration by WuX";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    outputs = { self, ... } @ inputs: {
        overlays = import ./overlays.nix { inherit inputs; inherit (self) outputs; };
    };
}
