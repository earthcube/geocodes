
## Is there data in the namespace:
### count
```sparql
SELECT (count(*) as ?count) 
WHERE     { ?s ?p ?o}

```

### triples
select all from all graphs (?g)
```sparql
SELECT *
WHERE     {     GRAPH ?g {?s ?p ?o}}
LIMIT 100
```

```sparql
SELECT *
WHERE     {     GRAPH ?g {?s ?p ?o}}
LIMIT 100
```

## what types are in the system
```sparql
prefix schema: <https://schema.org/>
SELECT  ?type  (count(distinct ?s ) as ?scount)
WHERE {
{

       ?s a ?type .

       }
}

GROUP By ?type
ORDER By DESC(?scount)```

## Dataset 
### count
subject is a rdf:type schema.org/Dataset
```sparql
SELECT (count(?g ) as ?count) 
WHERE     {     GRAPH ?g {?s a <https://schema.org/Dataset>}}

```

### triples
```sparql
SELECT *  
WHERE     {     GRAPH ?g {?s a <https://schema.org/Dataset>}}
LIMIT 100
```
### Keyword count
#### count of keywords
```sparql
prefix schema: <https://schema.org/>
SELECT  (count(distinct ?keyword ) as ?scount)
WHERE {
  {

       ?s schema:keywords ?keyword .

       }
}

ORDER By DESC(?scount)
```
#### Keyword counts

```sparql
# needs work... keywords can be an array.
prefix schema: <https://schema.org/>
SELECT  ?keyword (count(distinct ?s) as ?scount)
WHERE {
  {

       ?s schema:keywords ?keyword .

       }
}
GROUP By ?keyword
ORDER By DESC(?scount)
```

### Publisher
```sparql
prefix schema: <https://schema.org/>
SELECT  ?pubname (count(distinct ?s) as ?scount)
WHERE {
  {

       ?s schema:publisher/schema:name|schema:sdPublisher ?pubname .
       }
}
GROUP By ?pubname
ORDER By DESC(?scount)
```

### Variable Name
```sparql
prefix schema: <https://schema.org/>
SELECT  ?variableName (count(distinct ?s) as ?scount)
WHERE {
  {

       ?s schema:variableMeasured ?variableMeasured .
    ?variableMeasured schema:name ?variableName

       }
}
GROUP By ?variableName
ORDER By DESC(?scount)
```

### Dataset with versions
#### list of version numbers
```spqarql
prefix schema: <https://schema.org/>
SELECT  ?version (count(distinct ?s) as ?scount)
WHERE {
  {

       ?s schema:version ?version .

       }
}
GROUP By ?version
ORDER By DESC(?scount)
```
#### datasets with a version number
```sparql
prefix schema: <http://schema.org/>
prefix sschema: <https://schema.org/>
SELECT distinct ?subj ?sameAs ?version ?url where {
    {SELECT distinct  ?sameAs (MAX(?version2) as ?version  )
    where {
       ?subj schema:sameAs|sschema:sameAs ?sameAs .
        ?subj schema:version|sschema:version ?version2 .
    
    }
        GROUP BY ?sameAs
}
        ?subj schema:identifier|sschema:identifier ?url .
        ?subj schema:version|sschema:version ?version .
        ?subj schema:sameAs|sschema:sameAs ?sameAs .
    }
    GROUP BY ?sameAs ?version  ?subj  ?url
order by ?sameAs ?version
limit 1000
```
#### Datasets with multiple versions
```sparql
prefix schema: <http://schema.org/>
prefix sschema: <https://schema.org/>
SELECT distinct ?subj ?sameAs ?version ?url where {
    {SELECT distinct  ?sameAs (MAX(?version2) as ?version  )
    where {
       ?subj schema:sameAs|sschema:sameAs ?sameAs .
        ?subj schema:version|sschema:version ?version2 .
    filter (?version2 >1)
    }
        GROUP BY ?sameAs
}
        ?subj schema:identifier|sschema:identifier ?url .
        ?subj schema:version|sschema:version ?version .
        ?subj schema:sameAs|sschema:sameAs ?sameAs .
    }
    GROUP BY ?sameAs ?version  ?subj  ?url
order by ?sameAs ?version
```

