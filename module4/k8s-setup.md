# k8s on ACS Setup

### Note: prefix your resource gorup with your user id to keep unique.

1. Create K8 resource group on ACS

`$ az group create --name=gallery3-rg --location=westus`

2. Once the resource group is create, you can create a cluster using:

```
$ az acs create --orchestrator-type=kubernetes \
--resource-group=gallery30-rg --name=gallery3-cluster --generate-ssh-keys
```

3. Once this cluser is created, you can get credentials for the cluster with:

`$ az acs kubernetes get-credentials --resource-group=gallery3-rg --name=gallery3-cluster`

4. If you don't already have the kubernetes CLI tool installed, you can install it using:

`$ az acs kubernetes install-cli`
