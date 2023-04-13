# Oboarding a Dataseource/Repository

If we have an issue with a repository, let's test it, independently.
If we have a new datasource/community, let's test it, independently.

We can do this because:
* s3 paths are repository based, so we can load to an s3 bucket
* blazegraph, we can create two namespaces in our openstack blazegraph stores
* We can setup 'tenant' instances of the UI that connect to these services
* we have some repository evaluation scripts in development.


So, basically, This assumes we have some basic information about a data source, aka sitemap, and something we want to 
name this repository.

!!! Note
    This is a high level overview that assumes you have loaded data, and do not need any deep details.
    Over time put the troubleshooting an gotchas below the steps.

Please put any issues/notes in the production/repos google docs

## Some steps.
1. Grab some urls from the sitemap, evaulate in validator.schema.org
3. run check_sitemap to see it url's are good
2. create gleaner config for repo
3. setup datastores
    * any s3
    * independent project and project_summary namespaces
3. glcon gleaner Summon to an s3 location. Repos are independent at this point.
4. evaluate summon. Look at jsonld. does it seem reasonable.
    * doe we need a tool to pull a specific url from s3? filter the listSummonedUrls, or getOringalUr
    * run missing stats... may need an option to just check the sitemap>summon
5. if these look good, then glcon nabu prefix
6. run graph_stats and missing stats
    * report needs to be updated to include [all/repo]_count_types_top_level.sparql, 
7. check reports
9. feel free to run repo_urn_w_types_toplevel.sparql
9. run summarize_* to populate summary
9. create a facets configuration, and create  tennant containers to run against the project and project_summary namespaces
10. via UI run queries to see that it works.
    * humm, add a simple query tester to scripts


### Evaluating with validator
what to look for

### evaluating summon
What to look for

### Evaluating graph and missing reports
What to look for

### How to test the UI
