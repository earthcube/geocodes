
# Loading Data for Testing and Validation
Goal: Load data from GeocodesMetadata Repository for testing

The stories should be on the Geocodes Documentation Wiki.
[data validation and loading story](https://github.com/earthcube/geocodes_documentation/wiki/DataLoadingValidationStory)

This will load data into  buckets that is for testing. Aka not in gleaner

let's use:

* ci
* ci2 

Testing Matrix

| Tests          | config | s3 Bucket  | graph namespace | notes                                            |
|----------------|--------|------------| -------------------- |--------------------------------------------------|
| ReporitoryMeta | gctest | gctest   | gctest | samples of actual datasets                       |
| TestingMeta    | ci     | citesting  | citesting | Good Dataset                                     |
| multiple       | ci2    | citesting2 | citesting2 | two repositories                                 |
| DoubleLoad     | ci     | citesting  | citesting | Run Nabu a second time to try to load duplicates |

!!! note "gctest"
    gctest configuration and setup is described in [Setup](./setup_indexing_with_gleanerio.md)




## Install glcon
`glcon` is a console application that combines the functionality of Gleaner and Nabu into a single application.
It also has features to create and manage configurations for gleaner and nabu.

[Install glcon](install_glcon.md)

### Create a configuration for Continuous Integration 
??? example "`./glcon config init --cfgName ci`"
    ```shell
       ubuntu@geocodes-dev:~/indexing$ ./glcon config init --cfgName ci
        2022/07/21 23:27:31 EarthCube Gleaner
        init called
        make a config template is there isn't already one
        ubuntu@geocodes-dev:~/indexing$ ls configs/ci
        README_Configure_Template.md  localConfig.yaml  sources.csv
        gleaner_base.yaml             nabu_base.yaml
        ubuntu@geocodes-dev:~/indexing$ 
    ```

### edit files: 
You will need to change the localConfig.yaml

??? example "`nano configs/ci/localConfig.yaml`"
    ```yaml
    ---
    minio:
      address: oss.{HOST}
      port: 433
      accessKey: worldsbestaccesskey
      secretKey: worldsbestaccesskey
      ssl: true
      bucket: citesting
      # can be overridden with MINIO_BUCKET
    sparql:
      endpoint: https://graph.geocodes-dev.earthcube.org/blazegraph/namespace/earthcube/sparql
    s3:
      bucket: citesting
      # sync with above... can be overridden with MINIO_BUCKET... get's zapped if it's not here.
      domain: us-east-1
    #headless field in gleaner.summoner
    headless: http://127.0.0.1:9222
    sourcesSource:
      type: csv
    #  location: sources.csv 
    # this can be a remote csv
    #  type: csv
      location: https://docs.google.com/spreadsheets/d/1G7Wylo9dLlq3tmXe8E8lZDFNKFDuoIEeEZd3epS0ggQ/gviz/tq?tqx=out:csv&sheet=TestDatasetSources
    # TBD -- Just use the sources in the gleaner file.
    #  type: yaml
    #  location: gleaner.yaml
    ```

### Generate configs `./glcon config generate --cfgName ci`

??? example "`.`/glcon config generate --cfgName ci`"
    ```shell
    ./glcon config generate --cfgName ci
    2022/07/21 23:37:46 EarthCube Gleaner
    generate called
    {SourceType:sitemap Name:geocodes_demo_datasets Logo:https://github.com/earthcube/GeoCODES-Metadata/metadata/OtherResources URL:https://raw.githubusercontent.com/earthcube/GeoCODES-Metadata/gh-pages/metadata/Dataset/sitemap.xml Headless:false PID:https://www.earthcube.org/datasets/ ProperName:Geocodes Demo Datasets Domain:0 Active:true CredentialsFile: Other:map[] HeadlessWait:0}
    make copy of servers.yaml
    Regnerate gleaner
    Regnerate nabu
    ```

### flightest

??? example "`./glcon gleaner setup --cfgName ci`"
     ```shell
        ubuntu@geocodes-dev:~/indexing$ ./glcon gleaner setup --cfgName ci
        2022/07/21 23:42:54 EarthCube Gleaner
        Using gleaner config file: /home/ubuntu/indexing/configs/ci/gleaner
        Using nabu config file: /home/ubuntu/indexing/configs/ci/nabu
        setup called
        2022/07/21 23:42:54 Validating access to object store
        2022/07/21 23:42:54 Connection issue, make sure the minio server is running and accessible. The specified bucket does not exist.
        ubuntu@geocodes-dev:~/indexing$ 
     ```
    
### run batch

??? example ""./glcon gleaner batch --cfgName ci" 
    ```shell
        ubuntu@geocodes-dev:~/indexing$ ./glcon gleaner batch --cfgName ci
        INFO[0000] EarthCube Gleaner                            
        Using gleaner config file: /home/ubuntu/indexing/configs/ci/gleaner
        Using nabu config file: /home/ubuntu/indexing/configs/ci/nabu
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

### push to graph

??? example  "`./glcon nabu prefix --cfgName ci`"
    ```json lines
    ./glcon nabu prefix --cfgName ci
    INFO[0000] EarthCube Gleaner                            
    Using gleaner config file: /home/ubuntu/indexing/configs/ci/gleaner
    Using nabu config file: /home/ubuntu/indexing/configs/ci/nabu
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

### Test in Graph

`https://graph.geocodes-dev.earthcube.org/blazegraph/#query`


##### returns all triples

```sparql
select * 
where {
  ?s ?p ?o
     }
limit 1000
```

##### query for amgeo

```sparql
PREFIX bds: <http://www.bigdata.com/rdf/search#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix schema: <http://schema.org/>
prefix sschema: <https://schema.org/>
SELECT distinct ?subj ?g ?resourceType ?name ?description  ?pubname
(GROUP_CONCAT(DISTINCT ?placename; SEPARATOR=", ") AS ?placenames)
(GROUP_CONCAT(DISTINCT ?kwu; SEPARATOR=", ") AS ?kw)
?datep  (GROUP_CONCAT(DISTINCT ?url; SEPARATOR=", ") AS ?disurl) (MAX(?score1) as ?score)
(MAX(?lat) as ?maxlat) (Min(?lat) as ?minlat) (MAX(?lon) as ?maxlon) (Min(?lon) as ?minlon)
WHERE {
?lit bds:search "amgeo" .
?lit bds:matchAllTerms false .
?lit bds:relevance ?score1 .
?lit bds:minRelevance 0.14 .
?subj ?p ?lit .
#filter( ?score1 > 0.14).
graph ?g {
?subj schema:name|sschema:name ?name .
?subj schema:description|sschema:description ?description .
#Minus {?subj a sschema:ResearchProject } .
# Minus {?subj a schema:ResearchProject } .
# Minus {?subj a schema:Person } .
# Minus {?subj a sschema:Person } .
}
#BIND (IF (exists {?subj a schema:Dataset .} ||exists{?subj a sschema:Dataset .} , "data", "tool" ) AS ?resourceType).
values (?type ?resourceType) {
(schema:Dataset "data")
(sschema:Dataset "data")
(schema:ResearchProject "Research Project") #BCODMO- project
(sschema:ResearchProject  "Research Project")
(schema:SoftwareApplication  "tool")
(sschema:SoftwareApplication  "tool")
(schema:Person  "Person") #BCODMO- Person
(sschema:Person  "Person")
(schema:Event  "Event") #BCODMO- deployment
(sschema:Event  "Event")
(schema:Award  "Award") #BCODMO- Award
(sschema:Award  "Award")
(schema:DataCatalog  "DataCatalog")
(sschema:DataCatalog  "DataCatalog")
#(UNDEF "other")  # assume it's data. At least we should get  name.
} ?subj a ?type .
optional {?subj schema:distribution/schema:url|sschema:subjectOf/sschema:url ?url .}
OPTIONAL {?subj schema:datePublished|sschema:datePublished ?datep .}
OPTIONAL {?subj schema:publisher/schema:name|sschema:publisher/sschema:name|sschema:sdPublisher|sschema:provider/schema:name ?pubname .}
OPTIONAL {?subj schema:spatialCoverage/schema:name|sschema:spatialCoverage/sschema:name ?placename .}

OPTIONAL {?subj schema:keywords|sschema:keywords ?kwu .}

}
GROUP BY ?subj ?pubname ?placenames ?kw ?datep ?disurl ?score ?name ?description  ?resourceType ?g ?minlat ?maxlat ?minlon ?maxlon
ORDER BY DESC(?score)
LIMIT 100
OFFSET 0

```

### test in client

`https://geocodes.geocodes-dev.earthcube.org`

* terms
  * amgeo
  * bcodmo
    
## Detailed Testing

TODO **[Need to ses the datavalidaton story:](https://github.com/earthcube/geocodes_documentation/wiki/DataLoadingValidationStory)**
