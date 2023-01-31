
# Loading Data for The Initial Installation

This is step 3 of 4 major steps:

1. [Install base containers on a server](./stack_machines.md)
2. [Setup services containers](./setup_geocodes_services_containers.md)
3. [Initial setup of services and loading of data](./setup_indexing_with_gleanerio.md)
4. [Setup Geocodes UI using datastores defined in Initial Setup](./setup_geocodes_ui_containers.md)

Steps:

2. create data stores in minioadmin and graph
2.  install glcon, if not installed
3. create a configuration file to install a small set of data
    4. `./glcon config init --cfgName gctest`
    5.  edit
    6. `./glcon config generate --cfgName gctest`
4. setup and summon data using 'gleaner' 
    5. `./glcon gleaner setup --cfgName gctest`
    7. `./glcon config generate --cfgName gctest`
5. load data to graph using 'nabu' 
    6. `./glcon nabu prefix --cfgName gctest`
    7. `./glcon nabu prune --cfgName gctest`
8. Test data in Graph 
9. Example of how to edit the source
   8. edit gctest.csv
   9. regenerate configs
   10. rerun batch
10. Run Summarize task. This is performance related.

!!! warn "regenerate"
if you edit localConfig.yaml, you need to regenerate the configs using
`./glcon config generate --cfgName gctest`

---

## Setup Datastores

There are several datastores required to enable data summoning(harvesting), converting to a graph.
While the production presently uses the earthcube repository convention, we suggest that 
tutorial and communities setting up an instance to use the geocodes repository pattern.
Earthcube/Decoder staff should use the A Community pattern when setting up an instance for a community.


| Repository             | config            | s3 Bucket | graph namespaces           | notes                           |
|------------------------|-------------------|-----------|----------------------------|---------------------------------|
| **GeocodesTest**           | **gctest**            | **gctest**      | **gctest**, **gctest_summary**         | samples of actual datasets      |
| geocodes               | geocodes          | geocodes  | geocodes, geocodes_summary | suggested standalone repository |
| earthcube              | geocodes          | gleaner   | earthcube, summary         | DEFAULT PRODUCTION NAME         |
| A COMMUNITY eg {acomm} | {acomm}           | {acomm}   | {acomm}, {acomm}_summary   | A communities tenant repository |

!!! note "Initial Setup"
    we will be setting up both the gctest and gecodes repositories.

### Setup Minio buckets
Gleaner extracts JSONLD from a web apge, and stores it in an s3 system (Minio)
in 

go to https://minioadmin.{youhost}/
 
create buckets gctest, and geocodes

go to settings for the bucket and make  public.

### Setup Graph stores.

Nabu pulls from the s3 system, converts to RDF quads, and uploads to a graph store.

go to https://graph.{your host}

namespace tab, create  a mode **'quads'** namespace with full text index, 
"gctest", and "geocodes"

namespace tab, create mode **'triples'** namespace with full text index,
"gctest_summary", and "geocodes_summary"

## Install Indexing Software
`glcon` is a console application that combines the functionality of Gleaner and Nabu into a single application.
It also has features to create and manage configurations for gleaner and nabu.

[Install glcon](install_glcon.md)

## Harvest and load data 

Goal is to create a configuration file to load gctest data.
The sitemap is here:

### Create a configuration and load sample data

#### Create a configuration for Continuous Integration 

??? example "`./glcon config init --cfgName gctest`"
    ```shell
       ubuntu@geocodes-dev:~/indexing$ ./glcon config init --cfgName gctest
        2022/07/21 23:27:31 EarthCube Gleaner
        init called
        make a config template is there isn't already one
        ubuntu@geocodes-dev:~/indexing$ ls configs/gctest
        README_Configure_Template.md  localConfig.yaml  sources.csv
        gleaner_base.yaml             nabu_base.yaml
        ubuntu@geocodes-dev:~/indexing$ 
    ```
#### Copy sources list to configs/gctest
!!! note
    assumes you are in indexing, and have put the geocodes at ~/geocodes aka your home directory

`cp ~/geocodes/deployment/ingestconfig/gctest.csv configs/gctest/`

#### edit files: 
You will need to change the localConfig.yaml

