{
  hosts.lalu = {
    networking = {
      hostName = "lalu";
      networkmanager.enable = true;

      firewall = {
        enable = true;
        allowedUDPPorts = [53];
      };
    };
  };
}
