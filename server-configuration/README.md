# tl;dr
```
apt-get update && apt-get upgrade
apt-get install htop git
wget https://go.dev/dl/go1.19.linux-amd64.tar.gz
sha256sum go1.19.linux-amd64.tar.gz => 464b6b66591f6cf055bc5df90a9750bf5fbc9d038722bb84a9d56a2bea974be6
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.19.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
git clone https://github.com/flashbots/mev-geth
cd mev-geth/
make geth
mv build/bin/geth /bin
nano /etc/systemd/system/geth.service
--------------------------------
[Unit]
Description=geth client
After=network.target
Wants=network.target

[Service]
User=root
Group=root
Type=simple
Restart=always
RestartSec=180
ExecStart=geth --ws --rpc.gascap 0
--------------------------------

systemctl daemon-reload
systemctl start geth

geth attach /.ethereum/geth.ipc
eth.syncing
```

## Why you should get your own dedicated server

For most of your strategies it's important that you have your own node. With your own node you can reduce latency for calls and also don't rely on externally limitations like call limits or other throttlings.  
Another big benefit is that you can use eth_callBundle locally and reduce time for your simulations.

## Recommendation
You can use any provider to start. Later you also want to optimize your latency - your best bet for latency is in the most cases US-East-2 (AWS).  
AWS is the most expensive provider and so you should choose something different to start.

**To start with, a provider like hetzner** (40-60$) or a local linux server is enough. Personally I use hetzner as the provider for my testings and development of new strategies.

## Server configuration
I will walk you through the simplest possible server configuration to get your node up and running to start development against it. You can also contact me if you want to talk about optimization and what you can do in addition to secure your server or optimize further.  

### Basics
Basic stuff you should install after you login to your server.
```
apt-get update && apt-get upgrade
apt-get install htop git
```

### Go
you can check at https://go.dev/dl/ for the current stable version  
download the chosen version and check the checksum - you should always do this ;)  
remove probably old versions and unzip the binary  
export your go path and check if the version is the one you downloaded
```
wget https://go.dev/dl/go1.19.linux-amd64.tar.gz
sha256sum go1.19.linux-amd64.tar.gz => 464b6b66591f6cf055bc5df90a9750bf5fbc9d038722bb84a9d56a2bea974be6
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.19.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
go version
```

### Install mev-geth (or erigon)
As we're going to use eth_callBundle, you should choose a node where this rpc endpoint is available.  
Always check the tags on github and decide if you want to install from master or a specific tag. To install from a tag you can check out that branch.

```
git clone https://github.com/flashbots/mev-geth
cd mev-geth/
make geth
mv build/bin/geth /bin
```

### Prepare a service to run geth / erigon (if your using a aws ami - checkout nohup)
As you want your node to always run, you should create a service and start it.

open / create a new service 
```
nano /etc/systemd/system/geth.service
```

use this as your starting point and save it to geth.service
```
[Unit]
Description=geth client
After=network.target
Wants=network.target

[Service]
User=root
Group=root
Type=simple
Restart=always
RestartSec=180
ExecStart=geth --ws --rpc.gascap 0
```

reload the daemon and start geth as a service
```
systemctl daemon-reload
systemctl start geth
```

check the syncing of your node
```
geth attach /.ethereum/geth.ipc
eth.syncing
```

## Tip
Use geth help and get familiar with the possible configurations you can make.
Check the following for the start: --cache --maxpeers --rpc.gascap --rpc.txfeecap --verbosity --http 
```
geth help
```