import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';

/// Nombre d'étapes de la création (cahier §5.1).
const creationStepCount = 9;

/// Choix obligatoire encore absent d'une étape ; l'interface le traduit.
enum MissingChoice { classChoice, background, tool, species, size }

/// Brouillon de création : les choix déjà faits et la position dans
/// l'assistant. `CharacterInput` exige un personnage complet ; un brouillon
/// peut être incomplet.
final class CreationDraft {
  const CreationDraft({
    this.step = 0,
    this.reached = 0,
    this.classId,
    this.backgroundId,
    this.toolChoice,
    this.speciesId,
    this.size,
  });

  /// Étape affichée (à partir de 0).
  final int step;

  /// Dernière étape atteinte.
  final int reached;
  final String? classId;
  final String? backgroundId;
  final String? toolChoice;
  final String? speciesId;
  final String? size;

  CreationDraft selectClass(String id) => _with(classId: id);

  /// Un autre Historique efface l'outil : ses options ne sont plus les mêmes.
  CreationDraft selectBackground(String id) => id == backgroundId
      ? this
      : CreationDraft(
          step: step,
          reached: reached,
          classId: classId,
          backgroundId: id,
          speciesId: speciesId,
          size: size,
        );

  CreationDraft selectTool(String id) => _with(toolChoice: id);

  /// Une seule taille possible est retenue d'office ; sinon elle reste à
  /// choisir.
  CreationDraft selectSpecies(String id, List<String> sizes) => id == speciesId
      ? this
      : CreationDraft(
          step: step,
          reached: reached,
          classId: classId,
          backgroundId: backgroundId,
          toolChoice: toolChoice,
          speciesId: id,
          size: sizes.length == 1 ? sizes.single : null,
        );

  CreationDraft selectSize(String value) => _with(size: value);

  /// Va à une étape atteinte. On ne quitte vers l'avant qu'une étape
  /// complète : changer d'Historique peut rouvrir un choix obligatoire.
  CreationDraft goTo(int target, ActiveContent content) {
    final blocked = target > step && missingChoice(this, content) != null;
    return target > reached || blocked ? this : _with(step: target);
  }

  CreationDraft previous() => step == 0 ? this : _with(step: step - 1);

  /// Passe à l'étape suivante si celle-ci est complète.
  CreationDraft next(ActiveContent content) {
    if (missingChoice(this, content) != null || step == creationStepCount - 1) {
      return this;
    }
    final target = step + 1;
    return _with(step: target, reached: target > reached ? target : reached);
  }

  CreationDraft _with({
    int? step,
    int? reached,
    String? classId,
    String? toolChoice,
    String? size,
  }) => CreationDraft(
    step: step ?? this.step,
    reached: reached ?? this.reached,
    classId: classId ?? this.classId,
    backgroundId: backgroundId,
    toolChoice: toolChoice ?? this.toolChoice,
    speciesId: speciesId,
    size: size ?? this.size,
  );
}

/// Choix manquant de l'étape affichée, ou `null` si elle est complète.
MissingChoice? missingChoice(CreationDraft draft, ActiveContent content) {
  switch (draft.step) {
    case 0:
      return draft.classId == null ? MissingChoice.classChoice : null;
    case 1:
      if (draft.backgroundId == null) return MissingChoice.background;
      final background =
          content.entity(draft.backgroundId!)?.data as BackgroundData?;
      return background?.toolChoiceCategory != null && draft.toolChoice == null
          ? MissingChoice.tool
          : null;
    case 2:
      if (draft.speciesId == null) return MissingChoice.species;
      return draft.size == null ? MissingChoice.size : null;
    default:
      return null;
  }
}
