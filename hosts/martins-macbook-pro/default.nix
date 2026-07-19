{ ... }:
{
  imports = [ ../../modules/darwin ];

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
    users.martin = import ../../modules/home;
  };

  # Don't change after the first switch.
  system.stateVersion = 5;
}
