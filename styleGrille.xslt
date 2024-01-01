<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:svg="http://www.w3.org/2000/svg"
	xmlns:xlink="http://www.w3.org/1999/xlink">
	<xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes" />
	<xsl:template match="/Puissance4">
		<html>
			<head>
				<title>Puissance 4</title>
				<style>
                    body { text-align: center; }
                    svg { margin: auto; display: block; }
                </style>
				<!-- Styles supplémentaires si nécessaire -->
			</head>
			<body>
				<!-- Génération de la grille en SVG et vérification des conditions de victoire -->
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
				<xsl:variable name="rougeCount" select="count(//cellule[jeton='Rouge'])"/>
				<xsl:variable name="jauneCount" select="count(//cellule[jeton='Jaune'])"/>
				<xsl:variable name="videCount" select="count(//cellule[jeton='vide'])"/>
				<xsl:variable name="tricheJetons" select="$rougeCount - $jauneCount > 1 or $jauneCount - $rougeCount > 1"/>
				<xsl:variable name="tricheGravite" select="boolean(//colonne[cellule[jeton != 'vide'][following-sibling::cellule[jeton = 'vide']]])"/>
				<xsl:variable name="triche" select="$tricheJetons or $tricheGravite"/>
				<!-- Vérification et affichage des messages en fonction des conditions -->
				<xsl:choose>
					<!-- Triche détectée -->
					<xsl:when test="$triche">
						<xsl:choose>
							<!-- Triche par la gravité -->
							<xsl:when test="$tricheGravite">
								<p style="color: red;">Grille non valide, Triche détectée : certains jetons ne respectent pas la gravité.</p>
							</xsl:when>
							<!-- Triche par le nombre de jetons -->
							<xsl:otherwise>
								<p style="color: red;">Grille non valide, Triche détectée : différence de jetons anormale entre les joueurs.</p>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="not($triche) and $videCount != 0">
						<!-- Vérifier le gagnant vertical -->
						<xsl:for-each select="grille/colonne">
							<xsl:variable name="colIndex" select="position()"/>
							<xsl:for-each select="cellule[position() &lt;= 4]">
								<xsl:variable name="rowIndex" select="position()"/>
								<xsl:variable name="jetonActuel" select="jeton"/>
								<xsl:if test="$jetonActuel != 'vide' and
                          $jetonActuel = ../cellule[$rowIndex + 1]/jeton and
                          $jetonActuel = ../cellule[$rowIndex + 2]/jeton and
                          $jetonActuel = ../cellule[$rowIndex + 3]/jeton">
									<p>Grille Valide, Gagnant Vertical: 
										<xsl:value-of select="$jetonActuel"/> dans la colonne 
										<xsl:value-of select="$colIndex"/>
									</p>
								</xsl:if>
							</xsl:for-each>
						</xsl:for-each>
						<!-- Vérifier le gagnant horizontal -->
						<xsl:for-each select="grille/colonne/cellule">
							<xsl:variable name="rowIndex" select="position()"/>
							<xsl:for-each select="../../colonne[position() &lt;= 8]">
								<xsl:variable name="colIndex" select="position()"/>
								<xsl:variable name="jetonActuel" select="../colonne[$colIndex]/cellule[$rowIndex]/jeton"/>
								<xsl:if test="$jetonActuel != 'vide' and 
                          $jetonActuel = ../colonne[$colIndex + 1]/cellule[$rowIndex]/jeton and
                          $jetonActuel = ../colonne[$colIndex + 2]/cellule[$rowIndex]/jeton and
                          $jetonActuel = ../colonne[$colIndex + 3]/cellule[$rowIndex]/jeton">
									<p>Grille Valide, Gagnant Horizontal: 
										<xsl:value-of select="$jetonActuel"/> dans la rangée 
										<xsl:value-of select="$rowIndex"/>, à partir de la colonne 
										<xsl:value-of select="$colIndex"/>
									</p>
								</xsl:if>
							</xsl:for-each>
						</xsl:for-each>
						<!-- Vérifier le gagnant diagonal (Haut-Gauche à Bas-Droite) -->
						<xsl:for-each select="grille/colonne[position() &lt;= 4]">
							<xsl:variable name="colIndex" select="position()"/>
							<xsl:for-each select="cellule[position() &lt;= 3]">
								<xsl:variable name="rowIndex" select="position()"/>
								<xsl:variable name="jetonActuel" select="jeton"/>
								<xsl:if test="$jetonActuel != 'vide' and 
                          $jetonActuel = /Puissance4/grille/colonne[$colIndex + 1]/cellule[$rowIndex + 1]/jeton and
                          $jetonActuel = /Puissance4/grille/colonne[$colIndex + 2]/cellule[$rowIndex + 2]/jeton and
                          $jetonActuel = /Puissance4/grille/colonne[$colIndex + 3]/cellule[$rowIndex + 3]/jeton">
									<p>Grille valide, Gagnant Diagonal (Haut-Gauche à Bas-Droite): 
										<xsl:value-of select="$jetonActuel"/> à partir de la colonne 
										<xsl:value-of select="$colIndex"/>, rangée 
										<xsl:value-of select="$rowIndex"/>
									</p>
								</xsl:if>
							</xsl:for-each>
						</xsl:for-each>
						<!-- Vérifier le gagnant diagonal (Haut-Droite à Bas-Gauche) -->
						<xsl:for-each select="grille/colonne[position() &lt;= 7]">
							<xsl:variable name="colIndex" select="position()"/>
							<xsl:for-each select="cellule[position() &lt;= 6]">
								<xsl:variable name="rowIndex" select="position()"/>
								<xsl:variable name="jetonActuel" select="jeton"/>
								<xsl:if test="$jetonActuel != 'vide' and 
                          $jetonActuel = /Puissance4/grille/colonne[$colIndex - 1]/cellule[$rowIndex + 1]/jeton and
                          $jetonActuel = /Puissance4/grille/colonne[$colIndex - 2]/cellule[$rowIndex + 2]/jeton and
                          $jetonActuel = /Puissance4/grille/colonne[$colIndex - 3]/cellule[$rowIndex + 3]/jeton">
									<p>Gagnant Diagonal (Haut-Droite à Bas-Gauche): 
										<xsl:value-of select="$jetonActuel"/> à partir de la colonne 
										<xsl:value-of select="$colIndex"/>, rangée 
										<xsl:value-of select="$rowIndex"/>
									</p>
								</xsl:if>
							</xsl:for-each>
						</xsl:for-each>
					</xsl:when>
					<!-- Match nul -->
					<xsl:when test="$videCount = 0">
						<p>Grille valide, Match nul.</p>
					</xsl:when>
					<!-- Autres cas -->
					<xsl:otherwise>
						<p>Grille valide, partie en cours.</p>
					</xsl:otherwise>
				</xsl:choose>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>