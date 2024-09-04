# Container setup
This is a sample container setup with aurx completely set up.  
`docker` has been used as an example but any other container orchestrator should work.  
It's strongly suggested to set a password to the user `archlinux` as soon as you are in a runtime environment.  

## Containerfile
The Containerfile consists of three steps compacted in two layers:
- creating an user called `archlinux` with sudo privileges and empty password, 
- installing dependencies for makepkg and aurx,
- cloning and copying aurx to /usr/bin.  

## compose.yaml
`compose.yaml` creates a demo container with aurx ready to use.  

## Installation
```bash
docker compose up -d
```

## Usage
```bash
docker exec -it aurx-host-1 /bin/bash
aurx --help
```

