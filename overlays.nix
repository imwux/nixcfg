{ inputs }:
{
    additions = final: prev: import ./pkgs final.pkgs;

    unstable-packages = final: prev: {
        unstable = import inputs.nixpkgs-unstable {
            system = final.stdenv.hostPlatform.system;
            config.allowUnfree = true;
        };
    };
}
