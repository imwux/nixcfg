{ inputs, outputs }:
{
    additions = final: prev: import ./pkgs final.pkgs;

    unstable-packages = final: prev: {
        unstable = import inputs.nixpkgs-unstable {
            system = final.system;
            config.allowUnfree = true;
        };
    };
}
