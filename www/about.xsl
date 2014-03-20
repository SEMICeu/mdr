<?xml version="1.0" encoding="utf-8"?>
<!--
  XSLT script to show a detailed view about a particular resource

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


  This script is meant to be applied to the results of the following SPARQL
  query (in application/sparql-results+xml format), where <$s1> is the target
  resource URI.

  SELECT DISTINCT * WHERE {
    {
      <$s1> ?p ?o
      OPTIONAL { ?p rdfs:label ?plabel }
      OPTIONAl { ?o rdfs:label ?olabel }
    } UNION {
      ?s ?ip <$s1>
      OPTIONAL { ?ip rdfs:label ?iplabel }
      OPTIONAl { ?s rdfs:label ?slabel }
    }
    BIND(<$s1> AS ?target)
  } ORDER BY ?ip ?p

-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:res="http://www.w3.org/2005/sparql-results#"
  xmlns:ns="http://testproject.eu/namespaces"
  exclude-result-prefixes="xsl res ns">

  <xsl:output method="html" indent="yes" encoding="UTF-8" />

  <xsl:variable name="namespaces" select="document('http://mdr.testproject.eu/namespaces.xml')" />

  <xsl:variable name="target" select="//res:result/res:binding[@name='target'][1]" />

  <!--
    Main templates
  -->

  <!-- Root template -->
  <xsl:template match="res:sparql">
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
    <html>
      <head>
        <meta charset="UTF-8" />
        <title>About: <xsl:call-template name="target-label" /></title>
        <meta name="viewport" content="width=device-width,initial-scale=1" />
        <link rel="stylesheet" type="text/css" href="/css/normalize.css" />
        <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:400,400italic,600,600italic,300" />
        <link rel="stylesheet" type="text/css" href="/css/screen.css" />
        <script type="text/javascript" src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
      </head>
      <body>
      <header>
        <div class="logo">
          <a href="https://www.semic.eu">
            <img src="/images/semic_logo.png" alt="SEMIC logo" width="90" height="90" />
          </a>
        </div>
        <h1>e-Document engineering pilot</h1>
        <p class="subtitle">Using a semantic metadata registry for e-Document engineering</p>
      </header>

      <xsl:choose>
        <xsl:when test="$target">
          <section>
            <xsl:call-template name="info" />
          </section>

          <section>
            <h2>Properties</h2>
            <xsl:call-template name="properties" />
          </section>

          <section>
            <h2>Referenced by</h2>
            <xsl:call-template name="inverse-properties" />
          </section>
        </xsl:when>
        <xsl:otherwise>
          <section>
            <h2>About</h2>
            <div class="error">The resource you are looking for was not found.</div>
          </section>
        </xsl:otherwise>
      </xsl:choose>

      <footer>
        <p>This work is supported by
        <a href="http://ec.europa.eu/isa/actions/01-trusted-information-exchange/1-1action_en.htm" target="_blank">Action 1.1</a>
        of the
        <a href="http://ec.europa.eu/isa/" target="_blank">Interoperability Solutions
        for European Public Adminstrations (ISA)</a> Programme of the European
        Commission.</p>

        <p><strong>Linked Data pilots: </strong>
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

  <!-- Print the information section -->
  <xsl:template name="info">
    <h2><xsl:call-template name="target-label" /></h2>
    <xsl:call-template name="target-description" />
    <dl class="properties">
      <dt>URI</dt>
      <dd><a href="{$target}"><xsl:value-of select="$target" /></a></dd>
      <xsl:variable name="type" select="//res:result[res:binding[@name='p']='http://www.w3.org/1999/02/22-rdf-syntax-ns#type']" />
      <xsl:if test="$type">
        <xsl:variable name="type-uri" select="$type/res:binding[@name='o']" />
        <xsl:variable name="type-label" select="$type/res:binding[@name='olabel']" />
        <dt>Type</dt>
        <dd><a>
          <xsl:attribute name="href">
            <xsl:call-template name="resolve-uri">
              <xsl:with-param name="uri" select="$type-uri" />
            </xsl:call-template>
          </xsl:attribute>
          <xsl:call-template name="label-or-value">
            <xsl:with-param name="value" select="$type-uri" />
            <xsl:with-param name="label" select="$type-label" />
            <xsl:with-param name="strip-uri" select="true()" />
          </xsl:call-template>
        </a></dd>
      </xsl:if>
      <dt>Raw data</dt>
      <dd><a>
        <xsl:attribute name="href">
          <xsl:call-template name="resolve-uri">
            <xsl:with-param name="uri" select="$target" />
          </xsl:call-template>
          <xsl:text>/rdf</xsl:text>
        </xsl:attribute>
        RDF/XML
      </a></dd>
    </dl>
  </xsl:template>

  <!-- Print the Properties table -->
  <xsl:template name="properties">
    <table>
      <xsl:for-each select="//res:results/res:result">
        <xsl:if test="res:binding[@name='o']">
          <tr>
            <td>
              <xsl:call-template name="label-or-value">
                <xsl:with-param name="value" select="res:binding[@name='p']" />
                <xsl:with-param name="label" select="res:binding[@name='plabel']" />
                <xsl:with-param name="strip-uri" select="true()" />
              </xsl:call-template>
            </td>
            <td>
              <xsl:call-template name="label-or-value">
                <xsl:with-param name="value" select="res:binding[@name='o']" />
                <xsl:with-param name="label" select="res:binding[@name='olabel']" />
              </xsl:call-template>
            </td>
          </tr>
        </xsl:if>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!-- Print the Inverse Properties table -->
  <xsl:template name="inverse-properties">
    <table>
      <xsl:for-each select="//res:results/res:result">
        <xsl:if test="res:binding[@name='s']">
          <tr>
            <td>
              <xsl:call-template name="label-or-value">
                <xsl:with-param name="value" select="res:binding[@name='ip']" />
                <xsl:with-param name="label" select="res:binding[@name='iplabel']" />
                <xsl:with-param name="strip-uri" select="true()" />
              </xsl:call-template>
            </td>
            <td>
              <xsl:call-template name="label-or-value">
                <xsl:with-param name="value" select="res:binding[@name='s']" />
                <xsl:with-param name="label" select="res:binding[@name='slabel']" />
              </xsl:call-template>
            </td>
          </tr>
        </xsl:if>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!--
    Parts rendering
  -->

  <!-- Print a description of the target -->
  <xsl:template name="target-description">
    <xsl:call-template name="target-description-type">
      <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#comment'" />
    </xsl:call-template>
    <xsl:call-template name="target-description-type">
      <xsl:with-param name="type" select="'http://purl.org/dc/elements/1.1/description'" />
    </xsl:call-template>
    <xsl:call-template name="target-description-type">
      <xsl:with-param name="type" select="'http://purl.org/dc/terms/description'" />
    </xsl:call-template>
    <xsl:call-template name="target-description-type">
      <xsl:with-param name="type" select="'http://www.w3.org/2004/02/skos/core#definition'" />
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="target-description-type">
    <xsl:param name="type" />
    <xsl:for-each select="//res:result[res:binding[@name='p'] = $type]">
      <p>
        <xsl:call-template name="label-or-value">
          <xsl:with-param name="value" select="res:binding[@name='o']" />
          <xsl:with-param name="label" select="res:binding[@name='olabel']" />
        </xsl:call-template>
      </p>
    </xsl:for-each>
  </xsl:template>

  <!-- Print a cell of the table, either its value or, in the case of URIs, its
  label if it exists. -->
  <xsl:template name="label-or-value">
    <xsl:param name="value" /><!-- the res:binding of the value -->
    <xsl:param name="label" /><!-- the res:binding of the label -->
    <xsl:param name="strip-uri" select="false()" />
    <xsl:choose>
      <xsl:when test="$label">
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="resolve-uri">
              <xsl:with-param name="uri" select="$value" />
            </xsl:call-template>
          </xsl:attribute>
          <xsl:apply-templates select="$label" />
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$value">
          <xsl:with-param name="strip-uri" select="$strip-uri" />
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Handle a blank node -->
  <xsl:template match="res:bnode">
    <xsl:text>(</xsl:text>
    <xsl:value-of select="text()" />
    <xsl:text>)</xsl:text>
  </xsl:template>

  <!-- Handle a URI -->
  <xsl:template match="res:uri">
    <xsl:param name="strip-uri" select="false()" />
    <xsl:variable name="uri" select="text()" />
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="resolve-uri">
          <xsl:with-param name="uri" select="$uri" />
        </xsl:call-template>
      </xsl:attribute>
      <xsl:call-template name="to-curie">
        <xsl:with-param name="uri" select="$uri" />
        <xsl:with-param name="strip" select="$strip-uri" />
      </xsl:call-template>
    </a>
  </xsl:template>

  <!-- Handle a literal -->
  <xsl:template match="res:literal">
    <xsl:value-of select="text()" />
  </xsl:template>

  <!--
    Utilities
  -->

  <!-- Print the label of the target, or its stripped URI if there is no label.
  -->
  <xsl:template name="target-label">
    <xsl:choose>
      <xsl:when test="//res:result/res:binding[@name = 'p'] = 'http://www.w3.org/2000/01/rdf-schema#label'">
        <xsl:variable name="result" select="//res:result[res:binding[@name = 'p'] = 'http://www.w3.org/2000/01/rdf-schema#label']" />
        <xsl:value-of select="$result/res:binding[@name = 'o']" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="strip-uri">
          <xsl:with-param name="uri" select="$target" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Return a resolvable URI -->
  <xsl:template name="resolve-uri">
    <xsl:param name="uri" />
    <xsl:text>/about/</xsl:text>
    <xsl:call-template name="urlencode">
      <xsl:with-param name="value" select="$uri" />
    </xsl:call-template>
  </xsl:template>

  <!-- Print the CURIE version of a URI using the namespaces defined in an
  external document. -->
  <xsl:template name="to-curie">
    <xsl:param name="uri" />
    <xsl:param name="strip" select="false()" /><!-- fallback to strip-uri? -->
    <xsl:choose>
      <xsl:when test="$namespaces//ns:namespace[starts-with($uri, ns:uri)]">
        <xsl:variable name="ns" select="$namespaces//ns:namespace[starts-with($uri, ns:uri)]" />
        <xsl:value-of select="$ns/ns:prefix" />
        <xsl:text>:</xsl:text>
        <xsl:value-of select="substring($uri, string-length($ns/ns:uri) + 1)" />
      </xsl:when>
      <xsl:when test="$strip">
        <xsl:call-template name="strip-uri">
          <xsl:with-param name="uri" select="$uri" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$uri" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Strip a URI to its last component. E.g., http://example.com/id/test/
  would become test, and http://example.com/def#property would become property.
  -->
  <xsl:template name="strip-uri">
    <xsl:param name="uri" />
    <xsl:choose>
      <xsl:when test="contains($uri, '/')">
        <xsl:choose>
          <xsl:when test="substring-after($uri, '/') = ''">
            <xsl:value-of select="substring-before($uri, '/')" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="strip-uri">
              <xsl:with-param name="uri" select="substring-after($uri, '/')" />
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="contains($uri, '#')">
            <xsl:value-of select="substring-after($uri, '#')" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$uri" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- URL-encode a value -->
	<xsl:variable name="url-hex" select="'0123456789ABCDEF'"/>
	<xsl:variable name="url-ascii"> !"#$%&amp;'()*+,-./0123456789:;&lt;=&gt;?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~</xsl:variable>
	<xsl:variable name="url-safe">!'()*-.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~</xsl:variable>
  <xsl:template name="urlencode">
    <xsl:param name="value" />
    <xsl:if test="$value">
      <xsl:variable name="char" select="substring($value,1,1)" />
      <xsl:choose>
        <xsl:when test="contains($url-safe, $char)">
          <xsl:value-of select="$char" />
        </xsl:when>
        <xsl:when test="contains($url-ascii, $char)">
          <xsl:variable name="codepoint" select="string-length(substring-before($url-ascii,$char)) + 32" />
          <xsl:variable name="hex-digit1" select="substring($url-hex, floor($codepoint div 16) + 1,1)" />
          <xsl:variable name="hex-digit2" select="substring($url-hex, $codepoint mod 16 + 1,1)" />
          <xsl:value-of select="concat('%', $hex-digit1, $hex-digit2)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$char" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="urlencode">
        <xsl:with-param name="value" select="substring($value, 2)" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
<!-- vim:set ts=2 sw=2 et: -->
