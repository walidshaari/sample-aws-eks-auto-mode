# Whisper Neuron Deployment Guide

This guide documents the step-by-step process for deploying the Whisper Large V3 Turbo speech recognition model on EKS Auto Mode using AWS Inferentia2 acceleration.

## Prerequisites

- EKS Auto Mode cluster is already set up
- Neuron NodePool has been deployed
- You have kubectl access to the cluster

## Deployment Process

### 1. Create Namespace and Persistent Storage

First, create the namespace and persistent volume claim that will store the compiled models:

```bash
kubectl apply -f pvc.yaml
```

This creates:
- `whisper-neuron` namespace
- `model-storage-class` storage class (gp3 EBS with high IOPS)
- `model-storage-claim` PVC with 1000Gi storage

Verify the PVC is created and bound:
```bash
kubectl get pvc -n whisper-neuron
```

### 2. Run Model Compilation Job

Deploy the compilation job that will download and compile the Whisper model for Neuron:

```bash
kubectl apply -f whisper-compile.yaml
```

The compilation job:
- Uses a Neuron-compatible node (with appropriate tolerations)
- Downloads the Whisper Large V3 Turbo model
- Compiles it for Neuron acceleration
- Saves the compiled model to the persistent storage

Monitor compilation progress:
```bash
kubectl logs -f -l app=whisper-compile -n whisper-neuron
```

Wait for compilation to complete (takes approximately 10-15 minutes):
```bash
if kubectl logs $(kubectl get pods -l app=whisper-compile -n whisper-neuron -o name) -n whisper-neuron | grep -q "Compilation complete! Models saved to PVC."; then
  echo "Compilation is complete"
else
  echo "Compilation is still running"
fi
```

Once compilation is complete, you can delete the job:
```bash
kubectl delete -f whisper-compile.yaml
```

### 3. Deploy Whisper Inference Service

Deploy the inference service that will run the compiled model on Neuron cores:

```bash
kubectl apply -f whisper-infernce-service.yaml
```

This creates:
- A deployment with 1 replica running the inference container
- Requests 1 Neuron core per pod
- Mounts the PVC with compiled models
- Creates a ClusterIP service exposing port 80 (targeting container port 8000)

Verify the deployment is running:
```bash
kubectl get pods -n whisper-neuron -l app=whisper-inference
```

Check the logs to ensure the model loaded correctly:
```bash
kubectl logs -n whisper-neuron -l app=whisper-inference
```

### 4. Deploy Gradio Web UI

Deploy the Gradio web interface that will allow users to interact with the model:

```bash
kubectl apply -f whisper-gradio-ui.yaml
```

This creates:
- A deployment running the Gradio UI container
- A ClusterIP service exposing port 80 (targeting container port 7860)
- Configures the UI to connect to the inference service

Verify the Gradio deployment is running:
```bash
kubectl get pods -n whisper-neuron -l app=whisper-gradio
```

### 5. Create Ingress for External Access

Deploy an ingress to expose the Gradio UI externally:

```bash
kubectl apply -f whisper-gradio-ingress.yaml
```

This creates:
- An ALB Ingress resource
- Exposes the Gradio service at the `/whisper` path
- Uses the specified ingress class and ALB group

Get the external URL:
```bash
kubectl get ingress -n whisper-neuron whisper-gradio-ingress -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

The application will be accessible at:
```
http://<INGRESS_HOSTNAME>/whisper
```

## Verification and Testing

### Check All Components

Verify all components are running:
```bash
kubectl get all -n whisper-neuron
```

### Test the Application

1. Open the ingress URL in your browser
2. Upload a sample audio file (from the `samples` directory) or record audio
3. The audio will be processed by the inference service and transcription results will be displayed

Note: The first transcription request may take up to 30 seconds for model warmup.

## Troubleshooting

### Inference Service Issues

If the inference service is not working properly:

1. Check pod status:
```bash
kubectl get pods -n whisper-neuron -l app=whisper-inference
```

2. Check logs for errors:
```bash
kubectl logs -n whisper-neuron -l app=whisper-inference
```

3. Verify the model was compiled correctly:
```bash
kubectl exec -n whisper-neuron $(kubectl get pods -n whisper-neuron -l app=whisper-inference -o name | head -1) -- ls -la /models
```

### Gradio UI Issues

If the Gradio UI is not working:

1. Check pod status:
```bash
kubectl get pods -n whisper-neuron -l app=whisper-gradio
```

2. Check logs for errors:
```bash
kubectl logs -n whisper-neuron -l app=whisper-gradio
```

3. Verify the service can connect to the inference service:
```bash
kubectl exec -n whisper-neuron $(kubectl get pods -n whisper-neuron -l app=whisper-gradio -o name | head -1) -- curl -s whisper-inference-service
```

### Ingress Issues

If the ingress is not working:

1. Check ingress status:
```bash
kubectl describe ingress -n whisper-neuron whisper-gradio-ingress
```

2. Verify ALB was created:
```bash
kubectl get events -n whisper-neuron
```

## Cleanup

To remove all deployed resources:

```bash
# Delete ingress
kubectl delete -f whisper-gradio-ingress.yaml

# Delete Gradio UI
kubectl delete -f whisper-gradio-ui.yaml

# Delete inference service
kubectl delete -f whisper-infernce-service.yaml

# Delete PVC and namespace (this will delete all data)
kubectl delete -f pvc.yaml
```

To verify all resources are removed:
```bash
kubectl get all -n whisper-neuron
```

If the namespace still exists, you can force delete it:
```bash
kubectl delete namespace whisper-neuron --force
```
