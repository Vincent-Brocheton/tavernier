// Personnage tel qu'il est stocké (cahier §10.3 « grants », §11.2) : des
// sources et des choix, jamais de valeur calculée. Format = bloc `input`
// des fixtures [D1].
import 'package:freezed_annotation/freezed_annotation.dart';

part 'character_input.freezed.dart';
part 'character_input.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum ScoreMethod { pointBuy, standardArray, random }

@freezed
abstract class BaseScores with _$BaseScores {
  const factory BaseScores({
    required ScoreMethod method,

    /// Jets de la génération aléatoire, dans l'ordre obtenu.
    List<int>? rolls,
    @JsonKey(name: 'str') required int strength,
    @JsonKey(name: 'dex') required int dexterity,
    @JsonKey(name: 'con') required int constitution,
    @JsonKey(name: 'int') required int intelligence,
    @JsonKey(name: 'wis') required int wisdom,
    @JsonKey(name: 'cha') required int charisma,
  }) = _BaseScores;

  const BaseScores._();

  factory BaseScores.fromJson(Map<String, dynamic> json) =>
      _$BaseScoresFromJson(json);

  /// Valeur de base par code de caractéristique (`str`…`cha`).
  int of(String code) => switch (code) {
    'str' => strength,
    'dex' => dexterity,
    'con' => constitution,
    'int' => intelligence,
    'wis' => wisdom,
    'cha' => charisma,
    _ => throw ArgumentError.value(code, 'code'),
  };
}

@freezed
abstract class BackgroundChoice with _$BackgroundChoice {
  const factory BackgroundChoice({
    /// `2-1` ou `1-1-1`.
    required String distribution,
    required Map<String, int> bonuses,
    String? toolChoice,
  }) = _BackgroundChoice;

  factory BackgroundChoice.fromJson(Map<String, dynamic> json) =>
      _$BackgroundChoiceFromJson(json);
}

@freezed
abstract class ClassLevelInput with _$ClassLevelInput {
  const factory ClassLevelInput({
    required String classId,
    required int level,
    String? subclassId,

    /// Jet de PV par niveau ; `null` = valeur fixe (réglage de table).
    List<int>? hpRoll,
    @Default(<String>[]) List<String> skillChoices,
    @Default(<String>[]) List<String> expertise,
  }) = _ClassLevelInput;

  factory ClassLevelInput.fromJson(Map<String, dynamic> json) =>
      _$ClassLevelInputFromJson(json);
}

@freezed
abstract class FeatInput with _$FeatInput {
  const factory FeatInput({
    required String featId,

    /// `background`, `species`, `class` ou `class_level`.
    required String sourceType,
    required String sourceRef,
    Map<String, Object?>? choices,
  }) = _FeatInput;

  factory FeatInput.fromJson(Map<String, dynamic> json) =>
      _$FeatInputFromJson(json);
}

@freezed
abstract class WeaponMasteryInput with _$WeaponMasteryInput {
  const factory WeaponMasteryInput({
    required String weaponId,
    required int slotIndex,
  }) = _WeaponMasteryInput;

  factory WeaponMasteryInput.fromJson(Map<String, dynamic> json) =>
      _$WeaponMasteryInputFromJson(json);
}

@freezed
abstract class ItemInput with _$ItemInput {
  const factory ItemInput({
    required String itemId,
    required int quantity,
    @Default(false) bool equipped,
    @Default(false) bool attuned,
  }) = _ItemInput;

  factory ItemInput.fromJson(Map<String, dynamic> json) =>
      _$ItemInputFromJson(json);
}

@freezed
abstract class CharacterInput with _$CharacterInput {
  const factory CharacterInput({
    required String name,
    String? player,

    /// `pc` ou `npc_full`.
    required String kind,
    required String speciesId,
    @Default(<String, String>{}) Map<String, String> speciesChoices,
    required String backgroundId,
    required BaseScores baseScores,
    required BackgroundChoice backgroundChoice,
    required List<ClassLevelInput> classLevels,
    @Default(<FeatInput>[]) List<FeatInput> feats,

    /// Choix des effets `choice`, par identifiant de choix (design §2).
    @Default(<String, List<String>>{}) Map<String, List<String>> choices,
    @Default(<String>[]) List<String> languages,
    @Default(<WeaponMasteryInput>[]) List<WeaponMasteryInput> weaponMasteries,
    @Default(<ItemInput>[]) List<ItemInput> items,
    @Default(0) int xp,
  }) = _CharacterInput;

  factory CharacterInput.fromJson(Map<String, dynamic> json) =>
      _$CharacterInputFromJson(json);
}
