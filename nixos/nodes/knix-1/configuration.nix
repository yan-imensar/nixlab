{ lib, pkgs, ... }:
{
  imports = [
    ./disk-config.nix
    ../../modules/common/apps.nix
    ../../modules/k3s/server.nix
    ../../modules/storage/longhorn.nix
    ../../modules/common/configuration.nix
  ];

  networking.hostName = "knix-1";
  networking = {
    interfaces = {
      enp0s31f6.ipv4.addresses = [{
        address = "192.168.1.101";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.1.1";
      interface = "enp0s31f6";
    };
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    enableIPv6 = false;
  };

  services.k3s = {
    enable = true;
    role = "server";
    token = "homelab-k3s-cluster-secret";
    serverAddr = "https://192.168.1.100:6443";
    extraFlags = toString [
      "--disable servicelb"
      "--disable traefik"
      "--disable local-storage"
      "--node-ip 192.168.1.101"
    ];
  };

  system.stateVersion = "24.05";
}
