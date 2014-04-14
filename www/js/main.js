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
  var sparql = 'PREFIX mdr: <http://mdr.semic.eu/def#> ' +
               'SELECT DISTINCT * WHERE { ?' + short + ' a mdr:' + type + ' ' +
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
              'format': "application/sparql-results+xml",
              'xslt-uri': "file://mdr/xslt/search.xsl"
            }) +
            '">See all results &raquo;</a></p>');
  var sparql_limited = sparql + ' LIMIT 10';
  console.log("Executing query: " + sparql_limited);
  $.get("/sparql", {
    'query': sparql_limited,
    'format': "application/sparql-results+xml",
    'xslt-uri': "file://mdr/xslt/search.xsl"
  }, function(data) {
    $("#" + short + "results")
      .prepend($(data).filterfind("#results").contents());
  });
}

function doSearch() {
  doSearchType("class", "ObjectClass");
  doSearchType("element", "DataElement");
}

function fillExample(key, sparql) {
  var select = "#example-" + key;
  sparql = 'PREFIX mdr: <http://mdr.semic.eu/def#> ' + sparql
  console.log("Executing query: " + sparql);
  $.get("/sparql", {
    'query': sparql,
    'format': "application/sparql-results+xml",
    'xslt-uri': "file://mdr/xslt/sparql-table.xsl"
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
  fillExample('goals', 'SELECT DISTINCT ?id ?name ?description WHERE { ?id a mdr:Goal ; rdfs:label ?name ; rdfs:comment ?description } ORDER BY ?id');
  fillExample('transactions', 'SELECT DISTINCT ?id ?name ?description ?goal WHERE { ?id a mdr:Transaction ; rdfs:label ?name ; rdfs:comment ?description ; mdr:implements ?goal } ORDER BY ?id ?goal');
  fillExample('requirements', 'SELECT DISTINCT ?id ?name ?statement ?rationale ?transaction ?goal WHERE { ?id a mdr:HighLevelRequirement ; rdfs:label ?name ; skos:definition ?statement ; mdr:rationale ?rationale ; mdr:transaction ?transaction ; mdr:implements ?goal } ORDER BY ?id ?goal');
  fillExample('information', 'SELECT DISTINCT ?id ?name ?definition ?transaction ?requirement WHERE { ?id a mdr:InformationRequirement ; rdfs:label ?name ; skos:definition ?definition ; mdr:transaction ?transaction ; mdr:implements ?requirement } ORDER BY ?id');
  fillExample('rules', 'SELECT DISTINCT ?id ?rule ?transaction ?ir ?requirement WHERE { ?id a mdr:BusinessRule ; skos:definition ?rule ; mdr:transaction ?transaction ; mdr:affects ?ir ; mdr:implements ?requirement } ORDER BY ?id');
});

/* vim:set ts=2 sw=2 et: */
