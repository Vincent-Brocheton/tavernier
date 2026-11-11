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

  String role(TableRole role) => switch (role) {
    TableRole.gm => roleGm,
    TableRole.player => rolePlayer,
  };
}
