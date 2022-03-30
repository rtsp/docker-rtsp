# RTSP Tools

Debian with basic network tools included.


## Usage

In order to use image from GitHub Container Registry instead of Docker Hub, you can replace `rtsp/rtsp` with `ghcr.io/rtsp/docker-rtsp` anywhere in the instruction below.

### Pull Image

```ShellSession
docker pull rtsp/rtsp
```

### Interactive Mode

```ShellSession
docker run --rm -it rtsp/rtsp bash
```

### Run a Specific Command

```ShellSession
docker run --rm rtsp/rtsp ping -c 3 172.17.0.1
```

### Run as Daemon

```ShellSession
docker run -d --name rtsp rtsp/rtsp
```

```ShellSession
docker exec rtsp ping -c 3 172.17.0.1

docker exec -it rtsp bash
```

### Run as Kubernetes Pod

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: rtsp
spec:
  containers:
  - name: rtsp
    image: rtsp/rtsp:latest
```

```ShellSession
kubectl exec rtsp -- ping -c 3 10.233.0.1

kubectl exec -it rtsp -- bash
```

### Run as Kubernetes DaemonSet

This manifests will deploy Pods in all nodes (including control-plane). Useful for network reachability debugging.

```yaml
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: rtsp
spec:
  selector:
    matchLabels:
      name: rtsp
  template:
    metadata:
      labels:
        name: rtsp
    spec:
      tolerations:
      - key: node-role.kubernetes.io/master
        operator: Exists
        effect: NoSchedule
      containers:
        - name: rtsp
          image: rtsp/rtsp:latest
          imagePullPolicy: IfNotPresent
      terminationGracePeriodSeconds: 30
```

Retrieve Pods Name

```ShellSession
kubectl get pods -l name=rtsp -o wide
```

Output (Trimmed)
```
NAME              READY   STATUS    AGE     IP             NODE
rtsp-j7j97   1/1     Running   4d5h    10.233.69.40   k8s-w3
rtsp-kfx7h   1/1     Running   4d16h   10.233.66.10   k8s-m3
rtsp-krttb   1/1     Running   4d16h   10.233.68.43   k8s-w1
rtsp-l8tjd   1/1     Running   4d16h   10.233.67.36   k8s-w2
rtsp-q48n6   1/1     Running   4d16h   10.233.65.7    k8s-m2
rtsp-vw45v   1/1     Running   4d16h   10.233.64.11   k8s-m1
```

Example: Check that `k8s-m2` node (`rtsp-q48n6`) able to reach a pod in `k8s-m1` node (`10.233.64.11`).

```ShellSession
kubectl exec rtsp-q48n6 -- ping -c 3 10.233.64.11
```

or just run it interactively

```ShellSession
kubectl exec -it rtsp-q48n6 -- bash
```

or if you don't mind which Pod to use

```ShellSession
kubectl exec -it daemonset/rtsp -- bash
```


## Links

### Packages

- Docker Hub: [rtsp/rtsp](https://hub.docker.com/r/rtsp/rtsp/)
- GitHub: [ghcr.io/rtsp/docker-rtsp](https://github.com/rtsp/docker-rtsp/pkgs/container/docker-rtsp)

### Source Code

- [rtsp/docker-rtsp](https://github.com/rtsp/docker-rtsp)
