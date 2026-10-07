{ inputs, ... }:
{
  imports = [
    ../../modules/darwin
    ../../modules/darwin/work.nix
    ../../modules/darwin/personal.nix
  ];

  networking.hostName = "martins-macbook-pro";
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  system.primaryUser = "martin";
  users.users.martin = {
    name = "martin";
    home = "/Users/martin";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-bak";
    extraSpecialArgs = { inherit inputs; };
    users.martin = import ../../modules/home;
  };

  # Don't change after the first switch.
  system.stateVersion = 5;
}
