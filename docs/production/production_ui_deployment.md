# Production UI Deployment and Server Switches

## Requirements:

* DNS Pointing at geocodes.earthcube.org  a
* Docker
    * secrets need to be set
    * deploy configs facet_config_production
    * create file env variables
    * deploy deployment/geocodes-compose-production.yaml to portainer
## GOTCHAS
Let's Encrypt has limits on production changes, so if you deploy the stack before the DNS, then you can lock y
out changes for 7 days.


## Proposed Steps

* ask for NDS TIL (time to live) to be lowered.
* Create docker config files, secrets, and configs
* change DNS.
* create a production stack
*  STOP PREVIOUS PRODUCTION STACK

## Notes:
### Let's encypt

### DNS
We will now use a single DNS record for just the UI: geocodes.earthcube.org.
This is fixed in the deployment/geocodes-compose-production.yaml

Previously, before external file configuration (facet_config_production), 
we had services at (graph|oss|minioadmin, etc).geocodes.earthcube.org. 
It is easier to configure the client to point at server services (graph|oss|minioadmin, etc).host
eg. (graph|oss|minioadmin, etc).geocodes-aws.earthcube.org where a wildcard DNS is setup.

### Docker Secrets
We are begining to use docker secrets, so these need to be configured




