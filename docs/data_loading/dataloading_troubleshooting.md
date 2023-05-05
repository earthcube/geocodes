# Data Loading Trouble shooting

## Intial places to look:
When you have issues there are multiple starting points

* console... 
* logs
* minio
* run reports

## Console and Logs
There will be errors in the console and the logs. We have not correctly identified what is an actual data error, a network 
error, or a code error.

Need to add common errors with descriptions:

**Robots.txt**

These are normal. It just says hey cannot find the robots.txt. Being lowered to info or debug
`{"file":"/github/workspace/internal/summoner/acquire/utils.go:35","func":"github
.com/gleanerio/gleaner/internal/summoner/acquire.getRobotsTxt","level":"error","
msg":"error parsing robots.txt at https://ecl.earthchem.org/home.php/robots.txtP
arse error(s): \nAllow before User-agent at token #31.\n","time":"2023-05-03T14:
01:19-05:00"}`

** Headless **

There are normal. If gleaner cannot find a jsonld it calls headless. And then if headless cannot find one, 
it presently throws an error.

{"file":"/github/workspace/internal/summoner/acquire/headlessNG.go:340","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.PageRender","issue":"Headless Evaluate","level":"error","msg":"cdp.Runtime: Evaluate: context deadline exceeded","time":"2023-05-04T14:00:16-05:00","url":"https://earthref.org/MagIC/13413"}
{"file":"/github/workspace/internal/summoner/acquire/headlessNG.go:52","func":"github.com/gleanerio/gleaner/internal/summoner/acquire.HeadlessNG","level":"error","msg":"https://earthref.org/MagIC/13413::cdp.Runtime: Evaluate: context deadline exceeded","time":"2023-05-04T14:00:16-05:00"}

**headless timeput**

Normal, but you may need to check it out

{"file":"/github/workspace/internal/summoner/acquire/headlessNG.go:340","func":"
github.com/gleanerio/gleaner/internal/summoner/acquire.PageRender","issue":"Head
less Evaluate","level":"error","msg":"cdp.Runtime: Evaluate: rpc error: Executio
n context was destroyed. (code = -32000)","time":"2023-05-03T14:01:24-05:00","ur
l":"https://ssdb.iodp.org/dataset"}

** error **

This may mean that a page does not have JSON, or that a page that gleaner thinks should be json, is
not json. You may need to look in postman, and send a Accept header to see what gleaner is getting from the website

`{"contentType":"script[type='application/ld+json']","file":"/github/workspace/in
ternal/summoner/acquire/acquire.go:228","func":"github.com/gleanerio/gleaner/int
ernal/summoner/acquire.FindJSONInResponse.func1","level":"error","msg":"Error pr
ocessing script tag in http://get.iedadata.org/doi/100505error checking for vali
d json: Error in unmarshaling json: invalid character '}' looking for beginning
of object key string","time":"2023-05-03T14:01:23-05:00","url":"http://get.iedad
ata.org/doi/100505"}`


## Data Loading stops when my terminal disconnects
Yes, the process dies when you are disconnected...
if you do not nohup the process,  or use tmux or screen to allow the process 
to be detaached.

There are insructions for [screen](using_screen_for_manual_loading.md), since that is what the write of this
documentation uses:

If source is large,  use [screen](using_screen_for_manual_loading.md) e.g. `screen -S gleaner`

Did we suggest running in a [screen](using_screen_for_manual_loading.md)


## Missing JSONLD
from open topo one id


## duplicate id

### r2r

@id is set to doi:null

same id generated, only one file will be maintained.
```
level=debug issue="Uploaded JSONLD to object store" sha=00a6b5eec951ac51065f0f2485c3406a4c260fb0 url="https://dev.rvdata.us/search/fileset/149018"
level=debug issue="Uploaded JSONLD to object store" sha=d26f68908c3d75d7705f78518beb19c325d32ac9 url="https://dev.rvdata.us/search/fileset/149018"
level=debug msg="<nil>" issue="Multiple JSON" url="https://dev.rvdata.us/search/fileset/149019"
level=debug issue="Multiple JSON" url="https://dev.rvdata.us/search/fileset/149019"
level=debug issue="Uploaded JSONLD to object store" sha=00a6b5eec951ac51065f0f2485c3406a4c260fb0 url="https://dev.rvdata.us/search/fileset/149019"
level=debug issue="Uploaded JSONLD to object store" sha=d26f68908c3d75d7705f78518beb19c325d32ac9 url="https://dev.rvdata.us/search/fileset/149019
```

## Data Catalog
we need to deal with these

## No datasets

run the graph and no datasets
