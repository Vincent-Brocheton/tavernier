# Design

## Source

Texte en ordre de lecture (`pdftotext -enc UTF-8`, sans `-layout`), de « Monstres de A à Z » à la fin. `srdSection` et `cleanText` retirent déjà les pieds de page. Dans ce texte, chaque trait ou action tient sur une ligne. Les colonnes du tableau des caractéristiques sont mêlées, mais l'ordre reste constant (voir plus bas).

## Découpage

- **Début d'un profil** : la ligne de type (« Géant de taille G, Chaotique Mauvais », « Nuée de taille M de Bêtes de taille TP, non alignée »). Le nom est la dernière ligne non vide qui la précède. Les phrases du type « Changement d'aspect. … de taille M ou P » ne commencent pas par un type de créature et ne sont donc pas prises.
- **En-tête** : de la ligne de type à la première rubrique (« Traits », « Actions »…), les lignes sont jointes, puis lues par motif. Motifs : `CA n (note)?`, `Initiative ±n (n)`, `Pv n (dés)`, `Vitesse …`, puis les valeurs des caractéristiques, puis les lignes nommées.
- **Lignes nommées** : la chaîne est coupée sur les mots-clés Compétences, Vulnérabilités, Résistances, Immunités, Équipement, Sens, Langues et FP. Dans « Immunités », ce qui précède le `;` est un type de dégâts, ce qui suit un état.
- **Rubriques** : Traits → `trait`, Actions → `action`, Actions Bonus → `bonus`, Réactions → `reaction`, Actions Légendaires → `legendary`. Le paragraphe « Utilisations d'action Légendaire : 3 (4 dans son antre). … » donne `legendary_uses` et `legendary_uses_lair`. Ce n'est pas une action.
- **Entrées** : une ligne `Nom( (usage))?. texte` commence une entrée si le nom compte au plus 6 mots, ne contient ni virgule ni deux-points, et ne commence pas par un mot de phrase (Le, La, L', Les, Si, Tant, Quand, Chaque, Un, Une…). Toute autre ligne prolonge l'entrée précédente avec un saut de ligne : listes de sorts « À volonté : … », paragraphes suivants. Une ligne coupée par un saut de page (sans ponctuation finale) se recolle avec `paragraphs`.

## Caractéristiques

Les valeurs se lisent avec `(For|Dex|Con|Int|Sag|Cha) (\d+)`, dans l'ordre d'apparition. Les nombres signés du bloc, hors Initiative, viennent par paires (modificateur, JS) dans ce même ordre. On le voit sur l'Ogre : For, Int, Dex, Sag, Con, Cha, puis +4 +4, −3 −3, −1 −1, −2 −2, +3 +3, −2 −2. Chaque modificateur lu est comparé à `(valeur − 10) ~/ 2` : en cas d'écart, l'appariement est faux et le profil est signalé comme une erreur.

## Valeurs

- **Distances** : mètres en pieds, `m / 1,5 × 5` (« 1,50 m » donne 5, « 9/36 m » donne [30, 120]).
- **Vitesse** : la première valeur sans mot est `walk`, puis nage → `swim`, vol → `fly`, escalade → `climb`, fouissement → `burrow`. « (vol stationnaire) » donne `hover`. Toute autre partie va dans `speed_note`, telle qu'imprimée.
- **Sens** : Vision dans le noir → `darkvision`, Vision aveugle → `blindsight` (« (aveugle au-delà) » → `blind_beyond`), Perception des vibrations → `tremorsense`, Vision lucide → `truesight`, Perception passive. Une précision entre parenthèses va dans `senses_note`, avec le sens qu'elle accompagne.
- **Tailles** : TP, P, M, G, TG, Gig.
- **Types** : Aberration, Artificiel, Bête, Céleste, Dragon, Élémentaire, Fée, Fiélon, Géant, Humanoïde, Monstruosité, Mort-vivant, Plante et Vase. Une nuée prend le type de ses créatures, au singulier (Bêtes → Bête).
- **Compétences, dégâts, états** : table des noms français vers les identifiants du pack. Un nom inconnu fait échouer l'extraction.
- **FP** : « FP 17 (18 000 PX, ou 20 000 dans son antre ; BM +6) ». La variante « (PX 18 000, …) » se lit aussi.
- **Usages** dans le nom : `n/jour` (`, ou m/jour dans son antre`) → `per_day` et `per_day_lair` ; `recharge 5–6` → `recharge: "5-6"` (tiret ASCII, comme au lot a) ; `recharge après un Repos court ou long` → `rest: "short_or_long"`, `après un Repos long` → `rest: "long"`. Les autres parenthèses restent dans le nom.
- **Attaque** : `(Corps à corps|À distance|Corps à corps ou à distance) : +n, (allonge x m)?( ou )?(portée a/b m)?. Touché : …`. Dégâts : `n (dés) dégâts <type>`, enchaînés par « plus ». Sans dés : `n dégât(s) <type>`. Des dégâts non reconnus vont au fichier de relecture et l'attaque garde ceux qu'on a lus.
- **Jet de sauvegarde** : `JS <Caractéristique> : DD n` en tête du texte.
- **Langues** : « gigant » → « géant » (écart volontaire).
- **Équipement** : découpé sur les virgules hors parenthèses.

## Écriture

Le motif est celui de `extract-magic-items`. Les problèmes possibles sont un slug manquant, une source orpheline ou une erreur de lecture d'un profil ; dans chaque cas, rien n'est écrit et la commande renvoie la liste. Sinon, chaque fichier est réécrit en entier : un monstre n'a ni `effects` ni rien de saisi à la main à garder.

## Tests

- Extraits réels abrégés du PDF dans le test de l'extracteur : Ogre (caractéristiques mêlées), Dragon rouge adulte (antre, Légendaire, recharge, JS, incantation sur plusieurs lignes), une nuée, le Loup-garou, l'Ombre (immunités sur deux lignes, Traits et Actions Bonus).
- `srd_monsters_test.dart` : scénarios de la spec contre les sources écrites ; le nombre de profils ; les monstres de [D1].
- Un test relit chaque ligne de `monster_slugs.tsv` et vérifie que son nom figure dans `docs/srd/FR_SRD_CC_v5.2.1.txt`.
