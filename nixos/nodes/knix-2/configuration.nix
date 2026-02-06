{ lib, pkgs, ... }:
{
  imports = [
    ./disk-config.nix
    ../../modules/common/apps.nix
    ../../modules/k3s/server.nix
    ../../modules/storage/longhorn.nix
  ];

  networking.hostName = "knix-2";
  networking = {
    interfaces = {
      ens18.ipv4.addresses = [{
        address = "192.168.1.102";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.1.1";
      interface = "ens18";
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
      "--node-ip 192.168.1.102"
    ];
  };

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys =
  [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDTqg1h617IHbN4fUsyfSf42uX68xTcbleAMWyRN/VEDntc4ESAi4H8GnmTiJmjiKXT/DD119XkoVWaVStqgZfey1H8kjVi6EzKEFXs2Y6Tnz1Ad+tQwcgpIl/vvVHVSPSMu9J1VQIYGpE+wYEZf0NTuQHu1bBS0oEOKLv63nUIVystBuchy8pJg9fAPInWxqfU12hoZUWtx6ZLaO6h9hatiqxJht81pOwjv2PW8vflIYKDnMYjzqVzgPipqo7e3P7aKpqaCT6jgVkKnFXz72mNcvWsS0YoD2GxrE3qAGb9UWOV5Y+2oxjAlqILas6ejUQ/s3swnJDBRMHY82QwCTZpdq2RJm+pHFZf/lRX5RQpgiNURj2+YOl3NQaEjE4a7ZEBK2Gos72tXss/5stlDTsWpI445NXYOq8uk7yrkxKf1dKAJPNGzGR4kcB4iyvcZw5noAn1HbmpdK5W1u1ms65z9PV+RdVo7AlJnHdSe1lPxe+erepWI5UJpVxP9I/OkMs= bomal@nixos"
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  system.stateVersion = "24.05";
}
