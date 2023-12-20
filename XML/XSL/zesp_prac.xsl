<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="/">
        <html>
            <body>
                <h1>Zespoły:</h1>
                <ol>
                    <xsl:apply-templates/>
                </ol>
                <xsl:apply-templates mode="table"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="ZESPOLY/ROW">
        <li>
            <a href="#{ID_ZESP}">
                <xsl:value-of select="NAZWA"/>
            </a>
        </li>
    </xsl:template>

    <xsl:template match="ZESPOLY/ROW" mode="table">
        <div>
            <xsl:variable name="employee-count" select="count(PRACOWNICY/ROW[ID_ZESP = current()/ID_ZESP])"/>
            <h3 id="{ID_ZESP}">
                <span>NAZWA: <xsl:value-of select="NAZWA"/></span>
                <br/>
                <span>ADRES: <xsl:value-of select="ADRES"/></span>
            </h3>
            <xsl:if test="$employee-count > 0">
                <table border="1">
                    <tr>
                        <th>Nazwisko</th>
                        <th>Etat</th>
                        <th>Zatrudniony</th>
                        <th>Placa pod.</th>
                        <th>Szef</th>
                    </tr>
                    <xsl:apply-templates select="PRACOWNICY/ROW" mode="table-row">
                        <xsl:sort select="NAZWISKO"/>
                    </xsl:apply-templates>
                </table>
            </xsl:if>
            Liczba pracowników: <xsl:value-of select="$employee-count"/>
            <br/>
        </div>
    </xsl:template>

    <xsl:template match="PRACOWNICY/ROW" mode="table-row">
        <tr>
            <td><xsl:value-of select="NAZWISKO"/></td>
            <td><xsl:value-of select="ETAT"/></td>
            <td><xsl:value-of select="ZATRUDNIONY"/></td>
            <td><xsl:value-of select="PLACA_POD"/></td>
            <td>
                <xsl:choose>
                    <xsl:when test="ID_SZEFA">
                        <xsl:value-of select="//PRACOWNICY/ROW[ID_PRAC = current()/ID_SZEFA]/NAZWISKO"/>
                    </xsl:when>
                    <xsl:otherwise>brak</xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
