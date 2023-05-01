# Oboarding a Dataseource/Repository

If we have an issue with a repository, let's test it, independently.
If we have a new datasource/community, let's test it, independently.

We can do this because:

* s3 paths are repository based, so we can load to an s3 bucket
* blazegraph, we can create two namespaces in our openstack blazegraph stores
* We can setup 'tenant' instances of the UI that connect to  (s3 bucket, and project namespaces) services
* we have some source reports to help evaluate the data loading.

So, basically, This assumes we have some basic information about a data source, aka sitemap, and something we want to 
name this repository.

!!! Note
    This is a high level overview that assumes you have loaded data, and do not need any deep details.
    Over time put the troubleshooting an gotchas below the steps.

!!! Note
    if source is large, run in a [screen](using_screen_for_manual_loading.md)
    In fact, it is suggested to always run in a screen

Please put any issues/notes in the production/repos google docs

## Some steps.

1. Grab some urls from the sitemap, evaluate in validator.schema.org
3. run check_sitemap to see it url's are good
3. setup datastores
    * any s3
    * independent project and project_summary namespaces
2. create gleaner config for repo
2.   if source is large,  use [screen](using_screen_for_manual_loading.md) e.g. `screen -S gleaner`
3. `glcon gleaner batch` Summon to an s3 location. Repos are independent at this point.
    *  did we suggest runing in a [screen](using_screen_for_manual_loading.md)
4. evaluate summon. Look at jsonld. Do they seem like they got loaded?
    * thought: do we need a tool to pull a specific url from s3? could filter the listSummonedUrls, we do have getOringalUrl
    * run missing stats... may need an option to just check the sitemap>summon portion
5. `glcon nabu prefix` if these look good, then 
    *  did we suggest runing in a [screen](using_screen_for_manual_loading.md)
6. run `graph_stats` and `missing...`
    * graph stats report needs to be updated to include [all/repo]_count_types_top_level.sparql, 
7. check reports
9. feel free to run repo_urn_w_types_toplevel.sparql
9. run summarize_* to populate summary
9. create a facets configuration for the project, upload to portainer, and create stack of tenant containers to run against the project and project_summary namespaces
10. via UI run queries to see that it works.
    * humm, add a simple query tester to scripts
11. Review with team
12. review with datasource
13. add to production sources

### Evaluating with validator
what to look for

### evaluating summon
What to look for

### Evaluating graph and missing reports
What to look for

### How to test the UI

keywords:
* data
* repository keywords
