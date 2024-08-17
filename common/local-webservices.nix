{ ... }: {
  imports = [ ];

  services.ollama = {
    enable = true;
    host = "localhost";
  };

  services.open-webui.enable = true;
}
