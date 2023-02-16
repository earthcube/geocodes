#  Setup Gleaner   Containers:

This is step 3 of 5 major steps:

1. [Install base containers on a server](./stack_machines.md)
2. [Setup services containers](./setup_geocodes_services_containers.md)
3. [Setup Gleaner containers](setup_gleaner_container.md)
4. [Initial setup of services and loading of data](./setup_indexing_with_gleanerio.md)
5. [Setup Geocodes UI using datastores defined in Initial Setup](./setup_geocodes_ui_containers.md)

## Gleaner Container Stack
The gleaner-compose.yaml contains a single headless chrome container.
Headless chrome needs to be run with extra shared memory    `` shm_size: "2gb"`, which was not fully supported by
portainer prior to v 2.16. A script, run_gleaner.sh, that is run outside of portainer allows for this
setting to be configured.

!!! note "Future"
    in the future, this stack will most likely be a stack with a workflow system based on dagster

### Gleaner Ingest Containers 

#### Create Gleaner (via)

??? note "`./run_gleaner.sh`"
    this will run a headless chrome container  for gleaner summoning. 
    It will only be available locally via http://localhost:9222/





## Go to step 4.

1. [Install base containers on a server](./stack_machines.md)
2. [Setup services containers](./setup_geocodes_services_containers.md)
3. [Setup Gleaner containers](setup_gleaner_container.md)
4. [Initial setup of services and loading of data](./setup_indexing_with_gleanerio.md)
5. [Setup Geocodes UI using datastores defined in Initial Setup](./setup_geocodes_ui_containers.md) 


