# Data Loading Trouble shooting

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
