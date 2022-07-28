
# Loading Data for Testing and Validation
Goal: Load data from GeocodesMetadata Repository for testing

This will load data into  buckets that is for testing. Aka not in gleaner
let's use:
* ci
* ci2 

Testing Matrix
| Tests        | config | s3 Bucket | graph namespace | notes  |
| -----        | ------ | ----------| -------------------- | --------|
| GeocodesMeta | ci     | citesting | citesting |   just datasets |
| multiple     | ci2    | citesting2 | citesting2 | two repositories |
| DoubleLoad   | ci     | citesting | citesting |   Run Nabu a second time to try to load duplicates |


`glcon` is a console application that combines the functionality of Gleaner and Nabu into a single application. 
It also has features to create and manage configurations for gleaner and nabu.

## Install glcon
* create a directory
  * `cd ~ ; mkdir indexing`
* download and install:
  * `wget https://github.com/gleanerio/gleaner/releases/download/v3.0.4-dev/glcon-v3.0.4-dev-linux-amd64.tar.gz`
```    3.0.4-dev/glcon-v3.0.4-dev-linux-amd64.tar.gz
    --2022-07-21 23:04:55--  https://github.com/gleanerio/gleaner/releases/download/v3.0.4-dev/glcon-v3.0.4-dev-linux-amd64.tar.gz
    Resolving github.com (github.com)... 140.82.113.4
    Connecting to github.com (github.com)|140.82.113.4|:443... connected.
    HTTP request sent, awaiting response... 302 Found
    Location: https://objects.githubusercontent.com/github-production-release-asset-2e65be/127204495/28707eb9-9cd2-4d4e-8b94-5e27db26a08f?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20220721%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20220721T230428Z&X-Amz-Expires=300&X-Amz-Signature=668c44362081f0506f138cc52483f54d73fbd48fa906365ac80909b3b5e2b787&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=127204495&response-content-disposition=attachment%3B%20filename%3Dglcon-v3.0.4-dev-linux-amd64.tar.gz&response-content-type=application%2Foctet-stream [following]
    --2022-07-21 23:04:56--  https://objects.githubusercontent.com/github-production-release-asset-2e65be/127204495/28707eb9-9cd2-4d4e-8b94-5e27db26a08f?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20220721%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20220721T230428Z&X-Amz-Expires=300&X-Amz-Signature=668c44362081f0506f138cc52483f54d73fbd48fa906365ac80909b3b5e2b787&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=127204495&response-content-disposition=attachment%3B%20filename%3Dglcon-v3.0.4-dev-linux-amd64.tar.gz&response-content-type=application%2Foctet-stream
    Resolving objects.githubusercontent.com (objects.githubusercontent.com)... 185.199.109.133, 185.199.108.133, 185.199.111.133, ...
    Connecting to objects.githubusercontent.com (objects.githubusercontent.com)|185.199.109.133|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 13826668 (13M) [application/octet-stream]
    Saving to: ‘glcon-v3.0.4-dev-linux-amd64.tar.gz’

glcon-v3.0.4-dev-linux- 100%[=============================>]  13.19M  12.6MB/s    in 1.0s
```
  * `tar xf glcon-v3.0.4-dev-linux-amd64.tar.gz`
