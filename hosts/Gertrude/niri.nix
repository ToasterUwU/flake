{ ... }:
{
  home-manager = {
    users.aki =
      { config, ... }:
      {
        services = {
          mako = {
            settings = {
              output = "eDP-1";
            };
          };
        };
        programs = {
          niri.settings = {
            outputs = {
              "eDP-1" = {
                position = {
                  x = 0;
                  y = 0;
                };
              };
              "HDMI-A-1" = {
                position = {
                  x = 1920;
                  y = 0;
                };
              };
            };
          };
        };
      };
  };
}