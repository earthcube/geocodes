# Production Configuration
setting up the 'production' config files
This example is using geocodes-dev.earthcube.org
Should this be an actual production configuration, the names need to be changed to protect the innocent

## Overview
1. Setup Datastores
2. install glcon
1. create a new configuration directory
1. edit the local config for the configuration
1. Generate the configuration files for gleaner and nabu
1. setup minio using glcon gleaner setup
2. start a screen (adds ability to run long running processes)
1. run gleaner
1. run nabu

## Setup Datastores

If you followed the (setup indexing)[../setup_indexing_with_gleanerio.md] steps, you should have the datastores needed
already created. 
The production presently uses the earthcube repository convention, and that is what this document will use


| Repository             | config            | s3 Bucket | graph namespaces           | notes                           |
|------------------------|-------------------|-----------|----------------------------|---------------------------------|
| GeocodesTest           | gctest            | gctest      | gctest, gctest_summary         | samples of actual datasets      |
| geocodes               | geocodes          | geocodes  | geocodes, geocodes_summary | suggested standalone repository |
| **earthcube**              | geocodes          | **gleaner**   | **earthcube, summary**         | DEFAULT PRODUCTION NAME         |
| A COMMUNITY eg {acomm} | {acomm}           | {acomm}   | {acomm}, {acomm}_summary   | A communities tenant repository |

 
## Install glcon
```shell
cd 
ls indexing
```

If glcon does not exist
[Install glcon](../install_glcon.md)

## create a new configuration directory
```shell
cd indexing
./glcon config init --cfgName geocodes
```

See that it is created.

`ls configs/`

`ls configs/geocodes`

note there a only a few files.

### edit the local config for the configuration
`nano configs/geocodes/localConfig.yaml`

values need to match your {myhost}.env file

!!! note "**production** model for post step 4"
    Portions of deployment/facets/config.yaml that might be changed.
    This is for **production**. IF you completed the initial data load using gctest,
    then you can modify
    and rebuild the geecodes stack using **Updating a GEOCODES CLIENT Configuration production configuration**
    in (Manging Geocodes UI containers)[./production/managing_geocodes_ui_containers.md]

    ??? example "**production** section of deployment/facets/config.yaml"
        ```{.yaml .copy}
        API_URL: https://geocodes.{your host}/ec/api/
        SPARQL_NB: https:/geocodes.{your host}/notebook/mkQ?q=${q}
        SPARQL_YASGUI: https://geocodes.{your host}/sparqlgui?
        #API_URL: "${window_location_origin}/ec/api"
        #TRIPLESTORE_URL: https://graph.geocodes-1.earthcube.org/blazegraph/namespace/earthcube/sparql
        TRIPLESTORE_URL: https://graph.{your host}/blazegraph/namespace/earthcube/sparql
        BLAZEGRAPH_TIMEOUT: 20
        ## ECRR need to use fuseki source, for now.
        ECRR_TRIPLESTORE_URL: http://132.249.238.169:8080/fuseki/ecrr/query 
        # ECRR_TRIPLESTORE_URL:   http://{your host}/blazegraph/namespace/ecrr/sparql 
        ECRR_GRAPH: http://earthcube.org/gleaner-summoned
        THROUGHPUTDB_URL: https://throughputdb.com/api/ccdrs/annotations
        SPARQL_QUERY: queries/sparql_query.txt
        SPARQL_HASTOOLS: queries/sparql_hastools.txt
        SPARQL_TOOLS_WEBSERVICE: queries/sparql_gettools_webservice.txt
        SPARQL_TOOLS_DOWNLOAD: queries/sparql_gettools_download.txt
        # JSONLD_PROXY needs qoutes... since it has a $
        JSONLD_PROXY: "https://geocodes.{your host}/ec/api/${o}"
        
        SPARQL_YASGUI: https://sparqlui.{your host}/?
        ```

### Generate the configuration files for gleaner and nabu
??? example "`./glcon config generate --cfgName geocodes`"
    ```shell
    
    
    ./glcon config generate --cfgName geocodes
    INFO[0000] EarthCube Gleaner                            
    generate called
    {SourceType:sitemap Name:balto Logo:http://balto.opendap.org/opendap/docs/images/logo.png URL:http://balto.opendap.org/opendap/site_map.txt  Headless:false PID:http://balto.opendap.org ProperName:Balto Domain:http://balto.opendap.org Active:false CredentialsFile: Other:map[] HeadlessWait:0 Delay:0}
    {SourceType:sitemap Name:neotomadb Logo:https://www.neotomadb.org/images/site_graphics/Packrat.png URL:http://data.neotomadb.org/sitemap.xml Headless:true PID:http://www.re3data.org/repository/r3d100011761 ProperName:Neotoma Domain:http://www.neotomadb.org/ Active:false CredentialsFile: Other:map[] HeadlessWait:0 Delay:0}
    #{SNIP]
    {SourceType:sitemap Name:usap-dc Logo:https://www.usap-dc.org/ URL:https://www.usap-dc.org/view/dataset/sitemap.xml Headless:true PID:https://www.re3data.org/repository/r3d100010660 ProperName:U.S. Antarctic Program Data Center Domain:https://www.usap-dc.org/ Active:true CredentialsFile: Other:map[] HeadlessWait:0 Delay:0}
    {SourceType:sitemap Name:cchdo Logo:https://cchdo.ucsd.edu/static/svg/logo_cchdo.svg URL:https://cchdo.ucsd.edu/sitemap.xml Headless:false PID:https://www.re3data.org/repository/r3d100010831 ProperName:CLIVAR and Carbon Hydrographic Data Office Domain:https://cchdo.ucsd.edu/ Active:true CredentialsFile: Other:map[] HeadlessWait:0 Delay:0}
    {SourceType:sitemap Name:amgeo Logo:https://amgeo.colorado.edu/static/img/amgeosmall.svg URL:https://amgeo-dev.colorado.edu/sitemap.xml Headless:false PID: ProperName:Assimilative Mapping of Geospace Observations Domain:https://amgeo.colorado.edu/ Active:true CredentialsFile: Other:map[] HeadlessWait:0 Delay:0}
    make copy of servers.yaml
    Regnerate gleaner
    Regnerate nabu
    ```

