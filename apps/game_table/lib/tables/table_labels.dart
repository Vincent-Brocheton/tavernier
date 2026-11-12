// Libellés des réglages d'une table (US-13) : les valeurs viennent des
// énumérations de dnd_data et dnd_rules, les mots des ARB.
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';

import '../l10n/app_localizations.dart';

extension TableLabels on AppLocalizations {
  String statMethod(ScoreMethod method) => switch (method) {
    ScoreMethod.standardArray => methodStandard,
    ScoreMethod.pointBuy => pointBuy,
    ScoreMethod.random => methodRandom,
  };

  String statMethodDetail(ScoreMethod method) => switch (method) {
    ScoreMethod.standardArray => methodStandardHint,
    ScoreMethod.pointBuy => methodPointBuyHint,
    ScoreMethod.random => methodRandomHint,
  };

  String longRestShort(LongRestRule rule) => switch (rule) {
    LongRestRule.fullHitPoints => longRestFullShort,
    LongRestRule.hitDice => longRestHitDiceShort,
  };

  String hpOnLevel(HpOnLevel rule) => switch (rule) {
    HpOnLevel.average => hpAverage,
    HpOnLevel.roll => hpRoll,
  };

  String progression(Progression mode) => switch (mode) {
    Progression.xp => progressionXp,
    Progression.milestones => progressionMilestones,
  };

  /// Nom d'un réglage dans l'activité et les modifications non enregistrées.
  String settingLabel(String field) => switch (field) {
    'statMethod' => fieldMethod,
    'startingLevel' => startingLevelShort,
    'longRest' => previewLongRest,
    'hpOnLevel' => previewHpPerLevel,
    'progression' => previewProgression,
    'fullSheetsVisible' => visibilitySection,
    _ => field,
  };

  /// Valeur d'un réglage, telle que stockée dans l'activité.
  String settingValue(String field, Object? value) {
    T? named<T extends Enum>(List<T> values) =>
        values.asNameMap()[value.toString()];
    return switch (field) {
      'statMethod' => switch (named(ScoreMethod.values)) {
        final method? => statMethod(method),
        null => '$value',
      },
      'longRest' => switch (named(LongRestRule.values)) {
        final rule? => longRestShort(rule),
        null => '$value',
      },
      'hpOnLevel' => switch (named(HpOnLevel.values)) {
        final rule? => hpOnLevel(rule),
        null => '$value',
      },
      'progression' => switch (named(Progression.values)) {
        final mode? => progression(mode),
        null => '$value',
      },
      'fullSheetsVisible' => value == true ? fullSheetsOpen : fullSheetsClosed,
      _ => '$value',
    };
  }

  /// Statut d'une fiche de table (US-15).
  String characterStatus(String? status) => switch (status) {
    'submitted' => statusSubmitted,
    'validated' => statusValidated,
    'changes_requested' => statusChangesRequested,
    'archived' => statusArchived,
    _ => statusDraft,
  };

  /// Ligne d'un emplacement : « Aldric Varenne (en création) ».
  String slotLine(PcSlot slot) => switch (slot.characterName) {
    final name? => slotLineOf(name, characterStatus(slot.status)),
    null => slotEmpty,
  };

  String role(TableRole role) => switch (role) {
    TableRole.gm => roleGm,
    TableRole.player => rolePlayer,
  };
}
