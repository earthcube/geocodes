# needs to open the port
curl -X POST -H 'Content-type: application/xml' --data @setup/graph_earthcube.xml http://localhost:9999/blazegraph/namespace
curl -X POST -H 'Content-type: application/xml' --data @setup/graph_ci.xml http://localhost:9999/blazegraph/namespace
curl -X POST -H 'Content-type: application/xml' --data @setup/graph_ci2.xml http://localhost:9999/blazegraph/namespace
