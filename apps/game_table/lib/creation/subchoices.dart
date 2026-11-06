import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';

import 'creation_draft.dart';
import 'step_layout.dart';

/// Nature d'une section de l'étape Sous-choix.
enum SubchoiceKind {
  classSkills,
  classTools,
  masteries,
  fightingStyle,
  originFeat,
  effect,
}

/// Raison pour laquelle une option n'est pas disponible.
enum OptionBlock {
  /// Maîtrise déjà acquise : elle ne se prend pas deux fois.
  known,

  /// Expertise sur une compétence non maîtrisée.
  notProficient,

  /// Don non répétable déjà obtenu.
  notRepeatable,
}

/// Une option de section.
final class SubchoiceOption {
  const SubchoiceOption({
    required this.id,
    required this.label,
    this.detail,
    this.block,
  });

  final String id;
  final String label;
  final String? detail;
  final OptionBlock? block;
}

/// Une section de l'étape : un choix à faire et ses options.
final class Subchoice {
  const Subchoice({
    required this.kind,
    required this.count,
    required this.chosen,
    required this.options,
    this.choiceId,
    this.sourceId,
  });

  final SubchoiceKind kind;
  final int count;
  final List<String> chosen;
  final List<SubchoiceOption> options;

  /// Pour [SubchoiceKind.effect] : identifiant du `choice`.
  final String? choiceId;

  /// Pour [SubchoiceKind.effect] : entité qui ouvre le choix.
  final String? sourceId;

  /// Identifiant de section, stable entre deux affichages.
  String get key => choiceId ?? kind.name;

  /// Sélections devenues impossibles.
  List<SubchoiceOption> get invalid => [
    for (final option in options)
      if (option.block != null && chosen.contains(option.id)) option,
  ];

  bool get complete => chosen.length == count && invalid.isEmpty;
}

/// Première phrase du premier paragraphe d'un texte de règles, sans la
/// formule d'annonce des dons. « cf. » ne termine pas une phrase.
String firstSentence(String text) {
  const announce = 'Vous recevez les bénéfices suivants. ';
  final body = text.startsWith(announce)
      ? text.substring(announce.length)
      : text;
  final line = body.split('\n').first;
  final end = RegExp(r'(?<!\bcf)\. ').firstMatch(line);
  return end == null ? line : line.substring(0, end.start + 1);
}

/// Aptitudes de classe, traits d'espèce et don d'origines du brouillon : ce
/// qui peut ouvrir un choix.
List<String> _sources(CreationDraft draft, ActiveContent content) {
  final cls = content.entity(draft.classId ?? '')?.data;
  final species = content.entity(draft.speciesId ?? '')?.data;
  return [
    if (cls is ClassData) ...levelOneFeatures(cls),
    if (species is SpeciesData) ...[for (final t in species.traits) '$t'],
    ?draft.originFeat,
  ];
}

/// Sections de l'étape Sous-choix pour ce brouillon.
List<Subchoice> subchoiceSections(CreationDraft draft, ActiveContent content) {
  final cls = content.entity(draft.classId ?? '')?.data;
  if (cls is! ClassData) return const [];
  final background =
      content.entity(draft.backgroundId ?? '')?.data as BackgroundData?;
  final sources = _sources(draft, content);
  final open = openChoices(content, sources);
  final categories = grantedFeatCategories(content, sources);

  final fromBackground = {
    for (final id in background?.skillProficiencies ?? const <ContentId>[])
      '$id',
  };
  // Maîtrises prises par un autre choix que [except].
  Set<String> pickedElsewhere(String except) => {
    if (except != 'classSkills') ...draft.classSkills,
    for (final choice in open)
      if (choice.id != except && !choice.options.any((o) => o.expertise))
        ...?draft.choices[choice.id],
  };

  SubchoiceOption effectOption(OpenChoice choice, ChoiceOption option) {
    final known = {
      ...fromBackground,
      ...pickedElsewhere(choice.id),
      startingLanguageId,
      ...draft.languages,
    };
    return SubchoiceOption(
      id: option.pick,
      label: option.label,
      block: option.expertise
          ? (known.contains(option.pick) ? null : OptionBlock.notProficient)
          : (known.contains(option.pick) ? OptionBlock.known : null),
    );
  }

  List<SubchoiceOption> feats(FeatCategory category, {String? taken}) => [
    for (final entity in sortedEntities(content, 'feat'))
      if (entity.data case final FeatData data when data.category == category)
        SubchoiceOption(
          id: '${entity.id}',
          label: entity.name,
          detail: firstSentence(entity.textFr ?? ''),
          block: '${entity.id}' == taken && !data.repeatable
              ? OptionBlock.notRepeatable
              : null,
        ),
  ];

  final mastery = masteryOptions(content, cls);
  final masteryWeapons = {for (final w in mastery.weapons) '${w.id}'};
  return [
    Subchoice(
      kind: SubchoiceKind.classSkills,
      count: cls.skillChoiceCount,
      chosen: draft.classSkills,
      options: [
        for (final skill in cls.skillChoices)
          SubchoiceOption(
            id: '$skill',
            label: namesOf(content, [skill]),
            block:
                {
                  ...fromBackground,
                  ...pickedElsewhere('classSkills'),
                }.contains('$skill')
                ? OptionBlock.known
                : null,
          ),
      ]..sort((a, b) => a.label.compareTo(b.label)),
    ),
    if (cls.toolChoiceCategory case final category?)
      Subchoice(
        kind: SubchoiceKind.classTools,
        count: cls.toolChoiceCount,
        chosen: draft.classTools,
        options: [
          for (final tool in sortedEntities(content, 'tool'))
            if ((tool.data as ToolData).category == category)
              SubchoiceOption(
                id: '${tool.id}',
                label: tool.name.split(' : ').last,
              ),
        ],
      ),
    if (mastery.slots > 0)
      Subchoice(
        kind: SubchoiceKind.masteries,
        count: mastery.slots,
        chosen: draft.masteries,
        options: [
          for (final weapon in sortedEntities(content, 'weapon'))
            if (masteryWeapons.contains('${weapon.id}'))
              SubchoiceOption(
                id: '${weapon.id}',
                label: weapon.name,
                detail: namesOf(content, [(weapon.data as WeaponData).mastery]),
              ),
        ],
      ),
    if (categories.contains('fighting_style'))
      Subchoice(
        kind: SubchoiceKind.fightingStyle,
        count: 1,
        chosen: [?draft.fightingStyle],
        options: feats(FeatCategory.fightingStyle),
      ),
    if (categories.contains('origin'))
      Subchoice(
        kind: SubchoiceKind.originFeat,
        count: 1,
        chosen: [?draft.originFeat],
        options: feats(
          FeatCategory.origin,
          taken: background == null ? null : '${background.originFeat}',
        ),
      ),
    for (final choice in open)
      Subchoice(
        kind: SubchoiceKind.effect,
        count: choice.count,
        chosen: draft.choices[choice.id] ?? const [],
        choiceId: choice.id,
        sourceId: choice.sourceId,
        options: [for (final o in choice.options) effectOption(choice, o)],
      ),
  ];
}
