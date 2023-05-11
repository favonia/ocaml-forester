<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="utf-8" indent="yes" />

  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/">
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
    <html>
      <head>
        <meta name="viewport" content="width=device-width" />
        <link rel="stylesheet" href="style.css" />
        <link rel="stylesheet"
          href="https://fonts.googleapis.com/css2?family=Inria+Sans:ital,wght@0,300;0,400;0,700;1,300;1,400;1,700&amp;amp;display=swap" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.6/dist/katex.min.css"
          integrity="sha384-mXD7x5S50Ko38scHSnD4egvoExgMPbrseZorkbE49evAfv9nNcbrXJ8LLNsDgh9d"
          crossorigin="anonymous" />
        <script defer="true" src="https://cdn.jsdelivr.net/npm/katex@0.16.6/dist/katex.min.js"
          integrity="sha384-j/ZricySXBnNMJy9meJCtyXTKMhIJ42heyr7oAdxTDBy/CYA9hzpMo+YTNV5C+1X"
          crossorigin="anonymous"></script>
        <script defer="true"
          src="https://cdn.jsdelivr.net/npm/katex@0.16.6/dist/contrib/auto-render.min.js"
          integrity="sha384-+VBxd3r6XgURycqtZ117nYw44OOcIax56Z4dCRWbxyPt0Koah1uHoK0o4+/RRE05"
          crossorigin="anonymous" onload="renderMathInElement(document.body);"></script>
      </head>
      <body>
        <article class="container">
          <xsl:apply-templates select="tree" />
        </article>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="frontmatter/title">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="frontmatter/taxon">
    <xsl:value-of select="." />
  </xsl:template>

  <xsl:template match="frontmatters/authors">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="authors">
    <address class="author">
      <xsl:for-each select="author">
        <xsl:apply-templates />
        <xsl:if test="position()!=last()">
          <xsl:text>, </xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:if test="contributor">
        <xsl:text> with contributions from </xsl:text>
        <xsl:for-each select="contributor">
          <xsl:apply-templates />
          <xsl:if test="position()!=last()">
            <xsl:text>, </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:if>
    </address>
  </xsl:template>


  <xsl:template match="mainmatter">
    <div class="tree-content">
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="frontmatter">
    <header>
      <h1>
        <xsl:choose>
          <xsl:when test="taxon">
            <xsl:apply-templates select="taxon" />
            <xsl:text> (</xsl:text>
            <xsl:apply-templates select="title" />
            <xsl:text>)</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="title" />
          </xsl:otherwise>
        </xsl:choose>

        <xsl:text> </xsl:text>
        <a class="slug">
          <xsl:attribute name="href">
            <xsl:value-of select="route" />
          </xsl:attribute>
          <xsl:text>[</xsl:text>
          <xsl:value-of select="addr" />
          <xsl:text>]</xsl:text>
        </a>
      </h1>
      <div class="metadata">
        <xsl:apply-templates select="date" />
        <xsl:if test="date and authors">
          <xsl:text> · </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="authors" />
      </div>
    </header>
  </xsl:template>

  <xsl:template match="backmatter/context">
    <xsl:if test="tree">
      <section class="block">
        <h2>Context</h2>
        <xsl:apply-templates select="tree" />
      </section>
    </xsl:if>
  </xsl:template>

  <xsl:template match="backmatter/contributions">
    <xsl:if test="tree">
      <section class="block">
        <h2>Contributions</h2>
        <xsl:apply-templates select="tree" />
      </section>
    </xsl:if>
  </xsl:template>

  <xsl:template match="backmatter/related">
    <xsl:if test="tree">
      <section class="block">
        <h2>Related</h2>
        <xsl:apply-templates select="tree" />
      </section>
    </xsl:if>
  </xsl:template>

  <xsl:template match="backmatter/backlinks">
    <xsl:if test="tree">
      <section class="block">
        <h2>Backlinks</h2>
        <xsl:apply-templates select="tree" />
      </section>
    </xsl:if>
  </xsl:template>


  <xsl:template match="/tree/backmatter">
    <footer>
      <xsl:apply-templates select="context|backlinks|related|contributions" />
    </footer>
  </xsl:template>

  <xsl:template match="/tree|mainmatter/tree">
    <section class="block">
      <details open="open">
        <summary>
          <xsl:apply-templates select="frontmatter" />
        </summary>
        <xsl:apply-templates select="mainmatter" />
      </details>
    </section>
    <xsl:apply-templates select="backmatter" />
  </xsl:template>

  <xsl:template match="backmatter/*/tree">
    <section class="block">
      <details>
        <summary>
          <xsl:apply-templates select="frontmatter" />
        </summary>
        <xsl:apply-templates select="mainmatter" />
      </details>
    </section>
  </xsl:template>
</xsl:stylesheet>