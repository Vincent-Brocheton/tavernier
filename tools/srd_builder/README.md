# srd_builder

CLI qui produit le pack SRD 5.2.1 (FR) à partir des sources JSON (US-02).

```
fvm dart run tools/srd_builder/bin/srd_builder.dart build [--sources <dossier>] [--out <fichier>]
```

- Sources : `sources/pack.json` et `sources/<type>/<slug>.json`, une entité par fichier (`docs/packs/FORMAT_DNDPACK.md`).
- Sortie : `build/srd-5.2.1-fr.dndpack` (ignoré par git).
- Codes de sortie : 0 succès, 1 contenu invalide (chaque problème sur une ligne, avec son fichier), 64 usage.
- Textes de règles : copiés du PDF officiel (`docs/srd/FR_SRD_CC_v5.2.1.pdf`), jamais traduits ni reformulés.
