{ ... }:
{
  home-manager = {
    users.aki =
      { config, ... }:
      {
        services = {
          mako = {
            settings = {
              output = "DP-3";
            };
          };
        };
        programs = {
          niri.settings = {
            outputs = {
              "HDMI-A-2" = {
                position = {
                  x = 0;
                  y = 0;
                };
              };
              "DP-3" = {
                position = {
                  x = 2560;
                  y = 0;
                };
              };
              "HDMI-A-1" = {
                position = {
                  x = 5120;
                  y = 0;
                };
              };
            };
          };
        };
      };
  };
}
