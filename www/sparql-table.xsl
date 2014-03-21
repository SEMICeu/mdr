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
  xmlns:res="http://www.w3.org/2005/sparql-results#"
  exclude-result-prefixes="xsl res">

  <xsl:output method="html" indent="yes" encoding="UTF-8" />

  <xsl:template match="res:sparql">
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
    <html>
      <head>
        <meta charset="UTF-8" />
        <title>Query results – Semantic MDR</title>
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

        <p><strong>Linked Data pilots: </strong>
          <a href="http://location.testproject.eu/BEL">Core Location pilot</a> |
          <a href="http://cpsv.testproject.eu/CPSV">Core Public Service pilot</a> |
          <a href="http://org.testproject.eu/MAREG">Organisation Ontology pilot</a> |
          <a href="http://health.testproject.eu/PPP">Plant Protection Products pilot</a> |
          <a href="http://maritime.testproject.eu/CISE">Maritime Surveillance pilot</a>
        </p>

        <p>
          <a href="https://joinup.ec.europa.eu/asset/dcat_application_profile/description" target="_blank"><img alt="DCAT application profile for European data portals" src="https://joinup.ec.europa.eu/sites/default/files/imagecache/community_logo/DCAT_application_profile_for_European_data_portals_logo_0.png" width="70" height="70" /></a>
          <xsl:text> </xsl:text>
          <a href="https://joinup.ec.europa.eu/asset/adms/description" target="_blank"><img alt="Asset Description Metadata Schema (ADMS)" src="http://joinup.ec.europa.eu/sites/default/files/imagecache/community_logo/adms_logo.png" width="70" height="70" /></a>
          <xsl:text> </xsl:text>
          <a href="https://joinup.ec.europa.eu/asset/adms_foss/description" target="_blank"><img alt="Asset Description Metadata Schema for Software (ADMS.SW)" src="http://joinup.ec.europa.eu/sites/default/files/imagecache/community_logo/ADMS_SW_Logo.png" width="70" height="70" /></a>
          <xsl:text> </xsl:text>
          <a href="https://joinup.ec.europa.eu/asset/core_business/description" target="_blank"><img alt="Core Business Vocabulary" src="http://joinup.ec.europa.eu/sites/default/files/imagecache/community_logo/core_business_logo.png" width="70" height="70" /></a>
          <xsl:text> </xsl:text>
          <a href="https://joinup.ec.europa.eu/asset/core_person/description"><img alt="Core Person Vocabulary" src="http://joinup.ec.europa.eu/sites/default/files/imagecache/community_logo/core_person_logo.png" width="70" height="70" /></a>
          <xsl:text> </xsl:text>
          <a href="https://joinup.ec.europa.eu/asset/core_location/description" target="_blank"><img alt="Core Location Vocabulary" src="http://joinup.ec.europa.eu/sites/default/files/imagecache/community_logo/core_location_logo.png" width="70" height="70" /></a>
          <xsl:text> </xsl:text>
          <a href="https://joinup.ec.europa.eu/asset/core_public_service/description" target="_blank"><img alt="Core Public Service Vocabulary" src="https://joinup.ec.europa.eu/sites/default/files/imagecache/community_logo/core_public_service_logo.png" width="70" height="70" /></a>
          <xsl:text> </xsl:text>
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
          <xsl:for-each select="//res:head/res:variable">
            <th><xsl:value-of select="@name" /></th>
          </xsl:for-each>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each select="//res:result">
          <tr>
            <xsl:apply-templates select="."/>
          </tr>
        </xsl:for-each>
      </tbody>
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
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="resolve-uri">
          <xsl:with-param name="uri" select="text()" />
        </xsl:call-template>
      </xsl:attribute>
      <xsl:call-template name="strip-uri">
        <xsl:with-param name="uri" select="text()" />
      </xsl:call-template>
    </a>
  </xsl:template>

  <xsl:template match="res:literal">
    <xsl:value-of select="text()" />
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

  <!-- Return a resolvable URI -->
  <xsl:template name="resolve-uri">
    <xsl:param name="uri" />
    <xsl:text>/about/</xsl:text>
    <xsl:call-template name="urlencode">
      <xsl:with-param name="value" select="$uri" />
    </xsl:call-template>
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
