<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="utf-8"/>
  <xsl:strip-space elements="*"/>
  <xsl:output indent="yes" />
  <xsl:template match="text()" />
  
  <xsl:param name="csv" />
  <xsl:param name="cset" />
  
  <xsl:variable name="comma-char" select="','" />
  <xsl:variable name="quote2-char" select="'&#x22;'" />
  <xsl:variable name="line-char" select="'&#xa;'" />
  <xsl:variable name="line1-char" select="'&#xd;'" />
  <xsl:variable name="quote2-char2" select="concat($quote2-char, $quote2-char)" />
  
  <xsl:template match="/">
    <xsl:variable name="text" select="
 unparsed-text($csv,($cset[. ne ''], 'windows-1251')[1])
    " />
    <xsl:variable name="delimiter" select="$comma-char" />
    <xsl:variable name="line-break" select="
 if(string-length($text) ne 0
  and substring($text,1,1) ne $line-char
  and (let $x:=substring-before($text, $line-char)
   return substring($x,string-length($x),1)) eq $line1-char
   ) then concat($line1-char,$line-char)
 else $line-char
    "/>
<tab>
    <xsl:for-each select="tokenize($text,$line-break)">
<row>
      <xsl:attribute name="n" select="position() - 1" />
      <xsl:variable name="qs" select="tokenize(.,$quote2-char)" />    
      <xsl:variable name="qs1" select="
 for $x in 1 to count($qs)
 return if(($x mod 2) eq 0)then $qs[$x] 
  else replace($qs[$x],$delimiter,$line-break)
      " />
      <xsl:for-each select="tokenize(string-join($qs1,$quote2-char),$line-break)">
        <xsl:variable name="token" select="normalize-space(.)"/>
        <xsl:if test="$token ne ''">
<cell>
          <xsl:attribute name="col" select="position()"/>
          <xsl:variable name="cell" select="
 if(substring($token,1,1) ne $quote2-char) then $token
 else let $x:=string-length($token) return
  if(substring($token,$x,1) ne $quote2-char) then $token
  else replace(substring($token,2,$x - 2),$quote2-char2,$quote2-char)
          " />
          <xsl:value-of select="$cell"/>
</cell>
      </xsl:if>
      </xsl:for-each>
</row>
    </xsl:for-each>
</tab>      
  </xsl:template>

</xsl:stylesheet>
