# Container setup
This is a sample container setup with aurx completely set up.  
`docker` and `kubernetes` have been used as examples but any other container orchestrator should work.  
It's strongly suggested to set a password to the user `archlinux` as soon as you are in a runtime environment.  

## Containerfile
The Containerfile consists of three steps compacted in two layers:
- creating an user called `archlinux` with sudo privileges and empty password, 
- installing dependencies for makepkg and aurx,
- cloning and copying aurx to /usr/bin.  

## pod.yaml
`pod.yaml` creates a demo Kubernetes pod with aurx ready to use.  
It is assumed that the image is available on the running node.  

## compose.yaml
`compose.yaml` creates a demo Docker container with aurx ready to use.  

## Installation
```bash
kubectl create -f pod.yaml
# or
docker compose up -d
```

## Usage
```bash
kubectl exec -it aurx-pod-00 -- /bin/bash
aurx --help
# or 
docker exec -it aurx-host-1 /bin/bash
aurx --help
```

