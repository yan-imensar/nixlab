{ lib, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [
    6443  # k3s: API server
    2379  # k3s: etcd clients
    2380  # k3s: etcd peers
    9345  # k3s: supervisor API (HA)
    10250 # k3s: Kubelet metrics/API
  ];
  networking.firewall.allowedUDPPorts = [
    8472 # k3s : Flannel
  ];
}
