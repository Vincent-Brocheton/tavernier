# Relecture du bestiaire (T-06)

Fiche écrite par `extract-monsters` : ne pas la modifier à la main. Le suivi de la relecture se fait sur la carte Trello T-06.

## Contrôles automatiques

- **Extraction** : 330 profils ; chaque modificateur lu concorde avec sa valeur.
- **Construction du pack** : FP, PX et BM selon les tables du SRD, JS, Perception passive, PV et dégâts moyens.
- **Seconde lecture** contre le texte en mise en page : FP et PX, PV et dés de vie, caractéristiques et JS, CA et Initiative (`tools/srd_builder/test/srd_monsters_test.dart`).

## À vérifier en priorité

### Coquilles du PDF corrigées

- p. 286 — Jeune dragon blanc : « Int 6 −2 2 Sag 11 +0 +3 Cha 12 +1 +1 » lu « Int 6 −2 −2 Sag 11 +0 +3 Cha 12 +1 +1 » (le signe du JS d’Intelligence manque ; le dragon ne maîtrise pas ce JS, qui vaut son modificateur).
- p. 347 — Fanatique de secte : « Arme spirituelle 2/jour). » lu « Arme spirituelle (2/jour). » (la parenthèse ouvrante manque).
- p. 329 — Archimage : « FP 12 (8 000 PX ; BM +4) » lu « FP 12 (8 400 PX ; BM +4) » (8 000 PX pour un FP 12, que la table du SRD et le SRD anglais donnent à 8 400).

### Écarts aux règles de calcul

- p. 329 — Archimage : Initiative +7 : Dex +2 plus 0, 1 ou 2 fois BM +4 attendu
- p. 353 — Tertre errant : Discrétion +3 : +2 ou +5 attendu
- p. 368 — Grenouille géante : Discrétion +4 : +3 ou +5 attendu

### Lectures incertaines de l’extracteur

