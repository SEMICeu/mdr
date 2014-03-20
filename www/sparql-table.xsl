<?xml version="1.0" encoding="utf-8"?>
<!--
  XSLT script to format SPARQL SELECT results (in application/sparql-results+xml
  format) in a table.

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
        <a href="http://ec.europa.eu/isa/actions/01-trusted-information-exchange/1-1action_en.htm" target="_blank">Action 1.1</a>
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
      </body>
    </html>
  </xsl:template>

  <xsl:template name="results">
    <table>
      <tr>
        <xsl:for-each select="//res:head/res:variable">
          <th><xsl:value-of select="@name" /></th>
        </xsl:for-each>
      </tr>
      <xsl:for-each select="//res:results/res:result">
        <tr>
          <xsl:apply-templates select="."/>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template match="res:result">
    <xsl:variable name="current" select="." />
    <xsl:for-each select="//res:head/res:variable">
      <xsl:variable name="name" select="@name" />
      <td>
        <xsl:if test="$current/res:binding[@name=$name]">
          <xsl:apply-templates select="$current/res:binding[@name=$name]" />
        </xsl:if>
      </td>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="res:bnode">
    <xsl:text>(</xsl:text>
    <xsl:value-of select="text()" />
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="res:uri">
    <xsl:variable name="uri" select="text()" />
    <a href="{$uri}">
      <xsl:value-of select="fn:replace($uri, '^.*[/#]([^/#]*)$', '$1')" />
    </a>
  </xsl:template>

  <xsl:template match="res:literal">
    <xsl:value-of select="text()" />
  </xsl:template>

</xsl:stylesheet>
<!-- vim:set ts=2 sw=2 et: -->