Check:
`ls configs/geocodes`

Now there will be at least a 'gleaner', a 'nabu' and a 'nabu_prov' files.

### setup minio


??? example "`./glcon gleaner setup --cfgName geocodes`"
    This only needs to be done once
    ```shell
    ubuntu@geocodes-dev:~/indexing$ ./glcon gleaner setup --cfgName geocodes
    INFO[0000] EarthCube Gleaner                            
    Using gleaner config file: /home/ubuntu/indexing/configs/geocodes/gleaner
    Using nabu config file: /home/ubuntu/indexing/configs/geocodes/nabu
    setup called
    {"file":"/github/workspace/pkg/gleaner.go:60","func":"github.com/gleanerio/gleaner/pkg.Setup","level":"info","msg":"Validating access to object store","time":"2022-07-28T17:32:51Z"}
    {"file":"/github/workspace/pkg/gleaner.go:67","func":"github.com/gleanerio/gleaner/pkg.Setup","level":"info","msg":"Setting up buckets","time":"2022-07-28T17:32:51Z"}
    {"file":"/github/workspace/pkg/gleaner.go:78","func":"github.com/gleanerio/gleaner/pkg.Setup","level":"info","msg":"Buckets generated.  Object store should be ready for runs","time":"2022-07-28T17:32:51Z"}
    ```

## start a screen
Since this is a long running process, it is suggested that this be done in `screen`

### Notes: 
To create a 'named' screen named gleaner 

`screen -S gleaner`

to detach from screen, use: `ctl-a-d` 

to find running screens: `screen -ls`

```shell ""
There are screens on:
	7187.gleaner	(07/28/22 17:43:48)	(Detached)
	6879.pts-3.geocodes-dev	(07/28/22 17:33:25)	(Detached)
2 Sockets in /run/screen/S-ubuntu.
```

to attach to a screen  in this case you use the name 

`screen -r gleaner `

or

` screen -r pts-3 `


```shell
screen -S gleaner
ubuntu@geocodes-dev:~/indexing$ screen -ls
There is a screen on:
	7187.gleaner	(07/28/22 17:43:48)   (Attached)
1 Socket in /run/screen/S-ubuntu.
```

### run gleaner
??? example "`./glcon gleaner batch --cfgName geocodes`"
    ```shell
    ubuntu@geocodes-dev:~/indexing$ ./glcon gleaner batch --cfgName geocodes
    INFO[0000] EarthCube Gleaner                            
    Using gleaner config file: /home/ubuntu/indexing/configs/geocodes/gleaner
    Using nabu config file: /home/ubuntu/indexing/configs/geocodes/nabu
    batch called
    {"file":"/github/workspace/internal/organizations/org.go:55","func":"github.com/gleanerio/gleaner/internal/organizations.BuildGraph","level":"info","msg":"Building organization graph.","time":"2022-07-28T17:34:18Z"}
    {"file":"/github/workspace/internal/summoner/acquire/sitegraph.go:40","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.GetGraph","level":"info","msg":"Processing sitegraph file (this can be slow with little feedback):https://oih.aquadocs.org/aquadocs.json","time":"2022-07-28T17:34:18Z"}
    {"file":"/github/workspace/internal/summoner/acquire/sitegraph.go:41","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.GetGraph","level":"info","msg":"Downloading sitegraph file:https://oih.aquadocs.org/aquadocs.json","time":"2022-07-28T17:34:18Z"}
    {"file":"/github/workspace/internal/summoner/acquire/sitegraph.go:53","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.GetGraph","level":"info","msg":"Sitegraph file downloaded. Uploading togleanerhttps://oih.aquadocs.org/aquadocs.json","time":"2022-07-28T17:34:57Z"}
    {"file":"/github/workspace/internal/summoner/acquire/sitegraph.go:60","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.GetGraph","level":"info","msg":"Sitegraph file uploaded togleanerUploaded :https://oih.aquadocs.org/aquadocs.json","time":"2022-07-28T17:34:59Z"}
    
    [SNIP]
    ```

You can now detach,

`ctl-a-d`

watch the logs
`tail -f  logs/gleaner{somedate pattern}log`

to attach to a screen  in this case you use the name

`screen -r gleaner`

### run nabu prefix
when gleaner is complete

IF detached,  attach to a screen  in this case you use the name
`screen -r gleaner`

` ./glcon nabu prefix --cfgName geocodes`

### run nabu prefix to upload prov
This uses a separate config, for now.

IF detached,  attach to a screen  in this case you use the name
`screen -r gleaner`

` ./glcon nabu prefix --cfg configs/geocodes/nabuprov`



### run nabu prun
when gleaner is complete

IF detached,  attach to a screen  in this case you use the name
`screen -r gleaner`

` ./glcon nabu prune --cfgName geocodes`