- p. 272 — Aboleth : suite de « Nuage de mucus » : Quand la créature maudite n’est pas dans l’eau, elle subit 6 (1d12) dégâts d’acide à la fin de chaque période de 10 minutes, sauf si sa peau est humidifiée dans l’intervalle.
- p. 272 — Aboleth : suite de « Assimilation de mémoire » : Réussite : demi-dégâts. Échec ou réussite : L’aboleth acquiert les souvenirs de la cible si elle est Humanoïde et si cette action la fait tomber à 0 point de vie.
- p. 272 — Aboleth : suite de « Domination d’esprit » : La cible réitère le JS chaque fois qu’elle subit des dégâts, ainsi qu’à la fin de toute période de 24 heures passée à plus de 1,5 km de l’aboleth, et met un terme à l’effet sur elle-même en cas de réussite.
- p. 274 — Babélien : suite de « Charabia » : 1–4. La cible ne fait rien. 5–6. La cible n’entreprend ni action ni action Bonus, et consacre tout son déplacement dans une direction aléatoire. 7–8. La cible effectue une attaque de corps à corps contre une créature déterminée aléatoirement à portée d’allonge (elle ne fait rien si une telle attaque n’est pas possible).
- p. 274 — Babélien : suite de « Crachat aveuglant » : Échec : 7 (2d6) dégâts radiants, et la cible subit l’état Aveuglé jusqu’à la fin du tour suivant du babélien.
- p. 279 — Cockatrice : suite de « Morsure pétrifiante » : Deuxième échec : la cible subit l’état Pétrifié, qui remplace l’état Entravé, pendant 24 heures.
- p. 280 — Cube gélatineux : suite de « Cube de vase » : Les créatures dans le cube bénéficient d’un Abri total, sachant que le cube peut contenir une créature de taille G ou jusqu’à quatre créatures de taille M ou P.
- p. 280 — Cube gélatineux : suite de « Cube de vase » : Au prix d’une action, une créature dans un rayon de 1,50 m du cube peut en extraire une autre ou un objet à condition de réussir un test de Force (Athlétisme) DD 12, l’opération lui infligeant 10 (3d6) dégâts d’acide.
- p. 280 — Cube gélatineux : suite de « Enveloppement » : 1,50 m du cube. S’il n’y a pas d’espace inoccupé dans ce rayon, la cible rate en fait son JS.
- p. 281 — Demi-dragon : Résistances non repris : type de dégâts choisi pour le trait Origine draconique ci-après
- p. 304 — Dragon-tortue : suite de « Souffle de vapeur » : Échec : 56 (16d6) dégâts de feu. Réussite : demi-dégâts. Échec ou réussite : être immergé dans l’eau n’octroie pas la Résistance à ces dégâts de feu.
- p. 308 — Enlaceur : dégâts non lus : la cible subit l’état Agrippé (évasion DD 14) par l’un des six tentacules, ainsi que l’état Empoisonné tant qu’elle est Agrippée. ⏎ Le tentacule peut subir des dégâts et libère la créature Agrippée s’il est détruit (CA 20, 10 pv, Immunité contre les dégâts psychiques et de poison). Infliger des dégâts à un tentacule n’en inflige aucun à l’enlaceur, et tout tentacule ainsi détruit repousse au début du tour suivant de l’enlaceur.
- p. 310 — Fantôme : suite de « Possession » : Réussite : la cible est immunisée contre la Possession de ce fantôme pendant 24 heures.
- p. 321 — Guenaude nocturne : suite de « Sac des âmes » : Le profil du sac est le suivant : CA 15, 20 Pv et Résistance à tous les dégâts. Le sac tombe en poussière s’il est réduit à 0 point de vie. Si le sac est détruit, les âmes qu’il contenait sont libérées. Il faut 7 jours à la guenaude pour créer un nouveau sac.
- p. 321 — Guenaude nocturne : usage non lu : Cauchemars accablants (1/jour ; sac des âmes requis)
- p. 329 — Archimage : Immunités, précision non reprise : Charmé (avec esprit impénétrable)
- p. 330 — Manteleur : suite de « Enveloppement » : Pour se décrocher, le manteleur doit dépenser 1,50 m de déplacement. La cible ou une créature dans un rayon de 1,50 m peut entreprendre une action pour tenter de décrocher le manteleur, ce qui nécessite de réussir un test de Force (Athlétisme) DD 14.
- p. 338 — Tapis étrangleur : suite de « Étouffement » : Tant qu’il agrippe la cible, le tapis ne peut pas entreprendre cette action, il réduit de moitié les dégâts qu’il subit (arrondis à l’inférieur) et la cible subit autant de dégâts que lui.
- p. 342 — Pouding noir : suite de « Masse corrosive » : En 1 minute, le pouding peut dévorer une épaisseur de 60 cm de bois ou métal non magique.
- p. 344 — Rakshasa : Vulnérabilités non repris : dégâts perforants infligés avec une arme maniée par une créature sous l’effet du sort bénédiction
- p. 352 — Strige : suite de « Trompe » : La strige peut se détacher de la cible en y consacrant 1,50 m de déplacement. La cible ou une créature dans un rayon de 1,50 m d’elle peut décrocher la strige au prix d’une action.
- p. 356 — Familier de vampire : Immunités, précision non reprise : Charmé (sauf par son maître vampire)
- p. 357 — Vampire : suite de « Changement d’aspect » : Tant qu’il est sous forme de chauve-souris, il ne peut pas parler. Son profil de jeu, outre sa catégorie de taille et sa Vitesse, reste le même.
- p. 358 — Vase grise : suite de « Masse corrosive » : La vase ronge le métal et le bois non magiques à raison de 5 cm d’épaisseur par round.

## Profils par page

