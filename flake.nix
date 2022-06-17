{
  description = "system configurations";

  inputs.home-manager.url = "github:nix-community/home-manager/release-22.05";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nix-script.url = "github:BrianHicks/nix-script";
  inputs.nix-script.inputs.nixpkgs.follows = "nixpkgs-unstable";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";

  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

  inputs.secrets.url = "secrets";

  outputs = { self, home-manager, nix-script, nixpkgs, nixpkgs-unstable, secrets } @ inputs: let
    inherit (nixpkgs.lib) filterAttrs nameValuePair;
    asciiLower = "abcdefghijklmnopqrstuvwxyz";
    asciiUpper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    numbers = "0123456789";
    userRegex = "[${asciiLower}${asciiUpper}${numbers}._-]+";
    hostRegex = "[${asciiLower}${asciiUpper}${numbers}-]{1,63}";
    mkSystemConfig = args: nixpkgs.lib.nixosSystem (args // {
      specialArgs = (args.specialArgs or {}) // { inherit inputs; inherit (secrets) secrets; };
      modules = (args.modules or []) ++ [
        ({ lib, ...}: {
          system.configurationRevision = lib.mkIf (self ? rev) self.rev;
        })
      ];
    });
    mkUserConfig = args: home-manager.lib.homeManagerConfiguration (args // {
      extraSpecialArgs = (args.extraSpecialArgs or {}) // { inherit inputs; inherit (secrets) secrets; };
    });
    hosts = builtins.attrNames (filterAttrs (name: type: type == "directory") (builtins.readDir ./hosts));
    users = builtins.attrNames (filterAttrs (name: type: type == "directory") (builtins.readDir ./users));
  in {
    nixosConfigurations = builtins.listToAttrs (map (host: assert builtins.match hostRegex host != null; nameValuePair host (mkSystemConfig (import ./hosts/${host}))) hosts);
    homeConfigurations = builtins.listToAttrs (map (user: assert builtins.match "${userRegex}(@${hostRegex})?" user != null; nameValuePair user (mkUserConfig (import ./users/${user}))) users);
  };
}
