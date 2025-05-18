# AWS Neuron Whisper Example with Ingress

This example demonstrates how to deploy a Whisper speech-to-text model on AWS Inferentia instances using EKS Auto Mode and expose it via an ALB Ingress.

## Components

1. **Whisper Gradio UI** - A web interface for interacting with the Whisper model
2. **Ingress Configuration** - Configuration for exposing the UI through an AWS Application Load Balancer

## Deployment

1. Deploy the Whisper Gradio UI:
   ```
   kubectl apply -f whisper-gradio-ui.yaml
   ```

2. Deploy the Ingress to expose the UI:
   ```
   kubectl apply -f whisper-gradio-ui-ingress.yaml
   ```

## Access

The Whisper UI will be available at the ALB URL with the `/whisper` path prefix.
