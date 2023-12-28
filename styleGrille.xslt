<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink">
    <xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes" />

    <xsl:template match="/Puissance4">
        <html>
            <head>
                <title>Puissance 4</title>
                <!-- Styles supplémentaires si nécessaire -->
            </head>
            <body>
                <!-- Calcul du nombre de jetons pour chaque joueur -->
                <xsl:variable name="rougeCount" select="count(//cellule[jeton='Rouge'])" />
                <xsl:variable name="jauneCount" select="count(//cellule[jeton='Jaune'])" />
                <xsl:variable name="diffCount">
                    <xsl:choose>
                        <xsl:when test="$rougeCount > $jauneCount">
                            <xsl:value-of select="$rougeCount - $jauneCount" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$jauneCount - $rougeCount" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <!-- Vérification de triche -->
                <xsl:if test="$diffCount > 1">
                    <p style="color: red;">Triche détectée: différence de jetons anormale entre les joueurs.</p>
                </xsl:if>

                <!-- Vérification de triche: jetons ne respectant pas la gravité -->
                <xsl:for-each select="grille/colonne">
                    <xsl:if test="cellule[jeton != 'vide'][following-sibling::cellule[jeton = 'vide']]">
                        <p style="color: red;">Triche détectée : certains jetons ne respectent pas la gravité.</p>
                    </xsl:if>
                </xsl:for-each>

                <!-- Exemple d'appel du template pour vérifier un gain vertical -->
                <!-- Changez les valeurs de colIndex et rowIndex selon les besoins -->
                <xsl:variable name="gagnantVertical" select="false()"/>
                <xsl:for-each select="grille/colonne">
                    <xsl:variable name="colIndex" select="position()"/>
                    <xsl:for-each select="cellule[position() &lt;= 4]">
                        <xsl:variable name="rowIndex" select="position()"/>
                        <xsl:variable name="resultat">
                            <xsl:call-template name="verifierGainVertical">
                                <xsl:with-param name="colIndex" select="$colIndex"/>
                                <xsl:with-param name="rowIndex" select="$rowIndex"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:if test="$resultat != ''">
                            <xsl:variable name="gagnantVertical" select="$resultat"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:for-each>

    
               

                <!-- Génération de la grille en SVG -->
                <svg:svg width="350" height="300">
                    <svg:rect width="350" height="300" style="fill:blue" />
                    <xsl:for-each select="grille/colonne">
                        <xsl:variable name="colIndex" select="position() - 1" />
                        <xsl:for-each select="cellule">
                            <xsl:variable name="rowIndex" select="position() - 1" />
                            <xsl:choose>
                                <xsl:when test="jeton='Rouge'">
                                    <svg:image x="{($colIndex) * 50}"
                                               y="{($rowIndex) * 50}"
                                               width="40" height="40"
                                               xlink:href="jetonRouge.svg" />
                                </xsl:when>
                                <xsl:when test="jeton='Jaune'">
                                    <svg:image x="{($colIndex) * 50}"
                                               y="{($rowIndex) * 50}"
                                               width="40" height="40"
                                               xlink:href="jetonJaune.svg" />
                                </xsl:when>
                                <xsl:otherwise>
                                    <svg:image id="empty-{$colIndex}-{$rowIndex}"
                                               x="{($colIndex) * 50}"
                                               y="{($rowIndex) * 50}"
                                               width="40" height="40"
                                               xlink:href="jetonVide.svg"
                                               class="clickable-cell"
                                               data-col-index="{$colIndex}"
                                               data-row-index="{$rowIndex}" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:for-each>
                </svg:svg>
                <p>Gagnant Vertical: <xsl:value-of select="$gagnantVertical"/></p>
            </body>
        </html>
    </xsl:template>

    <xsl:template name="verifierGainVertical">
        <xsl:param name="colIndex"/>
        <xsl:param name="rowIndex"/>
        <xsl:variable name="jetonInitial" select="/Puissance4/grille/colonne[$colIndex]/cellule[$rowIndex]/jeton"/>
        <xsl:if test="$jetonInitial != 'vide' and
                      $jetonInitial = /Puissance4/grille/colonne[$colIndex]/cellule[$rowIndex + 1]/jeton and
                      $jetonInitial = /Puissance4/grille/colonne[$colIndex]/cellule[$rowIndex + 2]/jeton and
                      $jetonInitial = /Puissance4/grille/colonne[$colIndex]/cellule[$rowIndex + 3]/jeton">
            <xsl:value-of select="$jetonInitial"/>
        </xsl:if>
        
    </xsl:template>
    
</xsl:stylesheet>