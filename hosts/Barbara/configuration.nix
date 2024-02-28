{ inputs, ... }: {
  users.users.foobar = {
    # ...
    isNormalUser = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    sharedModules = [
      # this is where you can put HM modules that are shared between all HM users on this system
      # you can also just write your own modules and reference them here as some kind of common config between users
      inputs.plasma-manager.homeManagerModules.plasma-manager
    ];

    users.foobar = {
      # you can also import modules here using `imports = [...];`
      programs.plasma.workspace.tooltipDelay = 5;
    };
  };
}
