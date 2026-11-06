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
  cantrips,
  spellbook,
  preparedSpells,
  initiateList,
  initiateAbility,
  initiateCantrips,
  initiateSpell,
}

/// Don qui amène un Initié à la magie : l'Historique ou Polyvalent.
enum InitiatePlace { background, species }

/// Préfixe des sélections de sorts de classe dans `CreationDraft.choices`.
const classSpellsPrefix = 'spells-';
const cantripsKey = '${classSpellsPrefix}cantrips';
const spellbookKey = '${classSpellsPrefix}book';
const preparedKey = '${classSpellsPrefix}prepared';

/// Clé d'une sélection d'Initié à la magie dans `CreationDraft.choices`.
String initiateKey(InitiatePlace place, String field) =>
    'magic-initiate-${place.name}-$field';

/// Raison pour laquelle une option n'est pas disponible.
enum OptionBlock {
  /// Maîtrise déjà acquise : elle ne se prend pas deux fois.
  known,

  /// Expertise sur une compétence non maîtrisée.
  notProficient,

  /// Don non répétable déjà obtenu.
  notRepeatable,

  /// Liste de sorts déjà prise par le même don.
  sameList,
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
    this.title,
    this.listId,
    this.place,
  });

  final SubchoiceKind kind;
  final int count;
  final List<String> chosen;
  final List<SubchoiceOption> options;

  /// Clé de la sélection dans `CreationDraft.choices`.
  final String? choiceId;

  /// Entité qui ouvre le choix.
  final String? sourceId;

  /// Pour [SubchoiceKind.effect] : titre propre au choix.
  final String? title;

  /// Pour un Initié à la magie : liste de sorts, une fois connue.
  final String? listId;
  final InitiatePlace? place;

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
  final end = '. '
      .allMatches(line)
      .where((m) => !line.substring(0, m.start).endsWith('cf'))
      .firstOrNull;
  return end == null ? line : line.substring(0, end.start + 1);
}

/// Aptitudes de classe, traits d'espèce et dons d'origines : ce qui peut
/// ouvrir un choix.
List<String> _sources(CreationDraft draft, ActiveContent content) {
  final cls = content.entity(draft.classId ?? '')?.data;
  final species = content.entity(draft.speciesId ?? '')?.data;
  final background = content.entity(draft.backgroundId ?? '')?.data;
  return [
    if (cls is ClassData) ...levelOneFeatures(cls),
    if (species is SpeciesData) ...[for (final t in species.traits) '$t'],
    if (background is BackgroundData) '${background.originFeat}',
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

  final classSkills = {for (final skill in cls.skillChoices) '$skill'};
  final skillsTaken = {...fromBackground, ...pickedElsewhere('classSkills')};
  late final spells = sortedEntities(content, 'spell');
  List<SubchoiceOption> spellOptions(Iterable<ContentId> list, int level) {
    final ids = {for (final id in list) '$id'};
    return [
      for (final spell in spells)
        if (ids.contains('${spell.id}') &&
            (spell.data as SpellData).level == level)
          SubchoiceOption(id: '${spell.id}', label: spell.name),
    ];
  }

  Subchoice pick(
    SubchoiceKind kind,
    String key,
    int count,
    List<SubchoiceOption> options,
  ) => Subchoice(
    kind: kind,
    count: count,
    chosen: draft.choices[key] ?? const [],
    options: options,
    choiceId: key,
  );

  final cantrips =
      cantripsAtFirstLevel(cls) +
      [
        for (final choice in open)
          for (final option in choice.options)
            if (draft.choices[choice.id]?.contains(option.pick) ?? false)
              option.bonusCantrips,
      ].fold<int>(0, (sum, count) => sum + count);
  final book = spellbookSize(draft.classId!);
  final prepared = preparedAtFirstLevel(cls);
  final inBook = draft.choices[spellbookKey] ?? const <String>[];

  List<Subchoice> initiate(
    InitiatePlace place, {
    String? fixed,
    String? taken,
  }) {
    Subchoice section(
      SubchoiceKind kind,
      String field,
      int count,
      List<SubchoiceOption> options, {
      String? list,
    }) {
      final key = initiateKey(place, field);
      return Subchoice(
        kind: kind,
        count: count,
        chosen: draft.choices[key] ?? const [],
        options: options,
        choiceId: key,
        sourceId: magicInitiateFeat,
        listId: list,
        place: place,
      );
    }

    final list =
        fixed ?? draft.choices[initiateKey(place, 'list')]?.firstOrNull;
    final spellList =
        (content.entity(list ?? '')?.data as ClassData?)?.spellList;
    return [
      if (fixed == null)
        section(SubchoiceKind.initiateList, 'list', 1, [
          for (final id in magicInitiateLists)
            SubchoiceOption(
              id: id,
              label: content.entity(id)?.name ?? id,
              block: id == taken ? OptionBlock.sameList : null,
            ),
        ]),
      section(SubchoiceKind.initiateAbility, 'ability', 1, list: list, [
        for (final id in magicInitiateAbilities)
          SubchoiceOption(id: id, label: content.entity(id)?.name ?? id),
      ]),
      if (spellList != null) ...[
        section(
          SubchoiceKind.initiateCantrips,
          'cantrips',
          magicInitiateCantrips,
          list: list,
          spellOptions(spellList, 0),
        ),
        section(
          SubchoiceKind.initiateSpell,
          'spell',
          magicInitiateSpells,
          list: list,
          spellOptions(spellList, 1),
        ),
      ],
    ];
  }

  final backgroundList = switch (background?.originFeatChoices?['spell_list']) {
    final list? => 'srd:class:$list',
    null => null,
  };

  final mastery = masteryOptions(content, cls);
  final masteryWeapons = {for (final w in mastery.weapons) '${w.id}'};
  return [
    Subchoice(
      kind: SubchoiceKind.classSkills,
      count: cls.skillChoiceCount,
      chosen: draft.classSkills,
      options: [
        for (final skill in sortedEntities(content, 'skill'))
          if (classSkills.contains('${skill.id}'))
            SubchoiceOption(
              id: '${skill.id}',
              label: skill.name,
              block: skillsTaken.contains('${skill.id}')
                  ? OptionBlock.known
                  : null,
            ),
      ],
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
        title: choice.title,
        options: [for (final o in choice.options) effectOption(choice, o)],
      ),
    if (cantrips > 0)
      pick(
        SubchoiceKind.cantrips,
        cantripsKey,
        cantrips,
        spellOptions(cls.spellList, 0),
      ),
    if (book > 0)
      pick(
        SubchoiceKind.spellbook,
        spellbookKey,
        book,
        spellOptions(cls.spellList, 1),
      ),
    if (prepared > 0 && inBook.length == book)
      pick(SubchoiceKind.preparedSpells, preparedKey, prepared, [
        for (final option in spellOptions(cls.spellList, 1))
          if (book == 0 || inBook.contains(option.id)) option,
      ]),
    if ('${background?.originFeat}' == magicInitiateFeat)
      ...initiate(InitiatePlace.background, fixed: backgroundList),
    if (draft.originFeat == magicInitiateFeat)
      ...initiate(InitiatePlace.species, taken: backgroundList),
  ];
}
