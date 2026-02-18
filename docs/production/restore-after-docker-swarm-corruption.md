# Docker Swarm Restoration on geocodes-aws.earthcube.org

## Date: 2026-02-18
In Feb 2026, the main aws server drive filled and corrupted the docker database,
The server had to be restored in pieces. this 


## Issue
Docker Swarm encountered a corrupted Raft WAL (Write-Ahead Log) error:
```
Error: manager stopped: can't initialize raft node: irreparable WAL error: wal: max entry size limit exceeded
```

## Resolution Steps

### 1. SSH into the server
```bash
ssh -i ~/.ssh/earthcube.pem earthcube@geocodes-aws.earthcube.org
```

### 2. Force leave the corrupted swarm
```bash
docker swarm leave --force
```

### 3. Initialize a new swarm with the public IP
```bash
docker swarm init --advertise-addr 44.227.79.248
```

### 4. Create the overlay network
```bash
docker network create \
  --driver overlay \
  portainer_agent_network
```

### 5. Deploy the Portainer agent service
```bash
docker service create \
  --name portainer_agent \
  --network portainer_agent_network \
  -p 9001:9001/tcp \
  --mode global \
  --constraint 'node.platform.os == linux' \
  --mount type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock \
  --mount type=bind,src=//var/lib/docker/volumes,dst=/var/lib/docker/volumes \
  --mount type=bind,src=//,dst=/host \
  portainer/agent:2.33.0
```

### 6. Verify the service is running
```bash
docker service ls
docker service ps portainer_agent
```

## Result
- Swarm reinitialized successfully
- Portainer agent accessible at `44.227.79.248:9001`

# Step 2: Rebuild in Scheduler
install the base, and services stacks.
You will need to create networks as listed in the documentation

# Step 3: Clean the blazegraph
stop the services stack
```bash
sudo ls -lh /var/lib/docker/volumes/graph/_data/
sudo rm /var/lib/docker/volumes/graph/_data/blazegraph.jnl
sudo rm /var/lib/docker/volumes/graph/_data/backup.jnl
sudo rm /var/lib/docker/volumes/graph/_data/rules.log
```
start the service stack

# Step 4: Rebuild in Tenant/communites Scheduler
go to the scheduler
* materialize the tenant_create asset  
* materialize the tenant_load asset
there may be some errored partitions. that's cruft
* At present, the containers are not created. that needs to be done manually.
