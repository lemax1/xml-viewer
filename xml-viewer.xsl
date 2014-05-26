<?xml version="1.0"?>
<!-- This Source Code Form is subject to the terms of the Mozilla Public
   - License, v. 2.0. If a copy of the MPL was not distributed with this
   - file, You can obtain one at http://mozilla.org/MPL/2.0/. -->

<!--<!DOCTYPE overlay [-->
<!--<!ENTITY % prettyPrintDTD SYSTEM "FFpp.dtd">-->
<!--%prettyPrintDTD;-->
<!--<!ENTITY % globalDTD SYSTEM "FFglobal.dtd">-->
<!--%globalDTD;-->
<!--]>-->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml">

    <xsl:output method="xml"/>

    <xsl:template match="/">
        <!--       <style>
             <![CDATA[
           .xmlviewer pre {
           font: inherit;
           color: inherit;
           white-space: inherit;
           margin: 0 0 0 5ch;
           }
           .xmlviewer pre[id]:before,
           .xmlviewer span[id]:before {
           content: counter(line) " ";
           counter-increment: line;
           -moz-user-select: none;
           display: inline-block;
           width: 5ch;
           margin: 0 0 0 -5ch;
           text-align: right;
           color: #ccc;
           font-weight: normal;
           font-style: normal;
           }
           .xmlviewer .start-tag {
           color: purple;
           font-weight: bold;
           }
           .xmlviewer .end-tag {
           color: purple;
           font-weight: bold;
           }
           .xmlviewer .comment {
           color: green;
           font-style: italic;
           }
           .xmlviewer .cdata {
           color: #CC0066;
           }
           .xmlviewer .doctype {
           color: steelblue;
           font-style: italic;
           }
           .xmlviewer .entity {
           color:#FF4500;
           font-weight: normal;
           }
           .xmlviewer .text {
           font-weight: normal;
           }
           .xmlviewer .attribute-name {
           color: black;
           font-weight: bold;
           }
           .xmlviewer .attribute-value {
           color: blue;
           font-weight: normal;
           }
           .xmlviewer .markupdeclaration {
           color: steelblue;
           font-style: italic;
           }
           .xmlviewer span:not(.error), a:not(.error) {
           unicode-bidi: embed;
           }
           .xmlviewer span[id] {
           unicode-bidi: -moz-isolate;
           }
           .xmlviewer .error,
           {
           color: red;
           font-weight: bold;
           }

           .xmlviewer .expander-content {
           padding-left: 1em;
           }

           .xmlviewer .expander {
           cursor: pointer;
           -moz-user-select: none;
           text-align: center;
           vertical-align: top;
           width: 1em;
           display: inline-block;
           margin-left: -1em;
           }

           .xmlviewer .expander-closed > .expander-content {
           display: none;
           }

           .xmlviewer .comment {
      family: monospace;
           white-space: pre;
           ]]>
         </style>
             <script>
                 $(function(){
                     $(document).on('click','.expander',function(){
                         $this = $(this);
                         $parent = $this.parent();
                         $parent.toggleClass('expander-open expander-closed');
                         if($this.text()=='−')
                             $this.text('+');
                         else
                             $this.text('−');
                     })
                 });
             </script>-->
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="*">
        <div>
            <xsl:text>&lt;</xsl:text>
            <span class="xmlviewer start-tag"><xsl:value-of select="name(.)"/></span>
            <xsl:apply-templates select="@*"/>
            <xsl:text>/&gt;</xsl:text>
        </div>
    </xsl:template>

    <xsl:template match="*[node()]">
        <div>
            <xsl:text>&lt;</xsl:text>
            <span class="xmlviewer start-tag"><xsl:value-of select="name(.)"/></span>
            <xsl:apply-templates select="@*"/>
            <xsl:text>&gt;</xsl:text>

            <span class="xmlviewer text"><xsl:value-of select="."/></span>

            <xsl:text>&lt;/</xsl:text>
            <span class="xmlviewer end-tag"><xsl:value-of select="name(.)"/></span>
            <xsl:text>&gt;</xsl:text>
        </div>
    </xsl:template>

    <xsl:template match="*[* or processing-instruction() or comment() or string-length(.) &gt; 50]">
        <div class="xmlviewer expander-open">
            <xsl:call-template name="expander"/>

            <xsl:text>&lt;</xsl:text>
            <span class="xmlviewer start-tag"><xsl:value-of select="name(.)"/></span>
            <xsl:apply-templates select="@*"/>
            <xsl:text>&gt;</xsl:text>

            <div class="xmlviewer expander-content"><xsl:apply-templates/></div>

            <xsl:text>&lt;/</xsl:text>
            <span class="xmlviewer end-tag"><xsl:value-of select="name(.)"/></span>
            <xsl:text>&gt;</xsl:text>
        </div>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:text> </xsl:text>
        <span class="xmlviewer attribute-name"><xsl:value-of select="name(.)"/></span>
        <xsl:text>=</xsl:text>
        <span class="xmlviewer attribute-value">"<xsl:value-of select="."/>"</span>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:if test="normalize-space(.)">
            <xsl:value-of select="."/>
        </xsl:if>
    </xsl:template>

    <!--<xsl:template match="processing-instruction()">-->
    <!--<div class="xmlviewer pi">-->
    <!--<xsl:text>&lt;?</xsl:text>-->
    <!--<xsl:value-of select="name(.)"/>-->
    <!--<xsl:text> </xsl:text>-->
    <!--<xsl:value-of select="."/>-->
    <!--<xsl:text>?&gt;</xsl:text>-->
    <!--</div>-->
    <!--</xsl:template>-->

    <!--<xsl:template match="processing-instruction()[string-length(.) &gt; 50]">-->
    <!--<div class="xmlviewer expander-open">-->
    <!--<xsl:call-template name="expander"/>-->

    <!--<span class="xmlviewer pi">-->
    <!--<xsl:text> &lt;?</xsl:text>-->
    <!--<xsl:value-of select="name(.)"/>-->
    <!--</span>-->
    <!--<div class="xmlviewer expander-content pi"><xsl:value-of select="."/></div>-->
    <!--<span class="xmlviewer pi">-->
    <!--<xsl:text>?&gt;</xsl:text>-->
    <!--</span>-->
    <!--</div>-->
    <!--</xsl:template>-->

    <xsl:template match="comment()">
        <div class="xmlviewer comment">
            <xsl:text>&lt;!--</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>--&gt;</xsl:text>
        </div>
    </xsl:template>

    <xsl:template match="comment()[string-length(.) &gt; 50]">
        <div class="xmlviewer expander-open">
            <xsl:call-template name="expander"/>

            <span class="xmlviewer comment">
                <xsl:text>&lt;!--</xsl:text>
            </span>
            <div class="xmlviewer expander-content comment">
                <xsl:value-of select="."/>
            </div>
            <span class="xmlviewer comment">
                <xsl:text>--&gt;</xsl:text>
            </span>
        </div>
    </xsl:template>

    <xsl:template name="expander">
        <div class="xmlviewer expander">-<!--&#x2212;--></div>
    </xsl:template>

</xsl:stylesheet>