#### Versions for Earthref.org
```sparql
prefix schema: <http://schema.org/>
prefix sschema: <https://schema.org/>
SELECT distinct ?subj ?sameAs ?version ?url ?g where {
   graph ?g {
        ?subj schema:identifier|sschema:identifier ?url .
        ?subj schema:version|sschema:version ?version .
        ?subj schema:sameAs|sschema:sameAs ?sameAs .
        ?subj schema:sdPublisher|sschema:sdPublisher "EarthRef.org".
    }
        ?subj2 schema:sameAs|sschema:sameAs ?sameAs .
        ?subj2 schema:version|sschema:version ?version2 .

    FILTER (?version < ?version2).
    }
    GROUP BY ?sameAs ?version  ?subj  ?url ?g

```

#### Latest version for a steens query
this includes a max version 
```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix schema: <http://schema.org/>
prefix sschema: <https://schema.org/>
# no longer works as expected. Identifier changed. Try to use sameAs as in other version examples.
SELECT distinct ?subj  ?citation ?version ?pubname ?resourceType ?name  (GROUP_CONCAT(DISTINCT ?placename; SEPARATOR=", ") AS ?placenames)
        (GROUP_CONCAT(DISTINCT ?kwu; SEPARATOR=", ") AS ?kw) (MAX(?version) as ?latestVersion)
        ?datep  (GROUP_CONCAT(DISTINCT ?url; SEPARATOR=", ") AS ?disurl) (MAX(?score1) as ?score) ?description ?g
        WHERE {
            ?lit bds:search "steens" .
            ?lit bds:matchAllTerms false .
            ?lit bds:relevance ?score1 .
            ?subj ?p ?lit .
            BIND (IF (exists {?subj a schema:Dataset .} ||exists{?subj a sschema:Dataset .} , "data", "tool") AS ?resourceType).
            filter( ?score1 > 0.04).
          graph ?g {
            Minus {?subj a sschema:ResearchProject } .
            Minus {?subj a schema:ResearchProject } .
            Minus {?subj a schema:Person } .
            Minus {?subj a sschema:Person } .
             ?subj schema:name|sschema:name ?name .
             ?subj schema:description|sschema:description ?description .
             }
             ?subj schema:citation|sschema:citation ?citation .
             ?subj schema:version|sschema:version ?version .
            optional {?subj schema:distribution/schema:url|schema:subjectOf/schema:url ?url .}
            OPTIONAL {?subj schema:datePublished|sschema:datePublished ?date_p .}
            OPTIONAL {?subj schema:publisher/schema:name|sschema:publisher/sschema:name|sschema:sdPublisher|schema:provider/schema:name ?pub_name .}
            OPTIONAL {?subj schema:spatialCoverage/schema:name|sschema:spatialCoverage/sschema:name ?place_name .}
            OPTIONAL {?subj schema:keywords|sschema:keywords ?kwu .}
            BIND ( IF ( BOUND(?date_p), ?date_p, "No datePublished") as ?datep ) .
            BIND ( IF ( BOUND(?pub_name), ?pub_name, "No Publisher") as ?pubname ) .
            BIND ( IF ( BOUND(?place_name), ?place_name, "No spatialCoverage") as ?placename ) .
            ?subj schema:version|sschema:version ?version .
        }
        GROUP BY ?subj ?pubname ?placenames ?kw ?datep ?disurl ?score ?name ?description  ?resourceType ?g  ?citation ?version
        ORDER BY DESC(?score)
 ```

## Resource Registry

(lot of blank nodes)
### count
```sparql
SELECT (count(?g ) as ?count)
WHERE     {     GRAPH ?g {?s a <https://schema.org/CreativeWork>}}

```

### Triples
```sparql
SELECT * 
WHERE     {     GRAPH ?g {?s a <https://schema.org/CreativeWork>}}
LIMIT 100
```

