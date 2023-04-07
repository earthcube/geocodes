# Configuration Examples

## Basics
At present, there are two similar but different configuration files that are used by the two core applications: `gleaner` and `nabu`
These can be generated using a command line tool: `glcon`
when generating using` glcon`, a file called `localConfig.yaml` is edited, and a command generate generates 
the two configuraiton files.

Plans for the future are to refactor into two files, core services and sources

## Services and Sources
To load data you need to know the services and the sources.
The services can be a remote cloud based, or  local usually running in a container
(warn local is not always easy.)


## Using glcon to generate configurations

Step overview:
* `./glcon config init --cfgName {projectname}`
* edit configs/projectname/localConfig.yaml
* `./glcon config generate --cfgName {projectname}`

~~~yaml title="localConfig.yaml
{%
   include './template/localConfig.yaml'
   
%}
~~~

## Examples

### Demo
This is configured as a local
~~~yaml title="localConfig.yaml
{%
   include './configuration/demo/localConfig.yaml'
   
%}
~~~


### Flight Test
This 
