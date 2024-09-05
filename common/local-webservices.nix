{ pkgs, ... }: {
  imports = [ ];

  environment.systemPackages = with pkgs; [
    rqbit
  ];

  systemd.user.services.rqbit-webserver = {
    serviceConfig = {
      ExecStart = "${pkgs.rqbit}/bin/rqbit server start ~/Downloads/";
    };
    after = [ "network-online.target" ];
    wantedBy = [ "default.target" ];
  };
}
