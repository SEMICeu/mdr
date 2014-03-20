/*
  Javascript functionalities for index.html

  Copyright 2014 PwC EU Services

  Licensed under the EUPL, Version 1.1 or - as soon they
  will be approved by the European Commission - subsequent
  versions of the EUPL (the "Licence");
  You may not use this work except in compliance with the
  Licence.
  You may obtain a copy of the Licence at:
  http://ec.europa.eu/idabc/eupl

  Unless required by applicable law or agreed to in
  writing, software distributed under the Licence is
  distributed on an "AS IS" basis,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
  express or implied.
  See the Licence for the specific language governing
  permissions and limitations under the Licence.
*/

$.fn.filterfind = function(selector) {
  return this.filter(selector).add(this.find(selector));
};

function doSearchType(short, type) {
  var query = $("#query").val();
  var sparql = 'SELECT * WHERE { ?' + short + ' a mdr:' + type + ' ' +
               'OPTIONAL { ?' + short + ' mdr:context ?context ' +
                          'OPTIONAL { ?context rdfs:label ?contextname } } ' +
               'OPTIONAL { ?' + short + ' rdfs:label ?label } ' +
               'OPTIONAL { ?' + short + ' skos:definition ?definition } ';
  if(query) {
    query = query.replace('\\', '\\\\')
                 .replace('"', '\\"')
                 .replace('\n', '\\n')
                 .replace('\r', '\\r')
                 .toLowerCase();
    sparql += 'FILTER(CONTAINS(LCASE(STR(?label)), "' + query + '") || ' +
                     'CONTAINS(LCASE(STR(?definition)), "' + query + '"))';
  }
  sparql += '}';
  $("#" + short + "results")
    .empty()
    .append('<p class="more"><a href="/sparql?' +
            $.param({
              'query': sparql,
              'default-graph-uri': "http://mdr.testproject.eu/",
              'format': "application/sparql-results+xml",
              'xslt-uri': "http://mdr.testproject.eu/search.xsl"
            }) +
            '">See all results &raquo;</a></p>');
  var sparql_limited = sparql + ' LIMIT 10';
  console.log("Executing query: " + sparql_limited);
  $.get("/sparql", {
    'query': sparql_limited,
    'default-graph-uri': "http://mdr.testproject.eu/",
    'format': "application/sparql-results+xml",
    'xslt-uri': "http://mdr.testproject.eu/search.xsl"
  }, function(data) {
    $("#" + short + "results")
      .prepend($(data).filterfind("#results").contents());
  });
}

function doSearch() {
  doSearchType("class", "ObjectClass");
  doSearchType("dec", "DataElementConcept");
}

function fillExample(key, sparql) {
  var select = "#example-" + key;
  console.log("Executing query: " + sparql);
  $.get("/sparql", {
    'query': sparql,
    'default-graph-uri': "http://mdr.testproject.eu/",
    'format': "application/sparql-results+xml",
    'xslt-uri': "http://mdr.testproject.eu/sparql-table.xsl"
  }, function(data) {
    $(select).prepend($(data).filterfind("#results").contents());
  });
}

$(function() {
  $("#searchform").submit(function(event) {
    doSearch();
    event.preventDefault();
  });
  doSearch();
  fillExample('goals', 'SELECT ?id ?name ?description WHERE { ?id a mdr:Goal ; rdfs:label ?name ; rdfs:comment ?description } ORDER BY ?id');
  fillExample('transactions', 'SELECT ?id ?name ?description ?goal WHERE { ?id a mdr:Transaction ; rdfs:label ?name ; rdfs:comment ?description ; mdr:implements ?goal } ORDER BY ?id ?goal');
  fillExample('requirements', 'SELECT ?id ?name ?statement ?rationale ?transaction ?goal WHERE { ?id a mdr:Requirement ; rdfs:label ?name ; skos:definition ?statement ; mdr:rationale ?rationale ; dct:isPartOf ?transaction ; mdr:implements ?goal } ORDER BY ?id ?goal');
  fillExample('elements', 'SELECT ?id ?name ?definition ?transaction ?requirement WHERE { ?id a mdr:DataElementConcept ; rdfs:label ?name ; skos:definition ?definition ; dct:isPartOf ?transaction ; mdr:implements ?requirement } ORDER BY ?id');
  fillExample('rules', 'SELECT ?id ?rule ?transaction ?ir ?requirement WHERE { ?id a mdr:BusinessRule ; skos:definition ?rule ; dct:isPartOf ?transaction ; mdr:affects ?ir ; mdr:implements ?requirement } ORDER BY ?id');
});

/* vim:set ts=2 sw=2 et: */
