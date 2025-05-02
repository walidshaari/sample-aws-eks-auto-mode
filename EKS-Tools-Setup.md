# EKS Tools Setup

This environment has been set up with several tools to help you work with Amazon EKS:

## Installed Tools

- **kubectl**: Kubernetes command-line tool
  - With auto-completion enabled
  - Alias: `k`

- **kubectx**: Tool for switching between Kubernetes contexts
  - Alias: `kctx`

- **kubens**: Tool for switching between Kubernetes namespaces
  - Alias: `kns`

- **k9s**: Terminal-based UI for Kubernetes
  - Run with: `k9s`

- **eks-node-viewer**: Tool for visualizing EKS nodes and pods
  - Run with: `/environment/eks-node-viewer-setup.sh`

## Usage Examples

### kubectl
```bash
# List all pods
kubectl get pods

# Using the alias
k get pods
```

### kubectx
```bash
# List all contexts
kubectx

# Switch to a context
kubectx context-name
```

### kubens
```bash
# List all namespaces
kubens

# Switch to a namespace
kubens namespace-name
```

### k9s
```bash
# Start k9s
k9s
```

### eks-node-viewer
```bash
# Start eks-node-viewer
/environment/eks-node-viewer-setup.sh
```
