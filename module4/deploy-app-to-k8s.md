# Deploy Gallery3 App Container on k8s

To be completeed. We have the docker image.. challege yourself and get this working in K8 or even on AKS!

## Manifests 'kinds' in K8s
- Pods
- ReplicationController. This is now going to be replaced by Deployments (Currently in Beta. Change apiVersion beta/v1)
- Service

## example pod.yml file
```
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80
```

## example replication-ctl.yml file
```
apiVersion: v1
kind: ReplicationController
metadata:
  name: nginx
spec:
  replicas: 2
  selector:
    app: nginx
  template:
    metadata:
      name: nginx
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```

## example service-ctl.yml file
```
apiVersion: v1
kind: Service
metadata:
  labels:
    name: nginxservice
  name: nginxservice
spec:
  ports:
    # The port that this service should serve on.
    - port: 82
  # Label keys and values that must match in order to receive traffic for this service.
  selector:
    app: nginx
  type: LoadBalance
```
