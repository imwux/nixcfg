{ inputs, outputs }:
{ id, name, system }:
inputs.nixpkgs.lib.nixosSystem {
    inherit system;

    specialArgs = { inherit inputs outputs; inherit system; };

    modules = [
        inputs.home-manager.nixosModules.home-manager

        inputs.nixcfg-private.config.private

        ./config/common.nix
        ./config/machines/${id}

        {
            nixpkgs.overlays = builtins.attrValues outputs.overlays;

            networking.hostName = name;

            home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                extraSpecialArgs = { inherit inputs outputs; inherit system; };

                users.wux = {
                    programs.home-manager.enable = true;
                    imports = [ ./config/home-manager ];
                    home.stateVersion = "25.05";
                };
            };
        }
    ];
}
