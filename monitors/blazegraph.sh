!# /bin/bash
curl -w "@curl-format.txt" -o /dev/null -s "https://graph.geodex.org/blazegraph/status?showQueries"
