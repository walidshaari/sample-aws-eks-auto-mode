---
apiVersion: eks.amazonaws.com/v1
kind: NodeClass
metadata:
  name: cpu-nodeclass
spec:
  role: ${node_iam_role_name}
  subnetSelectorTerms:
    - tags:
        karpenter.sh/discovery: "automode-demo"
  securityGroupSelectorTerms:
    - tags:
        aws:eks:cluster-name: ${cluster_name}
  tags:
    karpenter.sh/discovery: "automode-demo"
---
apiVersion: karpenter.sh/v1
kind: NodePool
metadata:
  name: cpu-nodepool
spec:
  template:
    spec:
      nodeClassRef:
        group: eks.amazonaws.com
        kind: NodeClass
        name: cpu-nodeclass
      requirements:
        # This section combines all instance types from the different nodepools
        # For standard Graviton and Spot instances (ARM64)
        - key: "kubernetes.io/arch"
          operator: In
          values: ["arm64", "amd64"]
        - key: "karpenter.sh/capacity-type"
          operator: In
          values: ["spot", "on-demand"]
        # For general purpose instances (c, m, r families)
        - key: "eks.amazonaws.com/instance-category"
          operator: In
          values: ["c", "m", "r"]  
      taints:
        - key: "workload"
          value: "cpu"
          effect: NoSchedule    
  limits:
    cpu: 1000
  disruption:
    # Available consolidation policies:
    # - WhenEmpty: Consolidate nodes when they become empty
    # - WhenEmptyOrUnderutilized: Consolidate nodes when they are underutilized (default)
    # - Never: Never consolidate nodes
    consolidationPolicy: WhenEmptyOrUnderutilized
    consolidateAfter: 30s
