#!/bin/bash

# This script sets up the environment to run eks-node-viewer

# Source the bashrc to ensure Go environment is set up
source ~/.bashrc

# Run eks-node-viewer
eks-node-viewer --resources cpu,memory --extra-labels karpenter.sh/nodepool,topology.kubernetes.io/zone

#eks-node-viewer "$@"
# Karpenter nodes only
#eks-node-viewer --node-selector karpenter.sh/nodepool
# Display both CPU and Memory Usage
#eks-node-viewer --resources cpu,memory,kubernetes.io/arch,karpenter.sh/nodepool
