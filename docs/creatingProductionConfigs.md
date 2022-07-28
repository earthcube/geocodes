
# setting up the 'production' config files
This example is using geocodes-dev.earthcube.org
Should this be an actual production configuration, the names need to be changed to protect the innocent


## create a new configuration directory
`./glcon config init --cfgName geocodes-dev`

# edit the local config for the configuraiton
`nano configs/geocodes-dev/localConfig.yaml`

```yaml
---
minio:
address: oss.geocodes-dev.earthcube.org
port: 443
accessKey: worldsbestaccesskey
secretKey: worldsbestsecretkey
ssl: true
bucket: gleaner # can be overridden with MINIO_BUCKET
sparql:
endpoint: http://localhost/blazegraph/namespace/earthcube/sparql
s3:
bucket: gleaner # sync with above... can be overridden with MINIO_BUCKET... get's zapped if it's not here.
domain: us-east-1

#headless field in gleaner.summoner
headless: http://127.0.0.1:9222
sourcesSource:
type: csv
#  location: sources.csv
location: https://docs.google.com/spreadsheets/d/1G7Wylo9dLlq3tmXe8E8lZDFNKFDuoIEeEZd3epS0ggQ/gviz/tq?tqx=out:csv&sheet=sources
# this can be a remote csv
#  type: csv
#  location: https://docs.google.com/spreadsheets/d/{key}/gviz/tq?tqx=out:csv&sheet={sheet_name}
# TBD -- Just use the sources in the gleaner file.
#  type: yaml
#  location: gleaner.yaml`
```

# Generate the configuration files for gleaner and nabu 
```shell


./glcon config generate --cfgName geocodes-dev
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

# setup minio 
This only needs to be done once
```shell
ubuntu@geocodes-dev:~/indexing$ ./glcon gleaner setup --cfgName geocodes-dev
INFO[0000] EarthCube Gleaner                            
Using gleaner config file: /home/ubuntu/indexing/configs/geocodes-dev/gleaner
Using nabu config file: /home/ubuntu/indexing/configs/geocodes-dev/nabu
setup called
{"file":"/github/workspace/pkg/gleaner.go:60","func":"github.com/gleanerio/gleaner/pkg.Setup","level":"info","msg":"Validating access to object store","time":"2022-07-28T17:32:51Z"}
{"file":"/github/workspace/pkg/gleaner.go:67","func":"github.com/gleanerio/gleaner/pkg.Setup","level":"info","msg":"Setting up buckets","time":"2022-07-28T17:32:51Z"}
{"file":"/github/workspace/pkg/gleaner.go:78","func":"github.com/gleanerio/gleaner/pkg.Setup","level":"info","msg":"Buckets generated.  Object store should be ready for runs","time":"2022-07-28T17:32:51Z"}
```

# run gleaner
Since this is a long running process, it is suggested that this be done in `screen`
Notes: 
To create a 'named' screen named gleaner 

`screen -S gleaner`

to detach from screen, use:
`ctl-a-d` 

to find running screens:
    `screen -ls`
```
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
ubuntu@geocodes-dev:~/indexing$ ./glcon gleaner batch --cfgName geocodes-dev
INFO[0000] EarthCube Gleaner                            
Using gleaner config file: /home/ubuntu/indexing/configs/geocodes-dev/gleaner
Using nabu config file: /home/ubuntu/indexing/configs/geocodes-dev/nabu
batch called
{"file":"/github/workspace/internal/organizations/org.go:55","func":"github.com/gleanerio/gleaner/internal/organizations.BuildGraph","level":"info","msg":"Building organization graph.","time":"2022-07-28T17:34:18Z"}
{"file":"/github/workspace/internal/summoner/acquire/sitegraph.go:40","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.GetGraph","level":"info","msg":"Processing sitegraph file (this can be slow with little feedback):https://oih.aquadocs.org/aquadocs.json","time":"2022-07-28T17:34:18Z"}
{"file":"/github/workspace/internal/summoner/acquire/sitegraph.go:41","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.GetGraph","level":"info","msg":"Downloading sitegraph file:https://oih.aquadocs.org/aquadocs.json","time":"2022-07-28T17:34:18Z"}
{"file":"/github/workspace/internal/summoner/acquire/sitegraph.go:53","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.GetGraph","level":"info","msg":"Sitegraph file downloaded. Uploading togleanerhttps://oih.aquadocs.org/aquadocs.json","time":"2022-07-28T17:34:57Z"}
{"file":"/github/workspace/internal/summoner/acquire/sitegraph.go:60","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.GetGraph","level":"info","msg":"Sitegraph file uploaded togleanerUploaded :https://oih.aquadocs.org/aquadocs.json","time":"2022-07-28T17:34:59Z"}

[SNIP]
```

when gleaner is complete
` ./glcon nabu prefix --cfgName geocodes-dev`