```
ubuntu@geocodes-dev:~/indexing$ tar xf glcon-v3.0.4-dev-linux-amd64.tar.gz
ubuntu@geocodes-dev:~/indexing$ ls
README.md  docs   glcon-v3.0.4-dev-linux-amd64.tar.gz  scripts
configs    glcon  schemaorg-current-https.jsonld
```
* test
```
ubuntu@geocodes-dev:~/indexing$ ./glcon --help
INFO[0000] EarthCube Gleaner                            
The gleaner.io stack harvests JSON-LD from webpages using sitemaps and other tools
store files in S3 (we use minio), uploads triples to be processed by nabu (the next step in the process)
configuration is now focused on a directory (default: configs/local) with will contain the
process to configure and run is:
* glcon config init --cfgName {default:local}
  edit files, servers.yaml, sources.csv
* glcon config generate --cfgName  {default:local}
* glcon gleaner Setup --cfgName  {default:local}
* glcon gleaner batch  --cfgName  {default:local}
* run nabu (better description)

Usage:
  glcon [command]

Available Commands:
  completion  generate the autocompletion script for the specified shell
  config      commands to intialize, and generate tools: gleaner and nabu
  gleaner     command to execute gleaner processes
  help        Help about any command
  nabu        command to execute nabu processes

Flags:
      --access string        Access Key ID (default "MySecretAccessKey")
      --address string       FQDN for server (default "localhost")
      --bucket string        The configuration bucket (default "gleaner")
      --cfg string           compatibility/overload: full path to config file (default location gleaner in configs/local)
      --cfgName string       config file (default is local so configs/local) (default "local")
      --cfgPath string       base location for config files (default is configs/) (default "configs")
      --gleanerName string   config file (default is local so configs/local) (default "gleaner")
  -h, --help                 help for glcon
      --nabuName string      config file (default is local so configs/local) (default "nabu")
      --port string          Port for minio server, default 9000 (default "9000")
      --secret string        Secret access key (default "MySecretSecretKeyforMinio")
      --ssl                  Use SSL boolean

Use "glcon [command] --help" for more information about a command.
```
* Create a configuration for Continuous Integration 
  * `./glcon config init --cfgName ci`
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
  * edit files: 
You will need to change the localConfig.yaml
      * `nano configs/ci/localConfig.yaml`
```yaml
---
minio:
  address: 127.0.0.1
  port: 433
  accessKey: worldsbestaccesskey
  secretKey: worldsbestaccesskey
  ssl: true
  bucket: citesting # can be overridden with MINIO_BUCKET
sparql:
  endpoint: https://graph.geocodes-dev.earthcube.org/blazegraph/namespace/earthcube/sparql
s3:
  bucket: citesting # sync with above... can be overridden with MINIO_BUCKET... get's zapped if it's not here.
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
  * Generate configs `./glcon config generate --cfgName ci`
```shell
./glcon config generate --cfgName ci
2022/07/21 23:37:46 EarthCube Gleaner
generate called
{SourceType:sitemap Name:geocodes_demo_datasets Logo:https://github.com/earthcube/GeoCODES-Metadata/metadata/OtherResources URL:https://raw.githubusercontent.com/earthcube/GeoCODES-Metadata/gh-pages/metadata/Dataset/sitemap.xml Headless:false PID:https://www.earthcube.org/datasets/ ProperName:Geocodes Demo Datasets Domain:0 Active:true CredentialsFile: Other:map[] HeadlessWait:0}
make copy of servers.yaml
Regnerate gleaner
Regnerate nabu
```
* flightest
  * ``` ubuntu@geocodes-dev:~/indexing$ ./glcon gleaner setup --cfgName ci
    2022/07/21 23:42:54 EarthCube Gleaner
    Using gleaner config file: /home/ubuntu/indexing/configs/ci/gleaner
    Using nabu config file: /home/ubuntu/indexing/configs/ci/nabu
    setup called
    2022/07/21 23:42:54 Validating access to object store
    2022/07/21 23:42:54 Connection issue, make sure the minio server is running and accessible. The specified bucket does not exist.
    ubuntu@geocodes-dev:~/indexing$ 
    ```
* run batch
  * `./glcon gleaner batch --cfgName ci`
```ubuntu@geocodes-dev:~/indexing$ ./glcon gleaner batch --cfgName ci
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
* push to graph
  * `./glcon nabu prefix --cfgName ci`
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
* Test in Graph
`https://graph.geocodes-dev.earthcube.org/blazegraph/#query`
returns all triples
```sparql
select * 
where {
  ?s ?p ?o
     }
limit 1000
```
  * query for amgeo
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
* test in client
  * `https://geocodes.geocodes-dev.earthcube.org`
  * terms
    * amgeo
    * bcodmo
    
