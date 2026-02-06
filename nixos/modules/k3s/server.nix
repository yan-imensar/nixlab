{ lib, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [
    6443 # k3s: API server
    2379 # k3s: etcd clients
    2380 # k3s: etcd peers
  ];
  networking.firewall.allowedUDPPorts = [
    8472 # k3s : Flannel
  ];
  services.k3s.enable = true;
  services.k3s.role = "server";
  services.k3s.extraFlags = toString [
	    "--disable servicelb"
	    "--disable traefik"
	    "--disable local-storage"
  ];
}
