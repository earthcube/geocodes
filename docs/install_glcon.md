## Install glcon
`glcon` is a console application that combines the functionality of Gleaner and Nabu into a single application.
It also has features to create and manage configurations for gleaner and nabu.

* create a directory
`cd ~ ; mkdir indexing`
* download and install:
We will try to keep this updated, but for the [latest release](https://github.com/gleanerio/gleaner/releases).
`wget https://github.com/gleanerio/gleaner/releases/download/{{RELASE}}}}`

| OS              | download                                |  
|-----------------|-----------------------------------------|
| linux intel     | glcon-{{VERSION}}-linux-amd64.tar.gz    |
| linux arm       | glcon-{{VERSION}}-linux-arm64.tar.gz    |
| mac             | glcon-{{VERSION}}-darwin-arm64.tar.gz   |
| windows  intel  | glcon-{{VERSION}}-windows-amd64.zip     |



??? info "downloading glcon"
    ```shell
        3.0.4-dev/glcon-v3.0.4-dev-linux-amd64.tar.gz
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

    `tar xf glcon-v3.0.4-dev-linux-amd64.tar.gz`

**See that it is installed**
```shell
ubuntu@geocodes-dev:~/indexing$ tar xf glcon-v3.0.4-dev-linux-amd64.tar.gz
ubuntu@geocodes-dev:~/indexing$ ls
README.md  docs   glcon-v3.0.4-dev-linux-amd64.tar.gz  scripts
configs    glcon  schemaorg-current-https.jsonld
```

* test
??? example "`  ./glcon --help`"
```shell
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
