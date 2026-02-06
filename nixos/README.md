# Homelab - Cluster K3s HA (3 nodes etcd)

## Architecture

| Node   | IP              | Role               |
|--------|-----------------|---------------------|
| knix-0 | 192.168.1.100   | server (cluster-init) |
| knix-1 | 192.168.1.101   | server (join)        |
| knix-2 | 192.168.1.102   | server (join)        |

- 3 control plane nodes avec etcd embarque pour la haute disponibilite
- Token partage defini dans `modules/k3s/server.nix`
- Deploiement via nixos-anywhere + nixos-rebuild

## Deploiement initial

### 1. Installer knix-0 (bootstrap du cluster)

```bash
nix run github:nix-community/nixos-anywhere -- \
  --generate-hardware-config nixos-generate-config ./nodes/knix-0/hardware-configuration.nix \
  --flake .#knix-0 \
  --target-host root@<IP_TEMPORAIRE>
```

### 2. Installer knix-1 et knix-2

Creer les VMs dans Proxmox, puis pour chacune :

```bash
# knix-1
nix run github:nix-community/nixos-anywhere -- \
  --generate-hardware-config nixos-generate-config ./nodes/knix-1/hardware-configuration.nix \
  --flake .#knix-1 \
  --target-host root@<IP_TEMPORAIRE>

# knix-2
nix run github:nix-community/nixos-anywhere -- \
  --generate-hardware-config nixos-generate-config ./nodes/knix-2/hardware-configuration.nix \
  --flake .#knix-2 \
  --target-host root@<IP_TEMPORAIRE>
```

Les nodes rejoignent automatiquement le cluster grace au token partage.

### 3. Verifier le cluster

```bash
export KUBECONFIG=~/.config/homelab/nixos/k3s.yaml
kubectl get nodes
```

## Mise a jour des nodes

```bash
nixos-rebuild switch --flake .#knix-0 --target-host root@192.168.1.100
nixos-rebuild switch --flake .#knix-1 --target-host root@192.168.1.101
nixos-rebuild switch --flake .#knix-2 --target-host root@192.168.1.102
```

## Structure

```
nixos/
├── flake.nix
├── modules/
│   ├── common/apps.nix        # Paquets systeme communs
│   └── k3s/server.nix         # Config k3s partagee (firewall, token, flags)
└── nodes/
    ├── knix-0/                 # Bootstrap node (cluster-init)
    ├── knix-1/                 # Join node
    └── knix-2/                 # Join node
```

## Notes

- Le kubeconfig (`k3s.yaml`) doit pointer vers l'IP d'un des nodes (pas 127.0.0.1)
- Si knix-0 est reinstalle from scratch, il faut aussi nettoyer l'etat k3s des autres nodes :
  `systemctl stop k3s && rm -rf /var/lib/rancher/k3s/server && systemctl start k3s`
