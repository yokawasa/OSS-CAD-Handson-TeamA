# Install Docker using Azure Extensions
We're going to use the Azure cli to install Docker on the jumpbox using the Azure extensions feature

Run the following:
```
 az vm extension set --vm-name <your vm name> -g <your resource group>
 --name DockerExtension  --publisher Microsoft.Azure.Extensions --version 1.2.2
 ```

Docker is now installed!  Before we can use it, we need to log out and log in:

```
exit
[disconnect]
```

Now ssh back into the server.

Let's test it:
```bash
sudo docker info
```
This command will show you info about your docker configation.  A sample:
```
yoichika@cadossteama:~/test$ sudo docker info
Containers: 0
 Running: 0
 Paused: 0
 Stopped: 0
Images: 0
Server Version: 17.10.0-ce
Storage Driver: overlay2
 Backing Filesystem: extfs
 Supports d_type: true
 Native Overlay Diff: false
Logging Driver: json-file
Cgroup Driver: cgroupfs
Plugins:
 Volume: local
 Network: bridge host macvlan null overlay
 Log: awslogs fluentd gcplogs gelf journald json-file logentries splunk syslog
Swarm: inactive
Runtimes: runc
Default Runtime: runc
Init Binary: docker-init
containerd version: 06b9cb35161009dcb7123345749fef02f7cea8e0
runc version: 0351df1c5a66838d0c392b4ac4cf9450de844e2d
init version: 949e6fa
Security Options:
 apparmor
 seccomp
  Profile: default
Kernel Version: 4.11.0-1013-azure
Operating System: Ubuntu 16.04.3 LTS
OSType: linux
Architecture: x86_64
CPUs: 1
Total Memory: 3.357GiB
Name: cadossteama
ID: 6NVD:OKGH:WRXZ:KAUO:ATFB:Y2IK:GDBQ:WM4I:SCJT:ZVZT:67BF:SBKH
Docker Root Dir: /var/lib/docker
Debug Mode (client): false
Debug Mode (server): false
Registry: https://index.docker.io/v1/
Experimental: false
Insecure Registries:
 127.0.0.0/8
Live Restore Enabled: false
```

## Useful Links
- [Create a Docker environment in Azure using the Docker VM extension](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/dockerextension)
