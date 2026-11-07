import 'package:dnd_content/dnd_content.dart';

import 'computed_sheet.dart';

/// Clé de `PlayState.used` pour les emplacements du niveau [level].
String slotResource(int level) => 'spell-slot:$level';

/// Clé de `PlayState.used` pour les emplacements de pacte.
const pactSlotResource = 'pact-slot';

/// État de jeu d'un personnage : ce qui change à la table, hors de sa fiche.
final class PlayState {
  const PlayState({this.used = const {}, this.concentrationSpellId});

  /// Utilisations dépensées, par ressource.
  final Map<String, int> used;

  /// Un seul sort à concentration à la fois (EF-PJ-09).
  final String? concentrationSpellId;

  int usedOf(String resource) => used[resource] ?? 0;
}

/// Manière de lancer un sort.
final class CastOption {
  const CastOption({
    required this.level,
    required this.left,
    this.resource,
    this.ritual = false,
  });

  /// Niveau auquel le sort est lancé.
  final int level;

  /// Emplacements restants à ce niveau.
  final int left;

  /// Ressource dépensée ; vide pour un rituel ou un sort mineur.
  final String? resource;
  final bool ritual;

  bool get pact => resource == pactSlotResource;
}

/// Manières de lancer [spell] : un sort mineur ne dépense rien, un rituel peut
/// s'en passer, sinon tout emplacement de son niveau ou plus. Les emplacements
/// de pacte et les autres servent aux sorts de toutes les classes (SRD p. 27).
List<CastOption> castOptions(
  SpellData spell,
  ComputedSheet sheet,
  PlayState state,
) {
  if (spell.level == 0) return const [CastOption(level: 0, left: 0)];
  final pact = sheet.pactMagic;
  return [
    for (final (i, total) in sheet.spellSlots.indexed)
      if (i + 1 >= spell.level && total > state.usedOf(slotResource(i + 1)))
        CastOption(
          level: i + 1,
          left: total - state.usedOf(slotResource(i + 1)),
          resource: slotResource(i + 1),
        ),
    if (pact != null &&
        pact.slotLevel >= spell.level &&
        pact.slots > state.usedOf(pactSlotResource))
      CastOption(
        level: pact.slotLevel,
        left: pact.slots - state.usedOf(pactSlotResource),
        resource: pactSlotResource,
      ),
    if (spell.ritual) CastOption(level: spell.level, left: 0, ritual: true),
  ];
}

/// Sort à concentration que lancer [spell] arrêterait, ou `null`.
String? replacedConcentration(
  String spellId,
  SpellData spell,
  PlayState state,
) {
  final current = state.concentrationSpellId;
  return spell.concentration && current != null && current != spellId
      ? current
      : null;
}

/// [state] après avoir lancé [spell] de la manière [option].
PlayState castSpell(
  PlayState state,
  String spellId,
  SpellData spell,
  CastOption option,
) => PlayState(
  used: {
    ...state.used,
    ?option.resource: state.usedOf(option.resource ?? '') + 1,
  },
  concentrationSpellId: spell.concentration
      ? spellId
      : state.concentrationSpellId,
);

/// [state] sans concentration en cours.
PlayState endConcentration(PlayState state) => PlayState(used: state.used);
