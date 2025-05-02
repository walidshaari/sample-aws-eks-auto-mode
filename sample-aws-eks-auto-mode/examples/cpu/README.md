# Multi-Architecture CPU Workloads on EKS Auto Mode

## Table of Contents
- [Overview](#overview)
- [Architecture](#architecture)
- [Implementation Steps](#implementation-steps)
- [Cleanup](#cleanup)
- [Troubleshooting](#troubleshooting)

## Overview
This example demonstrates how to deploy workloads that can run on both ARM64 (Graviton) and AMD64 architectures, as well as on both On-Demand and Spot instances in Amazon EKS. Key benefits include:

🌐 **Architecture Flexibility**
- Support for both ARM64 and AMD64 architectures
- Leverage cost-efficient Graviton processors
- Maintain compatibility with traditional x86 instances

💰 **Cost Optimization**
- Use Spot instances for non-critical workloads (up to 90% savings)
- Fall back to On-Demand for stability when needed
- Optimize for both cost and reliability

⚡ **High Availability**
- Spread workloads across multiple instance types
- Resilience against Spot interruptions
- Automatic failover between capacity types

## Architecture
This example demonstrates a flexible deployment strategy using Karpenter's advanced scheduling capabilities.

**Key Components**:
📄 **NodePool Template**
- Supports both ARM64 and AMD64 architectures
- Configures both Spot and On-Demand capacity types
- Uses affinity rules for optimal scheduling

🔄 **Load Balancer**
- Application Load Balancer (ALB)
- Exposes the application to external traffic

🎮 **Sample Application**
- 2048 game (sliding tile puzzle)
- Multi-architecture container image
- Configurable scheduling preferences

## Implementation Steps

### 1. Setup EKS Auto Mode Cluster
First, set up the EKS cluster using Terraform:

```bash
cd sample-aws-eks-auto-mode/terraform

terraform init
terraform apply -auto-approve

$(terraform output -raw configure_kubectl)
```

### 2. Deploy the NodePool
Deploy the NodePool that will manage our instances:

```bash
cd ../nodepools

kubectl apply -f multi-arch-nodepool.yaml
```

### 3. Deploy the 2048 Game
Deploy our multi-architecture compatible 2048 game application:

```bash
cd ../examples/cpu

kubectl apply -f game-2048.yaml
```

### 4. Configure Load Balancer
Set up the Application Load Balancer using Ingress:

```bash
kubectl apply -f 2048-ingress.yaml
```

### 5. Access the Application
After the ALB is provisioned (usually takes 5-10 minutes):

1. Get the ALB hostname:
```bash
kubectl get ingress ingress-2048 \
  -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' \
  -n game-2048-cpu
```

2. Open the URL in your browser to play the 2048 game! 🎮

## Cleanup

🧹 Follow these steps to clean up all resources:

### 1. Remove Kubernetes Resources
First, remove the application and node pool:

```bash
# Remove application components
kubectl delete -f 2048-ingress.yaml
kubectl delete -f game-2048.yaml

# Remove node pool
kubectl delete -f ../../nodepools/multi-arch-nodepool.yaml
```

### 2. Remove Cluster (Optional)
If you're done with the entire cluster:

```bash
# Navigate to Terraform directory
cd ../../terraform

# Initialize and destroy infrastructure
terraform init
terraform destroy --auto-approve
```

## Troubleshooting

🔧 Common issues and their solutions:

### 🎯 Node Provisioning Issues
1. **Architecture Compatibility**
   - Check if your container image supports both architectures:
     ```bash
     kubectl describe pods -n game-2048-cpu
     ```
   - Verify node architecture:
     ```bash
     kubectl get nodes -o wide
     ```

2. **Capacity Type Issues**
   - Monitor capacity allocation:
     ```bash
     kubectl get nodes -L karpenter.sh/capacity-type,kubernetes.io/arch
     ```
   - Check pod scheduling status:
     ```bash
     kubectl get pods -n game-2048-cpu -o wide
     ```

### 🔄 Load Balancer Issues
1. **ALB Configuration**
   ```bash
   # Check ALB controller logs
   kubectl logs -n kube-system \
     deployment/aws-load-balancer-controller
   ```

2. **Ingress Status**
   ```bash
   # Check ingress status
   kubectl describe ingress ingress-2048 -n game-2048-cpu
   ```

> 💡 **Tip**: Use `kubectl get events` to monitor instance provisioning and pod scheduling events.