??? example "`nano configs/gctest/localConfig.yaml`"
    ```{ .yaml .copy }
    ---
    minio:
      address: oss.{YOU HOST}
      port: 433
      accessKey: worldsbestaccesskey
      secretKey: worldsbestaccesskey
      ssl: true
      bucket: gctest # can be overridden with MINIO_BUCKET
    sparql:
      endpoint: https://graph.{YOU HOST}/blazegraph/namespace/gctest/sparql
    s3:
      bucket: gctest # sync with above... can be overridden with MINIO_BUCKET... get's zapped if it's not here.
      domain: us-east-1 
    #headless field in gleaner.summoner
    headless: http://127.0.0.1:9222
    sourcesSource:
      type: csv
      location: gctest.csv 
    # this can be a remote csv
    #  type: csv
    #  location: https://docs.google.com/spreadsheets/d/1G7Wylo9dLlq3tmXe8E8lZDFNKFDuoIEeEZd3epS0ggQ/gviz/tq?tqx=out:csv&sheet=TestDatasetSources
    ```
!!! warn "regenerate"
    if you edit localConfig.yaml, you need to regenerate the configs using
    `./glcon config generate --cfgName gctest`

####  Generate configs 


??? example "`./glcon config generate --cfgName gctest`"
    ```shell
    ./glcon config generate --cfgName gctest
    2022/07/21 23:37:46 EarthCube Gleaner
    generate called
    {SourceType:sitemap Name:geocodes_demo_datasets Logo:https://github.com/earthcube/GeoCODES-Metadata/metadata/OtherResources URL:https://raw.githubusercontent.com/earthcube/GeoCODES-Metadata/gh-pages/metadata/Dataset/sitemap.xml Headless:false PID:https://www.earthcube.org/datasets/ ProperName:Geocodes Demo Datasets Domain:0 Active:true CredentialsFile: Other:map[] HeadlessWait:0}
    make copy of servers.yaml
    Regnerate gleaner
    Regnerate nabu
    ```

####  flightest
Run setup to see if you can connect to the minio store

??? example "`./glcon gleaner setup --cfgName gctest"
     ```shell
        ubuntu@geocodes-dev:~/indexing$ ./glcon gleaner setup --cfgName gctest
        2022/07/21 23:42:54 EarthCube Gleaner
        Using gleaner config file: /home/ubuntu/indexing/configs/gctest/gleaner
        Using nabu config file: /home/ubuntu/indexing/configs/gctest/nabu
        setup called
        2022/07/21 23:42:54 Validating access to object store
        2022/07/21 23:42:54 Connection issue, make sure the minio server is running and accessible. The specified bucket does not exist.
        ubuntu@geocodes-dev:~/indexing$ 
     ```

