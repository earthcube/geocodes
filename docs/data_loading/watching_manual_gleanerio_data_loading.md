# Data Loading - Watching CLI/Manual Loading

## When you are doing a manual load, things you can observe
* console
* logs
* Minio/s3

!!! Note
    Remember to use `screen ` for long data loads. This will make sure the process 
    does not die when a terminal disconnccts. `screen -S {SOME_NAME}`


### console
* `screen -ls`
* `screen r {SOME_NAME}`
You should see a set of json records being reported.

!!! Note NABU
    Nabu will provide a progress bar.

### Logs
* `cd indexing` or whereever you ran glcon from
* `ls -l logs` You will see a set of logs.
initally, this will be there:

```shell
gleaner-2023-04-27-21-56-46.log
```  

Then when sitemaps are loaded, reposiories will appear:

```
repo-magic-issues-2022-12-20-18-54-58.log
repo-magic-loaded-2022-10-06-15-40-07.log
repo-opentopography-issues-2022-10-05-22-04-03.log
repo-opentopography-loaded-2022-10-05-22-04-03.log
```

when a run is complete, or stopped (ctrl-c) this will appear
```
gleaner-runstats-2023-04-27-05-38-59.log
```

You can `tail -f logs/{file}`


## Minioadmin/s#
In minioadmin you can see a bucket loading. Go to a minioadmin
https://minioadmin.geocodes.ncsa.illinois.edu/

Go to the bucket you are loading, summoned path
select a repo, Sort by date to see what is the latest loaded (click twice)


## Run a missing report
If you run the missing_report you can do a quick idea of what did not make it in... 
but there is still alot to go the there will be a lot of missing.