| Page | Profils |
|---|---|
| 272 | Aboleth, Âme-en-peine |
| 273 | Ankheg, Araignée de phase, Assassin |
| 274 | Autrache, Sentinelle azer, Babélien |
| 275 | Balor, Bandit, Chef de bande |
| 276 | Basilic, Béhir, Berserker, Blême |
| 277 | Bulette, Soldat centaure, Criard |
| 278 | Thallophyte violette, Chevalier, Chien du trépas, Chien esquiveur |
| 279 | Chimère, Chtuul, Cockatrice |
| 280 | Couatl, Cube gélatineux |
| 281 | Demi-dragon, Déva, Diable barbelé |
| 282 | Diable barbu, Diable cornu |
| 283 | Diable des chaînes, Diable gelé |
| 284 | Diable osseux, Diablotin, Diantrefosse |
| 285 | Djinn |
| 286 | Doppelganger, Dragonnet blanc, Jeune dragon blanc |
| 287 | Dragon blanc adulte, Dragon blanc vénérable |
| 288 | Dragonnet bleu, Jeune dragon bleu, Dragon bleu adulte |
| 289 | Dragon bleu vénérable, Dragonnet d’airain, Jeune dragon d’airain |
| 290 | Dragon d’airain adulte, Dragon d’airain vénérable |
| 291 | Dragonnet d’argent, Jeune dragon d’argent |
| 292 | Dragon d’argent adulte, Dragon d’argent vénérable |
| 293 | Dragonnet d’or, Jeune dragon d’or |
| 294 | Dragon d’or adulte, Dragon d’or vénérable |
| 295 | Dragonnet de bronze, Jeune dragon de bronze |
| 296 | Dragon de bronze adulte, Dragon de bronze vénérable |
| 297 | Dragonnet de cuivre, Jeune dragon de cuivre, Dragon de cuivre adulte |
| 298 | Dragon de cuivre vénérable |
| 299 | Dragonnet noir, Jeune dragon noir, Dragon noir adulte |
| 300 | Dragon noir vénérable, Dragonnet rouge |
| 301 | Jeune dragon rouge, Dragon rouge adulte, Dragon rouge vénérable |
| 302 | Dragonnet vert, Jeune dragon vert |
| 303 | Dragon vert adulte, Dragon vert vénérable |
| 304 | Dragon-tortue, Dretch, Drider |
| 305 | Druide, Dryade, Éclaireur |
| 306 | Éfrit, Élémentaire de l’air |
| 307 | Élémentaire de l’eau, Élémentaire de la terre, Élémentaire du feu |
| 308 | Enlaceur, Érinye |
| 309 | Espion, Esprit follet, Ettercap |
| 310 | Ettin, Fantôme, Feu follet |
| 311 | Garde animé, Garde |
| 312 | Capitaine de la garde, Gargouille, Géant des collines, Géant des nuages |
| 313 | Géant des pierres, Géant des tempêtes, Géant du feu |
| 314 | Géant du givre, Gelée ocre, Glabrezu |
| 315 | Gladiateur, Combattant gnoll, Sbire gobelin |
| 316 | Combattant gobelin, Chef gobelin, Combattant gobelours |
| 317 | Traqueur gobelours, Golem d’argile, Golem de chair |
| 318 | Golem de fer, Golem de pierre |
| 319 | Gorgone, Goule, Grick |
| 320 | Griffon, Gros-bras, Chef gros-bras, Guenaude marine |
| 321 | Guenaude nocturne, Guenaude verte |
| 322 | Harpie, Hezrou |
| 323 | Hibours, Hippogriffe |
| 324 | Combattant hobgobelin, Capitaine hobgobelin, Homoncule, Horriflamme, Hydre |
| 325 | Incube, Combattant kobold, Kraken |
| 326 | Lamie, Lémure |
| 327 | Liche, Licorne |
| 328 | Loup arctique, Loup-garou |
| 329 | Mage, Archimage, Magmatique |
| 330 | Mante obscure, Manteleur |
| 331 | Manticore, Marilith, Méduse |
| 332 | Méphite gelé, Méphite magmatique, Méphite poussiéreux |
| 333 | Méphite vaporeux, Merrow, Mimique |
| 334 | Minotaure de Baphomet, Molosse infernal, Momie, Momie auguste |
| 335 | Naga corrupteur |
| 336 | Naga gardien, Nalfeshnie, Nécronte |
| 337 | Noble, Armure animée, Épée volante |
| 338 | Tapis étrangleur, Ogre, Ombre, Oni |
| 339 | Otyugh, Ours-garou |
| 340 | Oxydeur, Pégase, Pirate, Capitaine pirate |
| 341 | Planétar, Arbre éveillé, Arbuste éveillé |
| 342 | Pouding noir, Acolyte, Prêtre |
| 343 | Pseudodragon, Quasit |
| 344 | Rakshasa, Rat-garou, Remorhaz |
| 345 | Roturier, Rukh, Combattant sahuagin |
| 346 | Salamandre, Sanglier-garou |
| 347 | Satyre, Sectateur, Fanatique de secte, Nuée de sénestres |
| 348 | Solar, Fantassin |
| 349 | Vétéran, Spectre, Sphinx merveilleux |
| 350 | Sphinx érudit, Sphinx valeureux |
| 351 | Squelette, Destrier squelette, Minotaure squelette |
| 352 | Strige, Succube, Sylvanien |
| 353 | Tarasque, Tertre errant |
| 354 | Tirailleur thalasséen, Tigre-garou, Torve |
| 355 | Traqueur invisible, Troll, Abattis de troll |
| 356 | Familier de vampire, Vampirien |
| 357 | Vampire |
| 358 | Vase grise, Ver pourpre, Vouivre |
| 359 | Vrock, Worg, Xorn |
| 360 | Zombi, Ogre zombi, Aigle, Aigle géant, Allosaure |
| 361 | Ankylosaure, Araignée, Araignée géante, Araignée-loup géante |
| 362 | Archélon, Babouin, Belette, Belette géante, Blaireau |
| 363 | Blaireau géant, Cervidé géant, Chacal, Chameau, Chat, Chauve-souris |
| 364 | Chauve-souris géante, Cheval de selle, Cheval de trait, Chèvre, Chèvre géante, Chouette |
| 365 | Chouette géante, Corbeau, Crabe, Crabe géant |
| 366 | Crapaud géant, Crocodile, Crocodile géant, Destrier |
| 367 | Éléphant, Épaulard, Faucon, Faucon de sang, Grand cervidé |
| 368 | Grand singe, Grenouille, Grenouille géante, Guêpe géante |
| 369 | Hippocampe, Hippocampe géant, Hippopotame, Hyène |
| 370 | Hyène géante, Lézard, Lézard géant, Lion, Loup |
| 371 | Loup sanguinaire, Mammouth, Mille-pattes géant, Molosse, Mule |
| 372 | Nuée d’insectes, Nuée de chauves-souris, Nuée de corbeaux |
| 373 | Nuée de piranhas, Nuée de rats, Nuée de serpents venimeux, Ours brun |
| 374 | Ours noir, Ours polaire, Panthère, Petit cervidé, Pieuvre |
| 375 | Pieuvre géante, Piranha, Plésiosaure, Poney, Ptéranodon |
| 376 | Rat, Rat géant, Requin de récif, Requin géant |
| 377 | Requin-chasseur, Rhinocéros, Sanglier, Sanglier géant, Scarabée de feu géant |
| 378 | Scorpion, Scorpion géant, Serpent constricteur, Serpent constricteur géant, Serpent venimeux |
| 379 | Serpent venimeux géant, Serpent volant, Singe géant, Tigre, Tigre à dents de sabre |
| 380 | Tricératops, Tyrannosaure, Vautour, Vautour géant |