!!! hint "Access issues"
    ```json
    {“file”:“/github/workspace/internal/organizations/org.go:87",“func”:“github.com/gleanerio/gleaner/internal/organizations.BuildGraph”,“level”:“error”,“msg”:“orgs/geocodes_demo_datasets.nqThe Access Key Id you provided does not exist in our records.“,”time”:“2023-01-31T15:27:39-06:00”}
    ```

    * **Access Key** password could be incorrect
    * **address** may be incorrect. It is a hostname or TC/IP, and not a URL
    * **ssl** may need to be true
    * [See setup issues](./troubleshooting.md#setup-failure)


#### Load Data
 
Gleaner will harvest jsonld from the URL's listed in the sitemap.

!!! warning "Robots.txt"
    OK TO IGNORE. you will need to ignore errors about robot.txt and sitemap.xml not being an index
    ```json
    {"file":"/github/workspace/internal/summoner/acquire/resources.go:204","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.getRobotsForDomain","level":"error","msg":"error getting robots.txt for https://www.earthcube.org/datasets/allgood:Robots.txt unavailable at https://www.earthcube.org/datasets/allgood/robots.txt","time":"2023-01-30T20:45:53-06:00"}
    {"file":"/github/workspace/internal/summoner/acquire/resources.go:66","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.ResourceURLs","level":"error","msg":"Error getting robots.txt for geocodes_demo_datasets, continuing without it.","time":"2023-01-30T20:45:53-06:00"}    
    ```

!!! warning "Access issues"
    ```json
    {“file”:“/github/workspace/internal/organizations/org.go:87",“func”:“github.com/gleanerio/gleaner/internal/organizations.BuildGraph”,“level”:“error”,“msg”:“orgs/geocodes_demo_datasets.nqThe Access Key Id you provided does not exist in our records.“,”time”:“2023-01-31T15:27:39-06:00”}
    ```

    * **Access Key** password could be incorrect 
    * **address** may be incorrect. It is a hostname or TC/IP, and not a URL
    * **ssl** may need to be true
    * [See setup issues](./troubleshooting.md#setup-failure)

??? example "`./glcon gleaner batch --cfgName gctest`"
    ```shell
    ubuntu@geocodes-dev:~/indexing$ ./glcon gleaner batch --cfgName gctest
    INFO[0000] EarthCube Gleaner                            
    Using gleaner config file: /home/ubuntu/indexing/configs/gctest/gleaner
    Using nabu config file: /home/ubuntu/indexing/configs/gctest/nabu
    batch called
    {"file":"/github/workspace/internal/organizations/org.go:55","func":"github.com/gleanerio/gleaner/internal/organizations.BuildGraph","level":"info","msg":"Building organization graph.","time":"2022-07-22T19:16:53Z"}
    {"file":"/github/workspace/pkg/gleaner.go:35","func":"github.com/gleanerio/gleaner/pkg.Cli","level":"info","msg":"Sitegraph(s) processed","time":"2022-07-22T19:16:53Z"}
    {"file":"/github/workspace/internal/summoner/summoner.go:17","func":"github.com/gleanerio/gleaner/internal/summoner.Summoner","level":"info","msg":"Summoner start time:2022-07-22 19:16:53.451745139 +0000 UTC m=+0.182100234","time":"2022-07-22T19:16:53Z"}
    {"file":"/github/workspace/internal/summoner/acquire/resources.go:189","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.getRobotsForDomain","level":"info","msg":"Getting robots.txt from 0/robots.txt","time":"2022-07-22T19:16:53Z"}
    {"file":"/github/workspace/internal/summoner/acquire/utils.go:23","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.getRobotsTxt","level":"error","msg":"error fetching robots.txt at 0/robots.txtGet \"0/robots.txt\": unsupported protocol scheme \"\"","time":"2022-07-22T19:16:53Z"}
    {"file":"/github/workspace/internal/summoner/acquire/resources.go:192","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.getRobotsForDomain","level":"error","msg":"error getting robots.txt for 0:Get \"0/robots.txt\": unsupported protocol scheme \"\"","time":"2022-07-22T19:16:53Z"}
    {"file":"/github/workspace/internal/summoner/acquire/resources.go:63","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.ResourceURLs","level":"error","msg":"Error getting robots.txt for geocodes_demo_datasetscontinuing without it.","time":"2022-07-22T19:16:53Z"}
    {"file":"/github/workspace/internal/summoner/acquire/resources.go:127","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.getSitemapURLList","level":"info","msg":"https://raw.githubusercontent.com/earthcube/GeoCODES-Metadata/gh-pages/metadata/Dataset/sitemap.xml is not a sitemap index, checking to see if it is a sitemap","time":"2022-07-22T19:16:53Z"}
    {"file":"/github/workspace/internal/summoner/acquire/acquire.go:32","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.ResRetrieve","level":"info","msg":"Queuing URLs for geocodes_demo_datasets","time":"2022-07-22T19:16:53Z"}
    {"file":"/github/workspace/internal/summoner/acquire/acquire.go:74","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.getConfig","level":"info","msg":"Thread count 5 delay 0","time":"2022-07-22T19:16:53Z"}
    {"file":"/github/workspace/internal/summoner/acquire/jsonutils.go:89","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.Upload","level":"info","msg":"context.strict is not set to true; doing json-ld fixups.","time":"2022-07-22T19:16:53Z"}
    {"file":"/github/workspace/internal/summoner/acquire/jsonutils.go:89","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.Upload","level":"info","msg":"context.strict is not set to true; doing json-ld fixups.","time":"2022-07-22T19:16:53Z"}
    {"file":"/github/workspace/internal/summoner/acquire/jsonutils.go:89","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.Upload","level":"info","msg":"context.strict is not set to true; doing json-ld fixups.","time":"2022-07-22T19:16:53Z"}
    {"file":"/github/workspace/internal/summoner/acquire/jsonutils.go:89","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.Upload","level":"info","msg":"context.strict is not set to true; doing json-ld fixups.","time":"2022-07-22T19:16:54Z"}
    {"file":"/github/workspace/internal/summoner/acquire/jsonutils.go:89","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.Upload","level":"info","msg":"context.strict is not set to true; doing json-ld fixups.","time":"2022-07-22T19:16:54Z"}
    12% |██████                                                 | (2/16, 2 it/s) [0s:7s]{"file":"/github/workspace/internal/summoner/acquire/jsonutils.go:89","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.Upload","level":"info","msg":"context.strict is not set to true; doing json-ld fixups.","time":"2022-07-22T19:16:54Z"}
    {"file":"/github/workspace/internal/summoner/acquire/jsonutils.go:89","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.Upload","level":"info","msg":"context.strict is not set to true; doing json-ld fixups.","time":"2022-07-22T19:16:54Z"}
    {"file":"/github/workspace/internal/summoner/acquire/jsonutils.go:89","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.Upload","level":"info","msg":"context.strict is not set to true; doing json-ld fixups.","time":"2022-07-22T19:16:54Z"}
    {"file":"/github/workspace/internal/summoner/acquire/jsonutils.go:89","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.Upload","level":"info","msg":"context.strict is not set to true; doing json-ld fixups.","time":"2022-07-22T19:16:54Z"}
    {"file":"/github/workspace/internal/summoner/acquire/jsonutils.go:89","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.Upload","level":"info","msg":"context.strict is not set to true; doing json-ld fixups.","time":"2022-07-22T19:16:54Z"}
    43% |███████████████████████                                | (7/16, 6 it/s) [1s:1s]{"file":"/github/workspace/internal/summoner/acquire/jsonutils.go:89","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.Upload","level":"info","msg":"context.strict is not set to true; doing json-ld fixups.","time":"2022-07-22T19:16:54Z"}
    68% |████████████████████████████████████                  | (11/16, 6 it/s) [1s:0s]{"file":"/github/workspace/internal/summoner/acquire/jsonutils.go:89","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.Upload","level":"info","msg":"context.strict is not set to true; doing json-ld fixups.","time":"2022-07-22T19:16:55Z"}
    {"file":"/github/workspace/internal/summoner/acquire/jsonutils.go:89","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.Upload","level":"info","msg":"context.strict is not set to true; doing json-ld fixups.","time":"2022-07-22T19:16:55Z"}
    {"file":"/github/workspace/internal/summoner/acquire/jsonutils.go:89","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.Upload","level":"info","msg":"context.strict is not set to true; doing json-ld fixups.","time":"2022-07-22T19:16:55Z"}
    75% |████████████████████████████████████████              | (12/16, 6 it/s) [1s:0s]{"file":"/github/workspace/internal/summoner/acquire/jsonutils.go:89","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.Upload","level":"info","msg":"context.strict is not set to true; doing json-ld fixups.","time":"2022-07-22T19:16:55Z"}
    {"file":"/github/workspace/internal/summoner/acquire/jsonutils.go:89","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.Upload","level":"info","msg":"context.strict is not set to true; doing json-ld fixups.","time":"2022-07-22T19:16:55Z"}
    100% |██████████████████████████████████████████████████████| (16/16, 9 it/s)        
    {"file":"/github/workspace/internal/summoner/summoner.go:37","func":"github.com/gleanerio/gleaner/internal/summoner.Summoner","level":"info","msg":"Summoner end time:2022-07-22 19:16:55.660367672 +0000 UTC m=+2.390721648","time":"2022-07-22T19:16:55Z"}
    {"file":"/github/workspace/internal/summoner/summoner.go:38","func":"github.com/gleanerio/gleaner/internal/summoner.Summoner","level":"info","msg":"Summoner run time:0.0368103569","time":"2022-07-22T19:16:55Z"}
    {"file":"/github/workspace/internal/millers/millers.go:27","func":"github.com/gleanerio/gleaner/internal/millers.Millers","level":"info","msg":"Miller start time2022-07-22 19:16:55.661434567 +0000 UTC m=+2.391819553","time":"2022-07-22T19:16:55Z"}
    {"file":"/github/workspace/internal/millers/millers.go:44","func":"github.com/gleanerio/gleaner/internal/millers.Millers","level":"info","msg":"Adding bucket to milling list:summoned/geocodes_demo_datasets","time":"2022-07-22T19:16:55Z"}
    {"file":"/github/workspace/internal/millers/millers.go:55","func":"github.com/gleanerio/gleaner/internal/millers.Millers","level":"info","msg":"Adding bucket to prov building list:prov/geocodes_demo_datasets","time":"2022-07-22T19:16:55Z"}
    100% |█████████████████████████████████████████████████████| (15/15, 51 it/s)        
    {"file":"/github/workspace/internal/millers/graph/graphng.go:82","func":"github.com/gleanerio/gleaner/internal/millers/graph.GraphNG","level":"info","msg":"Assembling result graph for prefix:summoned/geocodes_demo_datasetsto:milled/geocodes_demo_datasets","time":"2022-07-22T19:16:56Z"}
    {"file":"/github/workspace/internal/millers/graph/graphng.go:83","func":"github.com/gleanerio/gleaner/internal/millers/graph.GraphNG","level":"info","msg":"Result graph will be at:results/runX/geocodes_demo_datasets_graph.nq","time":"2022-07-22T19:16:56Z"}
    {"file":"/github/workspace/internal/millers/graph/graphng.go:89","func":"github.com/gleanerio/gleaner/internal/millers/graph.GraphNG","level":"info","msg":"Pipe copy for graph done","time":"2022-07-22T19:16:56Z"}
    {"file":"/github/workspace/internal/millers/millers.go:84","func":"github.com/gleanerio/gleaner/internal/millers.Millers","level":"info","msg":"Miller end time:2022-07-22 19:16:56.387639969 +0000 UTC m=+3.117994225","time":"2022-07-22T19:16:56Z"}
    {"file":"/github/workspace/internal/millers/millers.go:85","func":"github.com/gleanerio/gleaner/internal/millers.Millers","level":"info","msg":"Miller run time:0.0121029112","time":"2022-07-22T19:16:56Z"}
    ```
!!! note "See files in Minio"
    You can open the minioadmin console (https://minioadmin.{your host}/) and look to see that file are
    uploaded into the bucket, in this case gctest.. summon/gecodes_demo_data

(NEED IMAGE HERE)

####  Push to graph
Nabu will read files from the bucket, and push them to the graph store.

??? example "`./glcon nabu prefix --cfgName gctest`" 
    ```json lines
    ./glcon nabu prefix --cfgName gctest
    INFO[0000] EarthCube Gleaner                            
    Using gleaner config file: /home/ubuntu/indexing/configs/gctest/gleaner
    Using nabu config file: /home/ubuntu/indexing/configs/gctest/nabu
    check called
    2022/07/22 19:23:16 Load graphs from prefix to triplestore
    {"file":"/go/pkg/mod/github.com/gleanerio/nabu@v0.0.0-20220223141452-a01fa9352430/internal/sparqlapi/pipeload.go:41","func":"github.com/gleanerio/nabu/internal/sparqlapi.ObjectAssembly","level":"info","msg":"[milled/geocodes_demo_datasets prov/geocodes_demo_datasets org]","time":"2022-07-22T19:23:16Z"}
    {"file":"/go/pkg/mod/github.com/gleanerio/nabu@v0.0.0-20220223141452-a01fa9352430/internal/sparqlapi/pipeload.go:61","func":"github.com/gleanerio/nabu/internal/sparqlapi.ObjectAssembly","level":"info","msg":"gleaner:milled/geocodes_demo_datasets object count: 15\n","time":"2022-07-22T19:23:16Z"}
    {"file":"/go/pkg/mod/github.com/gleanerio/nabu@v0.0.0-20220223141452-a01fa9352430/internal/sparqlapi/pipeload.go:79","func":"github.com/gleanerio/nabu/internal/sparqlapi.PipeLoad","level":"info","msg":"Loading milled/geocodes_demo_datasets/11316929f925029101493e8a05d043b0ae829559.rdf \n","time":"2022-07-22T19:23:16Z"}
    [snip]
    {"file":"/go/pkg/mod/github.com/gleanerio/nabu@v0.0.0-20220223141452-a01fa9352430/internal/sparqlapi/pipeload.go:197","func":"github.com/gleanerio/nabu/internal/sparqlapi.Insert","level":"info","msg":"response Status: 200 OK","time":"2022-07-22T19:23:21Z"}
    {"file":"/go/pkg/mod/github.com/gleanerio/nabu@v0.0.0-20220223141452-a01fa9352430/internal/sparqlapi/pipeload.go:198","func":"github.com/gleanerio/nabu/internal/sparqlapi.Insert","level":"info","msg":"response Headers: map[Access-Control-Allow-Credentials:[true] Access-Control-Allow-Headers:[Authorization,Origin,Content-Type,Accept] Access-Control-Allow-Origin:[*] Content-Length:[449] Content-Type:[text/html;charset=utf-8] Date:[Fri, 22 Jul 2022 19:23:21 GMT] Server:[Jetty(9.4.z-SNAPSHOT)] Vary:[Origin] X-Frame-Options:[SAMEORIGIN]]","time":"2022-07-22T19:23:21Z"}
    100% |███████████████████████████████████████████████████████| (1/1, 15 it/s)
    
    ```

####  Test in Graph

One the data is loaded into the graph store
`https://graph.{your host}/blazegraph/#query`

1. go to namespace tab, select gctest, 
1. go to query tab, input the 

??? example "returns all triples" 
    ```sparql
    select * 
    where {
    ?s ?p ?o
     }
    limit 1000
    ```
A more complex query can be ran:
??? example "what types are in the system"
    ```{.sparql .copy}
    prefix schema: <https://schema.org/>
    SELECT  ?type  (count(distinct ?s ) as ?scount)
    WHERE {
    {
           ?s a ?type .
           }
    } 
    GROUP By ?type
    ORDER By DESC(?scount)
    ```
A more complex query can be ran:
??? example "Show me just datasets"
    ```{.sparql .copy}
    SELECT (count(?g ) as ?count) 
    WHERE     {     GRAPH ?g {?s a <https://schema.org/Dataset>}}
    ```
More [SPARQL Examples](production/sparql.md)

## Example of how to edit the source

This demonstrates a feature where if you have duplicate identifiers, then you can ensure all
data get loaded. It's a bad idea to have the same ID, but it happens.

There are two lines in gctest csv. 
The second dataset is [actual data]
(https://github.com/earthcube/GeoCODES-Metadata/tree/main/metadata/Dataset/actualdata). 
There are three files, the two earthchem files have the same @id,
[1](https://github.com/earthcube/GeoCODES-Metadata/blob/9a41929bbead71c42a2066120480ae1375d952e7/metadata/Dataset/actualdata/earthchem1.json#L6)
[2](hhttps://github.com/earthcube/GeoCODES-Metadata/blob/9a41929bbead71c42a2066120480ae1375d952e7/metadata/Dataset/actualdata/earthchem2.json#L6)
The identifierType is set to 'filesha' which generates a sha based on the entire file.


??? info "gctest cs"
    ``` csv
    hack,SourceType,Active,Name,ProperName,URL,Headless,HeadlessWait,IdentifierType,IdentifierPath,Domain,PID,Logo,validator link,NOTE
    58,sitemap,TRUE,geocodes_demo_datasets,Geocodes Demo Datasets,https://earthcube.github.io/GeoCODES-Metadata/metadata/Dataset/allgood/sitemap.xml,FALSE,0,identifiersha,,https://www.earthcube.org/datasets/allgood,https://github.com/earthcube/GeoCODES-Metadata/metadata/OtherResources,,,
    59,sitemap,FALSE,geocodes_actual_datasets,Geocodes Actual Datasets,https://earthcube.github.io/GeoCODES-Metadata/metadata/Dataset/actualdata/sitemap.xml,FALSE,0,filesha,,https://www.earthcube.org/datasets/actual,https://github.com/earthcube/GeoCODES-Metadata/metadata/,,,
    ```

### edit gctest.csv
Set the second line active to TRUE

??? info "edited gctest cs"
    ``` csv
    hack,SourceType,Active,Name,ProperName,URL,Headless,HeadlessWait,IdentifierType,IdentifierPath,Domain,PID,Logo,validator link,NOTE
    58,sitemap,TRUE,geocodes_demo_datasets,Geocodes Demo Datasets,https://earthcube.github.io/GeoCODES-Metadata/metadata/Dataset/allgood/sitemap.xml,FALSE,0,identifiersha,,https://www.earthcube.org/datasets/allgood,https://github.com/earthcube/GeoCODES-Metadata/metadata/OtherResources,,,
    59,sitemap,TRUE,geocodes_actual_datasets,Geocodes Actual Datasets,https://earthcube.github.io/GeoCODES-Metadata/metadata/Dataset/actualdata/sitemap.xml,FALSE,0,filesha,,https://www.earthcube.org/datasets/actual,https://github.com/earthcube/GeoCODES-Metadata/metadata/,,,
    ```

### regenerate configs
`./glcon config generate --cfgName gctest`

### rerun batch

??? example "`./glcon gleaner batch --cfgName gctest`"
    ```shell
    ubuntu@geocodes:~/indexing$ ./glcon gleaner batch --cfgName gctest
    version:  v3.0.8-fix129
    batch called
    {"file":"/github/workspace/internal/summoner/acquire/resources.go:204","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.getRobotsForDomain","level":"error","msg":"error getting robots.txt for https://www.earthcube.org/datasets/allgood:Robots.txt unavailable at https://www.earthcube.org/datasets/allgood/robots.txt","time":"2023-01-30T21:09:49-06:00"}
    {"file":"/github/workspace/internal/summoner/acquire/resources.go:66","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.ResourceURLs","level":"error","msg":"Error getting robots.txt for geocodes_demo_datasets, continuing without it.","time":"2023-01-30T21:09:49-06:00"}
    {"file":"/github/workspace/internal/summoner/acquire/resources.go:204","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.getRobotsForDomain","level":"error","msg":"error getting robots.txt for https://www.earthcube.org/datasets/actual:Robots.txt unavailable at https://www.earthcube.org/datasets/actual/robots.txt","time":"2023-01-30T21:09:49-06:00"}
    {"file":"/github/workspace/internal/summoner/acquire/resources.go:66","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.ResourceURLs","level":"error","msg":"Error getting robots.txt for geocodes_actual_datasets, continuing without it.","time":"2023-01-30T21:09:49-06:00"}
     100% |███████████████████████████████████████████████████████████████████████████████████████████| (3/3, 10 it/s)        
     100% |███████████████████████████████████████████████████████████████████████████████████████████| (9/9, 25 it/s)        
    RunStats:
      Start: 2023-01-30 21:09:49.120833598 -0600 CST m=+0.105789938
      Repositories:
        - name: geocodes_demo_datasets
          SitemapCount: 9 
          SitemapHttpError: 0 
          SitemapIssues: 0 
          SitemapSummoned: 9 
          SitemapStored: 9 
        - name: geocodes_actual_datasets
          SitemapSummoned: 3 
          SitemapStored: 3 
          SitemapCount: 3 
          SitemapHttpError: 0 
          SitemapIssues: 0 
     100% |██████████████████████████████████████████████████████████████████████████████████████████| (9/9, 168 it/s)
     100% |██████████████████████████████████████████████████████████████████████████████████████████| (2/2, 123 it/s)
    ```


## Create  a materialized view of the data using summarize to the  repo_summary namespace

!!! warning "DOCUMENTATION NEEDED " 
    (TBD assigned to Mike Bobak)


## Go to step 4.

1. [Install base containers on a server](./stack_machines.md)
2. [Setup services containers](./setup_geocodes_services_containers.md)
3. [Initial setup of services and loading of data](./setup_indexing_with_gleanerio.md)
4. [Setup Geocodes UI using datastores defined in Initial Setup](./setup_geocodes_ui_containers.md)
