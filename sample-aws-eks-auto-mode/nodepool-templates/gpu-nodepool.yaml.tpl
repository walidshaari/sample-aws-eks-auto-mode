---
apiVersion: eks.amazonaws.com/v1
kind: NodeClass
metadata:
  name: gpu-nodeclass
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
  name: gpu-nodepool
spec:
  template:
    spec:
      nodeClassRef:
        group: eks.amazonaws.com
        kind: NodeClass
        name: gpu-nodeclass
      requirements:
        - key: "eks.amazonaws.com/instance-family"
          operator: In
          values: ["g3", "g4", "g5", "g6", "p3", "p4", "p5"]
        - key: "karpenter.sh/capacity-type"
          operator: In
          values: ["spot", "on-demand"]
      taints:
        - key: "nvidia.com/gpu"
          value: "true"
          effect: NoSchedule
  limits:
    cpu: 1000
  disruption:
    consolidationPolicy: WhenEmpty
    consolidateAfter: 30s
