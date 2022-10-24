##  Setup Geocodes Containers:
  * create a new env file
    * cd deployment
    * copy portainer.env to new file.` cp portainer.env {myhost}.env`
    * edit {myhost}.env
      * change 
        * HOST
        * domains (aka GLEANER_)
        *  Object store keys
        * SPARQL GUI
        *  api
  * Modify the Facet Search Configuration
     * edit in deployemet/facets/config.yaml
     * this file is mounted on the container as a docker config file
       * run the run_add_configs.sh
```yaml
API_URL: https://geocodes.{your host}/ec/api/
SPARQL_NB: https:/{your host}/notebook/mkQ?q=${q}
SPARQL_YASGUI: https://geocodes.{your host}/sparqlgui?
#API_URL: "${window_location_origin}/ec/api"
#TRIPLESTORE_URL: https://graph.geodex.org/blazegraph/namespace/earthcube/sparql
TRIPLESTORE_URL: https://{your host}/blazegraph/namespace/earthcube/sparql
ECRR_TRIPLESTORE_URL: http://{your host}blazegraph/namespace/ecrr/sparql
ECRR_GRAPH: http://earthcube.org/gleaner-summoned
THROUGHPUTDB_URL: https://throughputdb.com/api/ccdrs/annotations
SPARQL_QUERY: queries/sparql_query.txt
SPARQL_HASTOOLS: queries/sparql_hastools.txt
SPARQL_TOOLS_WEBSERVICE: queries/sparql_gettools_webservice.txt
SPARQL_TOOLS_DOWNLOAD: queries/sparql_gettools_download.txt
JSONLD_PROXY: "https://geocodes.{your host}/ec/api/${o}"
```
  * Setup and start services using portainer ui
    * log into portainer
      * if this is a first login, it will ask you for a password.
    * Select **stack** tab
    * Create Services Stack
      * click **add stack** button
          * Name: services
          * Build method: git repository
          * Repository URL: https://github.com/earthcube/geocodes
          * reference: refs/heads/main
          * Compose path: deployment/services-compose.yaml
          * Environment variables: click 'load variables from .env file'
            * load {myhost}.env
          * Actions: 
            * Click: Deploy This Stack 
  ![Create Services Stack](./images/create_services.png)
    * Create Geocodes Stack
      * click **add stack** button
        * Name: geocodes
        * Build method: git repository
        * Repository URL: https://github.com/earthcube/geocodes
        * reference: refs/heads/main
        * Compose path: deployment/geocodes-compose.yaml
        * Environment variables: click 'load variables from .env file'
          * load {myhost}.env
        * Actions:
          * Click: Deploy This Stack
    ![Create Geocodes Stack](./images/create_geocodes_stack.png)

    
