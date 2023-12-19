{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    
    tuxedo-nixos = {
      url = "github:blitz/tuxedo-nixos";
    };
  };

  outputs = { self, nixpkgs, tuxedo-nixos, ... } @ inputs :
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        tuxedo-nixos.nixosModules.default
        { hardware.tuxedo-control-center.enable = true;
          hardware.tuxedo-control-center.package = tuxedo-nixos.packages.x86_64-linux.default; }
      ];
    };
  };
}
