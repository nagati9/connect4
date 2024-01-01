<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:svg="http://www.w3.org/2000/svg">
    
    <xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes"/>

   <xsl:template match="/Puissance4">
    <html>
        <head>
            <title>Puissance 4</title>
        </head>
        <body>
            <!-- Génération de la grille en SVG -->
            <svg width="350" height="300" xmlns="http://www.w3.org/2000/svg">
                <!-- Fond de la grille -->
                <rect width="350" height="300" fill="blue"/>

                <!-- Création des cases de la grille -->
                <xsl:for-each select="grille/colonne">
                    <xsl:variable name="colIndex" select="position()"/>
                    <xsl:for-each select="cellule">
                        <xsl:variable name="rowIndex" select="position()"/>
                        <xsl:variable name="jeton" select="jeton"/>

                        <!-- Dessin de la case -->
                        <circle cx="{($colIndex - 0.5) * 50}" cy="{(6 - $rowIndex + 0.5) * 50}" r="20" fill="white"
                                onclick="evt.target.setAttribute('fill', evt.target.getAttribute('fill') === 'red' || evt.target.getAttribute('fill') === 'white' ? 'yellow' : 'red');"/>
                    </xsl:for-each>
                </xsl:for-each>
            </svg>
        </body>
    </html>
</xsl:template>

</xsl:stylesheet>
