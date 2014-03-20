<?xml version="1.0" encoding="utf-8"?>
<!--
  XSLT script to format the results of an object class or data element concept
  search.

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


  This script is meant to be applied to the results of one of the following
  SPARQL queries (in application/sparql-results+xml format), where %keyword% is
  the keyword to look for.

  SELECT * WHERE {
    ?class a mdr:ObjectClass
    OPTIONAL { ?class mdr:context ?context
               OPTIONAL { ?context rdfs:label ?contextname } }
    OPTIONAL { ?class rdfs:label ?label }
    OPTIONAL { ?class skos:definition ?definition }
    FILTER(CONTAINS(LCASE(STR(?label)), LCASE("%keyword%")) ||
           CONTAINS(LCASE(STR(?definition)), LCASE("%keyword%")))
  }

  SELECT * WHERE {
    ?dec a mdr:DataElementConcept
    OPTIONAL { ?dec mdr:context ?context
               OPTIONAL { ?context rdfs:label ?contextname } }
    OPTIONAL { ?dec rdfs:label ?label }
    OPTIONAL { ?dec skos:definition ?definition }
    FILTER(CONTAINS(LCASE(STR(?label)), LCASE("%keyword%")) ||
           CONTAINS(LCASE(STR(?definition)), LCASE("%keyword%")))
  }

-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:res="http://www.w3.org/2005/sparql-results#"
  exclude-result-prefixes="xsl fn res">

  <xsl:output method="html" indent="yes" encoding="UTF-8" />

  <xsl:template match="res:sparql">
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
    <html>
      <head>
        <meta charset="UTF-8" />
        <title>Query results – Semantic MDR</title>
        <meta name="viewport" content="width=device-width,initial-scale=1" />
        <link rel="stylesheet" type="text/css" href="css/normalize.css" />
        <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:400,400italic,600,600italic,300" />
        <link rel="stylesheet" type="text/css" href="css/screen.css" />
        <script type="text/javascript" src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
      </head>
      <body>
      <header>
        <div class="logo">
          <a href="https://www.semic.eu">
            <img src="images/semic_logo.png" alt="SEMIC logo" width="90" height="90" />
          </a>
        </div>
        <h1>e-Document engineering pilot</h1>
        <p class="subtitle">Using a semantic metadata registry for e-Document engineering</p>
      </header>

      <section>
        <h2>Query results</h2>
        <p><a href="/">« Return to the homepage</a></p>
        <div id="results">
          <xsl:call-template name="results" />
        </div>
      </section>

      <footer>
        <p>This work is supported by
        <a href="http://ec.europa.eu/isa/actions/02-interoperability-architecture/2-15action_en.htm" target="_blank">Action 2.15</a>
        of the
        <a href="http://ec.europa.eu/isa/" target="_blank">Interoperability Solutions
        for European Public Adminstrations (ISA)</a> Programme of the European
        Commission.</p>

        <p><strong>Linked Data pilots:</strong>
          <a href="http://location.testproject.eu/BEL">Core Location pilot</a> |
          <a href="http://cpsv.testproject.eu/CPSV">Core Public Service pilot</a> |
          <a href="http://org.testproject.eu/MAREG">Organisation Ontology pilot</a> |
          <a href="http://health.testproject.eu/PPP">Plant Protection Products pilot</a> |
          <a href="http://maritime.testproject.eu/CISE">Maritime Surveillance pilot</a>
        </p>

        <p>
          <a href="https://joinup.ec.europa.eu/asset/dcat_application_profile/description" target="_blank"><img alt="DCAT application profile for European data portals" src="https://joinup.ec.europa.eu/sites/default/files/imagecache/community_logo/DCAT_application_profile_for_European_data_portals_logo_0.png" width="70" height="70" /></a>
          <a href="https://joinup.ec.europa.eu/asset/adms/description" target="_blank"><img alt="Asset Description Metadata Schema (ADMS)" src="http://joinup.ec.europa.eu/sites/default/files/imagecache/community_logo/adms_logo.png" width="70" height="70" /></a>
          <a href="https://joinup.ec.europa.eu/asset/adms_foss/description" target="_blank"><img alt="Asset Description Metadata Schema for Software (ADMS.SW)" src="http://joinup.ec.europa.eu/sites/default/files/imagecache/community_logo/ADMS_SW_Logo.png" width="70" height="70" /></a>
          <a href="https://joinup.ec.europa.eu/asset/core_business/description" target="_blank"><img alt="Core Business Vocabulary" src="http://joinup.ec.europa.eu/sites/default/files/imagecache/community_logo/core_business_logo.png" width="70" height="70" /></a>
          <a href="https://joinup.ec.europa.eu/asset/core_person/description"><img alt="Core Person Vocabulary" src="http://joinup.ec.europa.eu/sites/default/files/imagecache/community_logo/core_person_logo.png" width="70" height="70" /></a>
          <a href="https://joinup.ec.europa.eu/asset/core_location/description" target="_blank"><img alt="Core Location Vocabulary" src="http://joinup.ec.europa.eu/sites/default/files/imagecache/community_logo/core_location_logo.png" width="70" height="70" /></a>
          <a href="https://joinup.ec.europa.eu/asset/core_public_service/description" target="_blank"><img alt="Core Public Service Vocabulary" src="https://joinup.ec.europa.eu/sites/default/files/imagecache/community_logo/core_public_service_logo.png" width="70" height="70" /></a>
          <a href="http://ec.europa.eu/isa/" target="_blank"><img alt="isa" src="http://joinup.ec.europa.eu/sites/default/files/ckeditor_files/images/isa_logo.png" width="70" height="70" /></a>
        </p>
      </footer>
      <script type="text/javascript"><xsl:text>
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', 'UA-38243808-1']);
        _gaq.push(['_trackPageview']);

        (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();
      </xsl:text></script>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="results">
    <table>
      <thead>
        <tr>
          <th>
            <xsl:choose>
              <xsl:when test="//res:head/res:variable[@name='dec']">
                <xsl:text>Data Element Concepts</xsl:text>
              </xsl:when>
              <xsl:when test="//res:head/res:variable[@name='class']">
                <xsl:text>Object Classes</xsl:text>
              </xsl:when>
            </xsl:choose>
          </th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each select="res:results/res:result">
          <tr>
            <xsl:apply-templates select="."/>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="res:result">
    <xsl:variable name="uri" select="res:binding[@name='dec' or @name='class']/uri" />
    <!-- Name or URI with hyperlink, and context -->
    <td>
      <xsl:if test="res:binding[@name='context']">
        <xsl:variable name="context" select="res:binding[@name='context']/uri" />
        <a href="{$context}">
          <xsl:choose>
            <xsl:when test="res:binding[@name='contextname']">
              <xsl:value-of select="res:binding[@name='contextname']/literal" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="fn:replace($context, '^http://mdr.testproject.eu/id/([^/]*)/.*$', '$1')" />
            </xsl:otherwise>
          </xsl:choose>
        </a>
        <xsl:text>: </xsl:text>
      </xsl:if>
      <a href="{$uri}">
        <xsl:choose>
          <xsl:when test="res:binding[@name='label']">
            <xsl:value-of select="res:binding[@name='label']/literal" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="fn:replace($uri, '^.*[/#]([^/#]*)$', '$1')" />
          </xsl:otherwise>
        </xsl:choose>
      </a>
      <!-- Definition -->
      <div class="description">
        <xsl:value-of select="res:binding[@name='definition']/literal" />
      </div>
    </td>
  </xsl:template>

</xsl:stylesheet>
<!-- vim:set ts=2 sw=2 et: -->
