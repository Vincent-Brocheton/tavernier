import 'package:dnd_content/dnd_content.dart';

import 'computed_sheet.dart';

/// Clé de `PlayState.used` pour les emplacements du niveau [level].
String slotResource(int level) => 'spell-slot:$level';

/// Clé de `PlayState.used` pour les lancers gratuits de [spellId].
String freeCastResource(String spellId) => 'free-cast:$spellId';

/// Clé de `PlayState.used` pour les emplacements de pacte.
const pactSlotResource = 'pact-slot';

/// État de jeu d'un personnage : ce qui change à la table, hors de sa fiche.
final class PlayState {
  const PlayState({
    this.used = const {},
    this.concentrationSpellId,
    this.hpCurrent,
    this.exhaustion = 0,
  });

  /// Utilisations dépensées, par ressource.
  final Map<String, int> used;

  /// Un seul sort à concentration à la fois (EF-PJ-09).
  final String? concentrationSpellId;

  /// PV actuels ; vide tant que le personnage est à son maximum.
  final int? hpCurrent;

  /// Niveaux d'Épuisement.
  final int exhaustion;

  int usedOf(String resource) => used[resource] ?? 0;

  PlayState withUsed(Map<String, int> value) => PlayState(
    used: value,
    concentrationSpellId: concentrationSpellId,
    hpCurrent: hpCurrent,
    exhaustion: exhaustion,
  );

  PlayState withConcentration(String? spellId) => PlayState(
    used: used,
    concentrationSpellId: spellId,
    hpCurrent: hpCurrent,
    exhaustion: exhaustion,
  );

  PlayState withHitPoints(int? value) => PlayState(
    used: used,
    concentrationSpellId: concentrationSpellId,
    hpCurrent: value,
    exhaustion: exhaustion,
  );
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
  bool get free => resource?.startsWith('free-cast:') ?? false;
}

/// Manières de lancer [spell] : un sort mineur ne dépense rien, un rituel peut
/// s'en passer, sinon tout emplacement de son niveau ou plus. Les emplacements
/// de pacte et les autres servent aux sorts de toutes les classes (SRD p. 27).
/// [spellId] donne accès aux lancers gratuits du sort.
List<CastOption> castOptions(
  SpellData spell,
  ComputedSheet sheet,
  PlayState state, {
  String? spellId,
}) {
  if (spell.level == 0) return const [CastOption(level: 0, left: 0)];
  final pact = sheet.pactMagic;
  final free = spellId == null
      ? 0
      : (sheet.freeCasts[spellId] ?? 0) -
            state.usedOf(freeCastResource(spellId));
  return [
    if (free > 0)
      CastOption(
        level: spell.level,
        left: free,
        resource: freeCastResource(spellId!),
      ),
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
) => state
    .withUsed({
      ...state.used,
      ?option.resource: state.usedOf(option.resource ?? '') + 1,
    })
    .withConcentration(
      spell.concentration ? spellId : state.concentrationSpellId,
    );

/// [state] sans concentration en cours.
PlayState endConcentration(PlayState state) => state.withConcentration(null);
