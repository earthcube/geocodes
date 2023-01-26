# notebook Proxy

Env variables

```{.shell .copy}
AUTH_MODE=server
GITHUB_SECRET={KEY}
GITHUB_CLIENTID=b5a5494cf21096a99e37
```

Note: In portainer, you may need to go into the service to update the ENV keys, there.

## Github authorization
The app is setup to run in a service.

The app is here:
https://github.com/organizations/earthcube/settings/applications/1768280


Authorization callback URL: https://geocodes.earthcube.org/notebook/auth

