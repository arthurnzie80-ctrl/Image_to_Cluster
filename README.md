#  Atelier From Image to Cluster

## Description
Déploiement automatisé d'une application Nginx customisée sur un cluster Kubernetes K3d, via Packer et Ansible, dans GitHub Codespaces.

## Architecture

## Prérequis
- GitHub Codespaces
- Docker
- K3d
- Packer
- Ansible

## Installation et déploiement

### 1. Créer le cluster K3d
```bash
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
k3d cluster create lab --servers 1 --agents 2
kubectl get nodes
```

### 2. Lancer tout automatiquement
```bash
make all
```

### Ou étape par étape
```bash
make install  # Installe Packer et Ansible
make build    # Build image Nginx custom avec Packer
make import   # Import image dans K3d
make deploy   # Déploiement via Ansible
make forward  # Forward port 8081
```

## Vérification
```bash
kubectl get pods
kubectl get svc
```

## Résultat
Application accessible sur le port **8081** via GitHub Codespaces.
