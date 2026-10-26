// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'character_input.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BaseScores {

 ScoreMethod get method;/// Jets de la génération aléatoire, dans l'ordre obtenu.
 List<int>? get rolls;@JsonKey(name: 'str') int get strength;@JsonKey(name: 'dex') int get dexterity;@JsonKey(name: 'con') int get constitution;@JsonKey(name: 'int') int get intelligence;@JsonKey(name: 'wis') int get wisdom;@JsonKey(name: 'cha') int get charisma;
/// Create a copy of BaseScores
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BaseScoresCopyWith<BaseScores> get copyWith => _$BaseScoresCopyWithImpl<BaseScores>(this as BaseScores, _$identity);

  /// Serializes this BaseScores to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BaseScores;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BaseScores&&(identical(other.method, _this.method) || other.method == _this.method)&&const DeepCollectionEquality().equals(other.rolls, _this.rolls)&&(identical(other.strength, _this.strength) || other.strength == _this.strength)&&(identical(other.dexterity, _this.dexterity) || other.dexterity == _this.dexterity)&&(identical(other.constitution, _this.constitution) || other.constitution == _this.constitution)&&(identical(other.intelligence, _this.intelligence) || other.intelligence == _this.intelligence)&&(identical(other.wisdom, _this.wisdom) || other.wisdom == _this.wisdom)&&(identical(other.charisma, _this.charisma) || other.charisma == _this.charisma));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BaseScores;
  return Object.hash(runtimeType,_this.method,const DeepCollectionEquality().hash(_this.rolls),_this.strength,_this.dexterity,_this.constitution,_this.intelligence,_this.wisdom,_this.charisma);
}

@override
String toString() {
  final _this = this as BaseScores;
  return 'BaseScores(method: ${_this.method}, rolls: ${_this.rolls}, strength: ${_this.strength}, dexterity: ${_this.dexterity}, constitution: ${_this.constitution}, intelligence: ${_this.intelligence}, wisdom: ${_this.wisdom}, charisma: ${_this.charisma})';
}


}

/// @nodoc
abstract mixin class $BaseScoresCopyWith<$Res>  {
  factory $BaseScoresCopyWith(BaseScores value, $Res Function(BaseScores) _then) = _$BaseScoresCopyWithImpl;
@useResult
$Res call({
 ScoreMethod method, List<int>? rolls,@JsonKey(name: 'str') int strength,@JsonKey(name: 'dex') int dexterity,@JsonKey(name: 'con') int constitution,@JsonKey(name: 'int') int intelligence,@JsonKey(name: 'wis') int wisdom,@JsonKey(name: 'cha') int charisma
});




}
/// @nodoc
class _$BaseScoresCopyWithImpl<$Res>
    implements $BaseScoresCopyWith<$Res> {
  _$BaseScoresCopyWithImpl(this._self, this._then);

  final BaseScores _self;
  final $Res Function(BaseScores) _then;

/// Create a copy of BaseScores
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? method = null,Object? rolls = freezed,Object? strength = null,Object? dexterity = null,Object? constitution = null,Object? intelligence = null,Object? wisdom = null,Object? charisma = null,}) {
  return _then(BaseScores(
method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as ScoreMethod,rolls: freezed == rolls ? _self.rolls : rolls // ignore: cast_nullable_to_non_nullable
as List<int>?,strength: null == strength ? _self.strength : strength // ignore: cast_nullable_to_non_nullable
as int,dexterity: null == dexterity ? _self.dexterity : dexterity // ignore: cast_nullable_to_non_nullable
as int,constitution: null == constitution ? _self.constitution : constitution // ignore: cast_nullable_to_non_nullable
as int,intelligence: null == intelligence ? _self.intelligence : intelligence // ignore: cast_nullable_to_non_nullable
as int,wisdom: null == wisdom ? _self.wisdom : wisdom // ignore: cast_nullable_to_non_nullable
as int,charisma: null == charisma ? _self.charisma : charisma // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BaseScores].
extension BaseScoresPatterns on BaseScores {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BaseScores value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BaseScores() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BaseScores value)  $default,){
final _that = this;
switch (_that) {
case _BaseScores():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BaseScores value)?  $default,){
final _that = this;
switch (_that) {
case _BaseScores() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ScoreMethod method,  List<int>? rolls, @JsonKey(name: 'str')  int strength, @JsonKey(name: 'dex')  int dexterity, @JsonKey(name: 'con')  int constitution, @JsonKey(name: 'int')  int intelligence, @JsonKey(name: 'wis')  int wisdom, @JsonKey(name: 'cha')  int charisma)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BaseScores() when $default != null:
return $default(_that.method,_that.rolls,_that.strength,_that.dexterity,_that.constitution,_that.intelligence,_that.wisdom,_that.charisma);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ScoreMethod method,  List<int>? rolls, @JsonKey(name: 'str')  int strength, @JsonKey(name: 'dex')  int dexterity, @JsonKey(name: 'con')  int constitution, @JsonKey(name: 'int')  int intelligence, @JsonKey(name: 'wis')  int wisdom, @JsonKey(name: 'cha')  int charisma)  $default,) {final _that = this;
switch (_that) {
case _BaseScores():
return $default(_that.method,_that.rolls,_that.strength,_that.dexterity,_that.constitution,_that.intelligence,_that.wisdom,_that.charisma);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ScoreMethod method,  List<int>? rolls, @JsonKey(name: 'str')  int strength, @JsonKey(name: 'dex')  int dexterity, @JsonKey(name: 'con')  int constitution, @JsonKey(name: 'int')  int intelligence, @JsonKey(name: 'wis')  int wisdom, @JsonKey(name: 'cha')  int charisma)?  $default,) {final _that = this;
switch (_that) {
case _BaseScores() when $default != null:
return $default(_that.method,_that.rolls,_that.strength,_that.dexterity,_that.constitution,_that.intelligence,_that.wisdom,_that.charisma);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BaseScores extends BaseScores {
  const _BaseScores({required this.method,  List<int>? rolls, @JsonKey(name: 'str') required this.strength, @JsonKey(name: 'dex') required this.dexterity, @JsonKey(name: 'con') required this.constitution, @JsonKey(name: 'int') required this.intelligence, @JsonKey(name: 'wis') required this.wisdom, @JsonKey(name: 'cha') required this.charisma}): _rolls = rolls,super._();
  factory _BaseScores.fromJson(Map<String, dynamic> json) => _$BaseScoresFromJson(json);

@override final  ScoreMethod method;
/// Jets de la génération aléatoire, dans l'ordre obtenu.
 final  List<int>? _rolls;
/// Jets de la génération aléatoire, dans l'ordre obtenu.
@override List<int>? get rolls {
  final value = _rolls;
  if (value == null) return null;
  if (_rolls is EqualUnmodifiableListView) return _rolls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'str') final  int strength;
@override@JsonKey(name: 'dex') final  int dexterity;
@override@JsonKey(name: 'con') final  int constitution;
@override@JsonKey(name: 'int') final  int intelligence;
@override@JsonKey(name: 'wis') final  int wisdom;
@override@JsonKey(name: 'cha') final  int charisma;

/// Create a copy of BaseScores
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BaseScoresCopyWith<_BaseScores> get copyWith => __$BaseScoresCopyWithImpl<_BaseScores>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BaseScoresToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BaseScores&&(identical(other.method, method) || other.method == method)&&const DeepCollectionEquality().equals(other.rolls, _rolls)&&(identical(other.strength, strength) || other.strength == strength)&&(identical(other.dexterity, dexterity) || other.dexterity == dexterity)&&(identical(other.constitution, constitution) || other.constitution == constitution)&&(identical(other.intelligence, intelligence) || other.intelligence == intelligence)&&(identical(other.wisdom, wisdom) || other.wisdom == wisdom)&&(identical(other.charisma, charisma) || other.charisma == charisma));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,method,const DeepCollectionEquality().hash(_rolls),strength,dexterity,constitution,intelligence,wisdom,charisma);
}

@override
String toString() {
    return 'BaseScores(method: $method, rolls: $rolls, strength: $strength, dexterity: $dexterity, constitution: $constitution, intelligence: $intelligence, wisdom: $wisdom, charisma: $charisma)';
}


}

/// @nodoc
abstract mixin class _$BaseScoresCopyWith<$Res> implements $BaseScoresCopyWith<$Res> {
  factory _$BaseScoresCopyWith(_BaseScores value, $Res Function(_BaseScores) _then) = __$BaseScoresCopyWithImpl;
@override @useResult
$Res call({
 ScoreMethod method, List<int>? rolls,@JsonKey(name: 'str') int strength,@JsonKey(name: 'dex') int dexterity,@JsonKey(name: 'con') int constitution,@JsonKey(name: 'int') int intelligence,@JsonKey(name: 'wis') int wisdom,@JsonKey(name: 'cha') int charisma
});




}
/// @nodoc
class __$BaseScoresCopyWithImpl<$Res>
    implements _$BaseScoresCopyWith<$Res> {
  __$BaseScoresCopyWithImpl(this._self, this._then);

  final _BaseScores _self;
  final $Res Function(_BaseScores) _then;

/// Create a copy of BaseScores
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? method = null,Object? rolls = freezed,Object? strength = null,Object? dexterity = null,Object? constitution = null,Object? intelligence = null,Object? wisdom = null,Object? charisma = null,}) {
  return _then(_BaseScores(
method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as ScoreMethod,rolls: freezed == rolls ? _self._rolls : rolls // ignore: cast_nullable_to_non_nullable
as List<int>?,strength: null == strength ? _self.strength : strength // ignore: cast_nullable_to_non_nullable
as int,dexterity: null == dexterity ? _self.dexterity : dexterity // ignore: cast_nullable_to_non_nullable
as int,constitution: null == constitution ? _self.constitution : constitution // ignore: cast_nullable_to_non_nullable
as int,intelligence: null == intelligence ? _self.intelligence : intelligence // ignore: cast_nullable_to_non_nullable
as int,wisdom: null == wisdom ? _self.wisdom : wisdom // ignore: cast_nullable_to_non_nullable
as int,charisma: null == charisma ? _self.charisma : charisma // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BackgroundChoice {

/// `2-1` ou `1-1-1`.
 String get distribution; Map<String, int> get bonuses; String? get toolChoice;
/// Create a copy of BackgroundChoice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackgroundChoiceCopyWith<BackgroundChoice> get copyWith => _$BackgroundChoiceCopyWithImpl<BackgroundChoice>(this as BackgroundChoice, _$identity);

  /// Serializes this BackgroundChoice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BackgroundChoice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackgroundChoice&&(identical(other.distribution, _this.distribution) || other.distribution == _this.distribution)&&const DeepCollectionEquality().equals(other.bonuses, _this.bonuses)&&(identical(other.toolChoice, _this.toolChoice) || other.toolChoice == _this.toolChoice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BackgroundChoice;
  return Object.hash(runtimeType,_this.distribution,const DeepCollectionEquality().hash(_this.bonuses),_this.toolChoice);
}

@override
String toString() {
  final _this = this as BackgroundChoice;
  return 'BackgroundChoice(distribution: ${_this.distribution}, bonuses: ${_this.bonuses}, toolChoice: ${_this.toolChoice})';
}


}

/// @nodoc
abstract mixin class $BackgroundChoiceCopyWith<$Res>  {
  factory $BackgroundChoiceCopyWith(BackgroundChoice value, $Res Function(BackgroundChoice) _then) = _$BackgroundChoiceCopyWithImpl;
@useResult
$Res call({
 String distribution, Map<String, int> bonuses, String? toolChoice
});




}
/// @nodoc
class _$BackgroundChoiceCopyWithImpl<$Res>
    implements $BackgroundChoiceCopyWith<$Res> {
  _$BackgroundChoiceCopyWithImpl(this._self, this._then);

  final BackgroundChoice _self;
  final $Res Function(BackgroundChoice) _then;

/// Create a copy of BackgroundChoice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? distribution = null,Object? bonuses = null,Object? toolChoice = freezed,}) {
  return _then(BackgroundChoice(
distribution: null == distribution ? _self.distribution : distribution // ignore: cast_nullable_to_non_nullable
as String,bonuses: null == bonuses ? _self.bonuses : bonuses // ignore: cast_nullable_to_non_nullable
as Map<String, int>,toolChoice: freezed == toolChoice ? _self.toolChoice : toolChoice // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BackgroundChoice].
extension BackgroundChoicePatterns on BackgroundChoice {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackgroundChoice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackgroundChoice() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackgroundChoice value)  $default,){
final _that = this;
switch (_that) {
case _BackgroundChoice():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackgroundChoice value)?  $default,){
final _that = this;
switch (_that) {
case _BackgroundChoice() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String distribution,  Map<String, int> bonuses,  String? toolChoice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackgroundChoice() when $default != null:
return $default(_that.distribution,_that.bonuses,_that.toolChoice);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String distribution,  Map<String, int> bonuses,  String? toolChoice)  $default,) {final _that = this;
switch (_that) {
case _BackgroundChoice():
return $default(_that.distribution,_that.bonuses,_that.toolChoice);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String distribution,  Map<String, int> bonuses,  String? toolChoice)?  $default,) {final _that = this;
switch (_that) {
case _BackgroundChoice() when $default != null:
return $default(_that.distribution,_that.bonuses,_that.toolChoice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackgroundChoice implements BackgroundChoice {
  const _BackgroundChoice({required this.distribution, required  Map<String, int> bonuses, this.toolChoice}): _bonuses = bonuses;
  factory _BackgroundChoice.fromJson(Map<String, dynamic> json) => _$BackgroundChoiceFromJson(json);

/// `2-1` ou `1-1-1`.
@override final  String distribution;
 final  Map<String, int> _bonuses;
@override Map<String, int> get bonuses {
  if (_bonuses is EqualUnmodifiableMapView) return _bonuses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_bonuses);
}

@override final  String? toolChoice;

/// Create a copy of BackgroundChoice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackgroundChoiceCopyWith<_BackgroundChoice> get copyWith => __$BackgroundChoiceCopyWithImpl<_BackgroundChoice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackgroundChoiceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackgroundChoice&&(identical(other.distribution, distribution) || other.distribution == distribution)&&const DeepCollectionEquality().equals(other.bonuses, _bonuses)&&(identical(other.toolChoice, toolChoice) || other.toolChoice == toolChoice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,distribution,const DeepCollectionEquality().hash(_bonuses),toolChoice);
}

@override
String toString() {
    return 'BackgroundChoice(distribution: $distribution, bonuses: $bonuses, toolChoice: $toolChoice)';
}


}

/// @nodoc
abstract mixin class _$BackgroundChoiceCopyWith<$Res> implements $BackgroundChoiceCopyWith<$Res> {
  factory _$BackgroundChoiceCopyWith(_BackgroundChoice value, $Res Function(_BackgroundChoice) _then) = __$BackgroundChoiceCopyWithImpl;
@override @useResult
$Res call({
 String distribution, Map<String, int> bonuses, String? toolChoice
});




}
/// @nodoc
class __$BackgroundChoiceCopyWithImpl<$Res>
    implements _$BackgroundChoiceCopyWith<$Res> {
  __$BackgroundChoiceCopyWithImpl(this._self, this._then);

  final _BackgroundChoice _self;
  final $Res Function(_BackgroundChoice) _then;

/// Create a copy of BackgroundChoice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? distribution = null,Object? bonuses = null,Object? toolChoice = freezed,}) {
  return _then(_BackgroundChoice(
distribution: null == distribution ? _self.distribution : distribution // ignore: cast_nullable_to_non_nullable
as String,bonuses: null == bonuses ? _self._bonuses : bonuses // ignore: cast_nullable_to_non_nullable
as Map<String, int>,toolChoice: freezed == toolChoice ? _self.toolChoice : toolChoice // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ClassLevelInput {

 String get classId; int get level; String? get subclassId;/// Jet de PV par niveau ; `null` = valeur fixe (réglage de table).
 List<int>? get hpRoll; List<String> get skillChoices; List<String> get expertise;
/// Create a copy of ClassLevelInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassLevelInputCopyWith<ClassLevelInput> get copyWith => _$ClassLevelInputCopyWithImpl<ClassLevelInput>(this as ClassLevelInput, _$identity);

  /// Serializes this ClassLevelInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ClassLevelInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassLevelInput&&(identical(other.classId, _this.classId) || other.classId == _this.classId)&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.subclassId, _this.subclassId) || other.subclassId == _this.subclassId)&&const DeepCollectionEquality().equals(other.hpRoll, _this.hpRoll)&&const DeepCollectionEquality().equals(other.skillChoices, _this.skillChoices)&&const DeepCollectionEquality().equals(other.expertise, _this.expertise));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ClassLevelInput;
  return Object.hash(runtimeType,_this.classId,_this.level,_this.subclassId,const DeepCollectionEquality().hash(_this.hpRoll),const DeepCollectionEquality().hash(_this.skillChoices),const DeepCollectionEquality().hash(_this.expertise));
}

@override
String toString() {
  final _this = this as ClassLevelInput;
  return 'ClassLevelInput(classId: ${_this.classId}, level: ${_this.level}, subclassId: ${_this.subclassId}, hpRoll: ${_this.hpRoll}, skillChoices: ${_this.skillChoices}, expertise: ${_this.expertise})';
}


}

/// @nodoc
abstract mixin class $ClassLevelInputCopyWith<$Res>  {
  factory $ClassLevelInputCopyWith(ClassLevelInput value, $Res Function(ClassLevelInput) _then) = _$ClassLevelInputCopyWithImpl;
@useResult
$Res call({
 String classId, int level, String? subclassId, List<int>? hpRoll, List<String> skillChoices, List<String> expertise
});




}
/// @nodoc
class _$ClassLevelInputCopyWithImpl<$Res>
    implements $ClassLevelInputCopyWith<$Res> {
  _$ClassLevelInputCopyWithImpl(this._self, this._then);

  final ClassLevelInput _self;
  final $Res Function(ClassLevelInput) _then;

/// Create a copy of ClassLevelInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? classId = null,Object? level = null,Object? subclassId = freezed,Object? hpRoll = freezed,Object? skillChoices = null,Object? expertise = null,}) {
  return _then(ClassLevelInput(
classId: null == classId ? _self.classId : classId // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,subclassId: freezed == subclassId ? _self.subclassId : subclassId // ignore: cast_nullable_to_non_nullable
as String?,hpRoll: freezed == hpRoll ? _self.hpRoll : hpRoll // ignore: cast_nullable_to_non_nullable
as List<int>?,skillChoices: null == skillChoices ? _self.skillChoices : skillChoices // ignore: cast_nullable_to_non_nullable
as List<String>,expertise: null == expertise ? _self.expertise : expertise // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ClassLevelInput].
extension ClassLevelInputPatterns on ClassLevelInput {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClassLevelInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClassLevelInput() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClassLevelInput value)  $default,){
final _that = this;
switch (_that) {
case _ClassLevelInput():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClassLevelInput value)?  $default,){
final _that = this;
switch (_that) {
case _ClassLevelInput() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String classId,  int level,  String? subclassId,  List<int>? hpRoll,  List<String> skillChoices,  List<String> expertise)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClassLevelInput() when $default != null:
return $default(_that.classId,_that.level,_that.subclassId,_that.hpRoll,_that.skillChoices,_that.expertise);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String classId,  int level,  String? subclassId,  List<int>? hpRoll,  List<String> skillChoices,  List<String> expertise)  $default,) {final _that = this;
switch (_that) {
case _ClassLevelInput():
return $default(_that.classId,_that.level,_that.subclassId,_that.hpRoll,_that.skillChoices,_that.expertise);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String classId,  int level,  String? subclassId,  List<int>? hpRoll,  List<String> skillChoices,  List<String> expertise)?  $default,) {final _that = this;
switch (_that) {
case _ClassLevelInput() when $default != null:
return $default(_that.classId,_that.level,_that.subclassId,_that.hpRoll,_that.skillChoices,_that.expertise);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClassLevelInput implements ClassLevelInput {
  const _ClassLevelInput({required this.classId, required this.level, this.subclassId,  List<int>? hpRoll,  List<String> skillChoices = const <String>[],  List<String> expertise = const <String>[]}): _hpRoll = hpRoll,_skillChoices = skillChoices,_expertise = expertise;
  factory _ClassLevelInput.fromJson(Map<String, dynamic> json) => _$ClassLevelInputFromJson(json);

@override final  String classId;
@override final  int level;
@override final  String? subclassId;
/// Jet de PV par niveau ; `null` = valeur fixe (réglage de table).
 final  List<int>? _hpRoll;
/// Jet de PV par niveau ; `null` = valeur fixe (réglage de table).
@override List<int>? get hpRoll {
  final value = _hpRoll;
  if (value == null) return null;
  if (_hpRoll is EqualUnmodifiableListView) return _hpRoll;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String> _skillChoices;
@override@JsonKey() List<String> get skillChoices {
  if (_skillChoices is EqualUnmodifiableListView) return _skillChoices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skillChoices);
}

 final  List<String> _expertise;
@override@JsonKey() List<String> get expertise {
  if (_expertise is EqualUnmodifiableListView) return _expertise;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_expertise);
}


/// Create a copy of ClassLevelInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassLevelInputCopyWith<_ClassLevelInput> get copyWith => __$ClassLevelInputCopyWithImpl<_ClassLevelInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClassLevelInputToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassLevelInput&&(identical(other.classId, classId) || other.classId == classId)&&(identical(other.level, level) || other.level == level)&&(identical(other.subclassId, subclassId) || other.subclassId == subclassId)&&const DeepCollectionEquality().equals(other.hpRoll, _hpRoll)&&const DeepCollectionEquality().equals(other.skillChoices, _skillChoices)&&const DeepCollectionEquality().equals(other.expertise, _expertise));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,classId,level,subclassId,const DeepCollectionEquality().hash(_hpRoll),const DeepCollectionEquality().hash(_skillChoices),const DeepCollectionEquality().hash(_expertise));
}

@override
String toString() {
    return 'ClassLevelInput(classId: $classId, level: $level, subclassId: $subclassId, hpRoll: $hpRoll, skillChoices: $skillChoices, expertise: $expertise)';
}


}

/// @nodoc
abstract mixin class _$ClassLevelInputCopyWith<$Res> implements $ClassLevelInputCopyWith<$Res> {
  factory _$ClassLevelInputCopyWith(_ClassLevelInput value, $Res Function(_ClassLevelInput) _then) = __$ClassLevelInputCopyWithImpl;
@override @useResult
$Res call({
 String classId, int level, String? subclassId, List<int>? hpRoll, List<String> skillChoices, List<String> expertise
});




}
/// @nodoc
class __$ClassLevelInputCopyWithImpl<$Res>
    implements _$ClassLevelInputCopyWith<$Res> {
  __$ClassLevelInputCopyWithImpl(this._self, this._then);

  final _ClassLevelInput _self;
  final $Res Function(_ClassLevelInput) _then;

/// Create a copy of ClassLevelInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? classId = null,Object? level = null,Object? subclassId = freezed,Object? hpRoll = freezed,Object? skillChoices = null,Object? expertise = null,}) {
  return _then(_ClassLevelInput(
classId: null == classId ? _self.classId : classId // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,subclassId: freezed == subclassId ? _self.subclassId : subclassId // ignore: cast_nullable_to_non_nullable
as String?,hpRoll: freezed == hpRoll ? _self._hpRoll : hpRoll // ignore: cast_nullable_to_non_nullable
as List<int>?,skillChoices: null == skillChoices ? _self._skillChoices : skillChoices // ignore: cast_nullable_to_non_nullable
as List<String>,expertise: null == expertise ? _self._expertise : expertise // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$FeatInput {

 String get featId;/// `background`, `species`, `class` ou `class_level`.
 String get sourceType; String get sourceRef; Map<String, Object?>? get choices;
/// Create a copy of FeatInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeatInputCopyWith<FeatInput> get copyWith => _$FeatInputCopyWithImpl<FeatInput>(this as FeatInput, _$identity);

  /// Serializes this FeatInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FeatInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeatInput&&(identical(other.featId, _this.featId) || other.featId == _this.featId)&&(identical(other.sourceType, _this.sourceType) || other.sourceType == _this.sourceType)&&(identical(other.sourceRef, _this.sourceRef) || other.sourceRef == _this.sourceRef)&&const DeepCollectionEquality().equals(other.choices, _this.choices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FeatInput;
  return Object.hash(runtimeType,_this.featId,_this.sourceType,_this.sourceRef,const DeepCollectionEquality().hash(_this.choices));
}

@override
String toString() {
  final _this = this as FeatInput;
  return 'FeatInput(featId: ${_this.featId}, sourceType: ${_this.sourceType}, sourceRef: ${_this.sourceRef}, choices: ${_this.choices})';
}


}

/// @nodoc
abstract mixin class $FeatInputCopyWith<$Res>  {
  factory $FeatInputCopyWith(FeatInput value, $Res Function(FeatInput) _then) = _$FeatInputCopyWithImpl;
@useResult
$Res call({
 String featId, String sourceType, String sourceRef, Map<String, Object?>? choices
});




}
/// @nodoc
class _$FeatInputCopyWithImpl<$Res>
    implements $FeatInputCopyWith<$Res> {
  _$FeatInputCopyWithImpl(this._self, this._then);

  final FeatInput _self;
  final $Res Function(FeatInput) _then;

/// Create a copy of FeatInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? featId = null,Object? sourceType = null,Object? sourceRef = null,Object? choices = freezed,}) {
  return _then(FeatInput(
featId: null == featId ? _self.featId : featId // ignore: cast_nullable_to_non_nullable
as String,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as String,sourceRef: null == sourceRef ? _self.sourceRef : sourceRef // ignore: cast_nullable_to_non_nullable
as String,choices: freezed == choices ? _self.choices : choices // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,
  ));
}

}


/// Adds pattern-matching-related methods to [FeatInput].
extension FeatInputPatterns on FeatInput {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeatInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeatInput() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeatInput value)  $default,){
final _that = this;
switch (_that) {
case _FeatInput():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeatInput value)?  $default,){
final _that = this;
switch (_that) {
case _FeatInput() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String featId,  String sourceType,  String sourceRef,  Map<String, Object?>? choices)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeatInput() when $default != null:
return $default(_that.featId,_that.sourceType,_that.sourceRef,_that.choices);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String featId,  String sourceType,  String sourceRef,  Map<String, Object?>? choices)  $default,) {final _that = this;
switch (_that) {
case _FeatInput():
return $default(_that.featId,_that.sourceType,_that.sourceRef,_that.choices);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String featId,  String sourceType,  String sourceRef,  Map<String, Object?>? choices)?  $default,) {final _that = this;
switch (_that) {
case _FeatInput() when $default != null:
return $default(_that.featId,_that.sourceType,_that.sourceRef,_that.choices);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeatInput implements FeatInput {
  const _FeatInput({required this.featId, required this.sourceType, required this.sourceRef,  Map<String, Object?>? choices}): _choices = choices;
  factory _FeatInput.fromJson(Map<String, dynamic> json) => _$FeatInputFromJson(json);

@override final  String featId;
/// `background`, `species`, `class` ou `class_level`.
@override final  String sourceType;
@override final  String sourceRef;
 final  Map<String, Object?>? _choices;
@override Map<String, Object?>? get choices {
  final value = _choices;
  if (value == null) return null;
  if (_choices is EqualUnmodifiableMapView) return _choices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of FeatInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeatInputCopyWith<_FeatInput> get copyWith => __$FeatInputCopyWithImpl<_FeatInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeatInputToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeatInput&&(identical(other.featId, featId) || other.featId == featId)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.sourceRef, sourceRef) || other.sourceRef == sourceRef)&&const DeepCollectionEquality().equals(other.choices, _choices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,featId,sourceType,sourceRef,const DeepCollectionEquality().hash(_choices));
}

@override
String toString() {
    return 'FeatInput(featId: $featId, sourceType: $sourceType, sourceRef: $sourceRef, choices: $choices)';
}


}

/// @nodoc
abstract mixin class _$FeatInputCopyWith<$Res> implements $FeatInputCopyWith<$Res> {
  factory _$FeatInputCopyWith(_FeatInput value, $Res Function(_FeatInput) _then) = __$FeatInputCopyWithImpl;
@override @useResult
$Res call({
 String featId, String sourceType, String sourceRef, Map<String, Object?>? choices
});




}
/// @nodoc
class __$FeatInputCopyWithImpl<$Res>
    implements _$FeatInputCopyWith<$Res> {
  __$FeatInputCopyWithImpl(this._self, this._then);

  final _FeatInput _self;
  final $Res Function(_FeatInput) _then;

/// Create a copy of FeatInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? featId = null,Object? sourceType = null,Object? sourceRef = null,Object? choices = freezed,}) {
  return _then(_FeatInput(
featId: null == featId ? _self.featId : featId // ignore: cast_nullable_to_non_nullable
as String,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as String,sourceRef: null == sourceRef ? _self.sourceRef : sourceRef // ignore: cast_nullable_to_non_nullable
as String,choices: freezed == choices ? _self._choices : choices // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,
  ));
}


}


/// @nodoc
mixin _$WeaponMasteryInput {

 String get weaponId; int get slotIndex;
/// Create a copy of WeaponMasteryInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeaponMasteryInputCopyWith<WeaponMasteryInput> get copyWith => _$WeaponMasteryInputCopyWithImpl<WeaponMasteryInput>(this as WeaponMasteryInput, _$identity);

  /// Serializes this WeaponMasteryInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WeaponMasteryInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeaponMasteryInput&&(identical(other.weaponId, _this.weaponId) || other.weaponId == _this.weaponId)&&(identical(other.slotIndex, _this.slotIndex) || other.slotIndex == _this.slotIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WeaponMasteryInput;
  return Object.hash(runtimeType,_this.weaponId,_this.slotIndex);
}

@override
String toString() {
  final _this = this as WeaponMasteryInput;
  return 'WeaponMasteryInput(weaponId: ${_this.weaponId}, slotIndex: ${_this.slotIndex})';
}


}

/// @nodoc
abstract mixin class $WeaponMasteryInputCopyWith<$Res>  {
  factory $WeaponMasteryInputCopyWith(WeaponMasteryInput value, $Res Function(WeaponMasteryInput) _then) = _$WeaponMasteryInputCopyWithImpl;
@useResult
$Res call({
 String weaponId, int slotIndex
});




}
/// @nodoc
class _$WeaponMasteryInputCopyWithImpl<$Res>
    implements $WeaponMasteryInputCopyWith<$Res> {
  _$WeaponMasteryInputCopyWithImpl(this._self, this._then);

  final WeaponMasteryInput _self;
  final $Res Function(WeaponMasteryInput) _then;

/// Create a copy of WeaponMasteryInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weaponId = null,Object? slotIndex = null,}) {
  return _then(WeaponMasteryInput(
weaponId: null == weaponId ? _self.weaponId : weaponId // ignore: cast_nullable_to_non_nullable
as String,slotIndex: null == slotIndex ? _self.slotIndex : slotIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WeaponMasteryInput].
extension WeaponMasteryInputPatterns on WeaponMasteryInput {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeaponMasteryInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeaponMasteryInput() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeaponMasteryInput value)  $default,){
final _that = this;
switch (_that) {
case _WeaponMasteryInput():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeaponMasteryInput value)?  $default,){
final _that = this;
switch (_that) {
case _WeaponMasteryInput() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String weaponId,  int slotIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeaponMasteryInput() when $default != null:
return $default(_that.weaponId,_that.slotIndex);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String weaponId,  int slotIndex)  $default,) {final _that = this;
switch (_that) {
case _WeaponMasteryInput():
return $default(_that.weaponId,_that.slotIndex);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String weaponId,  int slotIndex)?  $default,) {final _that = this;
switch (_that) {
case _WeaponMasteryInput() when $default != null:
return $default(_that.weaponId,_that.slotIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeaponMasteryInput implements WeaponMasteryInput {
  const _WeaponMasteryInput({required this.weaponId, required this.slotIndex});
  factory _WeaponMasteryInput.fromJson(Map<String, dynamic> json) => _$WeaponMasteryInputFromJson(json);

@override final  String weaponId;
@override final  int slotIndex;

/// Create a copy of WeaponMasteryInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeaponMasteryInputCopyWith<_WeaponMasteryInput> get copyWith => __$WeaponMasteryInputCopyWithImpl<_WeaponMasteryInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeaponMasteryInputToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeaponMasteryInput&&(identical(other.weaponId, weaponId) || other.weaponId == weaponId)&&(identical(other.slotIndex, slotIndex) || other.slotIndex == slotIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,weaponId,slotIndex);
}

@override
String toString() {
    return 'WeaponMasteryInput(weaponId: $weaponId, slotIndex: $slotIndex)';
}


}

/// @nodoc
abstract mixin class _$WeaponMasteryInputCopyWith<$Res> implements $WeaponMasteryInputCopyWith<$Res> {
  factory _$WeaponMasteryInputCopyWith(_WeaponMasteryInput value, $Res Function(_WeaponMasteryInput) _then) = __$WeaponMasteryInputCopyWithImpl;
@override @useResult
$Res call({
 String weaponId, int slotIndex
});




}
/// @nodoc
class __$WeaponMasteryInputCopyWithImpl<$Res>
    implements _$WeaponMasteryInputCopyWith<$Res> {
  __$WeaponMasteryInputCopyWithImpl(this._self, this._then);

  final _WeaponMasteryInput _self;
  final $Res Function(_WeaponMasteryInput) _then;

/// Create a copy of WeaponMasteryInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weaponId = null,Object? slotIndex = null,}) {
  return _then(_WeaponMasteryInput(
weaponId: null == weaponId ? _self.weaponId : weaponId // ignore: cast_nullable_to_non_nullable
as String,slotIndex: null == slotIndex ? _self.slotIndex : slotIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ItemInput {

 String get itemId; int get quantity; bool get equipped; bool get attuned;
/// Create a copy of ItemInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemInputCopyWith<ItemInput> get copyWith => _$ItemInputCopyWithImpl<ItemInput>(this as ItemInput, _$identity);

  /// Serializes this ItemInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ItemInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemInput&&(identical(other.itemId, _this.itemId) || other.itemId == _this.itemId)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.equipped, _this.equipped) || other.equipped == _this.equipped)&&(identical(other.attuned, _this.attuned) || other.attuned == _this.attuned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ItemInput;
  return Object.hash(runtimeType,_this.itemId,_this.quantity,_this.equipped,_this.attuned);
}

@override
String toString() {
  final _this = this as ItemInput;
  return 'ItemInput(itemId: ${_this.itemId}, quantity: ${_this.quantity}, equipped: ${_this.equipped}, attuned: ${_this.attuned})';
}


}

/// @nodoc
abstract mixin class $ItemInputCopyWith<$Res>  {
  factory $ItemInputCopyWith(ItemInput value, $Res Function(ItemInput) _then) = _$ItemInputCopyWithImpl;
@useResult
$Res call({
 String itemId, int quantity, bool equipped, bool attuned
});




}
/// @nodoc
class _$ItemInputCopyWithImpl<$Res>
    implements $ItemInputCopyWith<$Res> {
  _$ItemInputCopyWithImpl(this._self, this._then);

  final ItemInput _self;
  final $Res Function(ItemInput) _then;

/// Create a copy of ItemInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? quantity = null,Object? equipped = null,Object? attuned = null,}) {
  return _then(ItemInput(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,equipped: null == equipped ? _self.equipped : equipped // ignore: cast_nullable_to_non_nullable
as bool,attuned: null == attuned ? _self.attuned : attuned // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemInput].
extension ItemInputPatterns on ItemInput {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemInput() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemInput value)  $default,){
final _that = this;
switch (_that) {
case _ItemInput():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemInput value)?  $default,){
final _that = this;
switch (_that) {
case _ItemInput() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemId,  int quantity,  bool equipped,  bool attuned)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemInput() when $default != null:
return $default(_that.itemId,_that.quantity,_that.equipped,_that.attuned);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemId,  int quantity,  bool equipped,  bool attuned)  $default,) {final _that = this;
switch (_that) {
case _ItemInput():
return $default(_that.itemId,_that.quantity,_that.equipped,_that.attuned);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemId,  int quantity,  bool equipped,  bool attuned)?  $default,) {final _that = this;
switch (_that) {
case _ItemInput() when $default != null:
return $default(_that.itemId,_that.quantity,_that.equipped,_that.attuned);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemInput implements ItemInput {
  const _ItemInput({required this.itemId, required this.quantity, this.equipped = false, this.attuned = false});
  factory _ItemInput.fromJson(Map<String, dynamic> json) => _$ItemInputFromJson(json);

@override final  String itemId;
@override final  int quantity;
@override@JsonKey() final  bool equipped;
@override@JsonKey() final  bool attuned;

/// Create a copy of ItemInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemInputCopyWith<_ItemInput> get copyWith => __$ItemInputCopyWithImpl<_ItemInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemInputToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemInput&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.equipped, equipped) || other.equipped == equipped)&&(identical(other.attuned, attuned) || other.attuned == attuned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,itemId,quantity,equipped,attuned);
}

@override
String toString() {
    return 'ItemInput(itemId: $itemId, quantity: $quantity, equipped: $equipped, attuned: $attuned)';
}


}

/// @nodoc
abstract mixin class _$ItemInputCopyWith<$Res> implements $ItemInputCopyWith<$Res> {
  factory _$ItemInputCopyWith(_ItemInput value, $Res Function(_ItemInput) _then) = __$ItemInputCopyWithImpl;
@override @useResult
$Res call({
 String itemId, int quantity, bool equipped, bool attuned
});




}
/// @nodoc
class __$ItemInputCopyWithImpl<$Res>
    implements _$ItemInputCopyWith<$Res> {
  __$ItemInputCopyWithImpl(this._self, this._then);

  final _ItemInput _self;
  final $Res Function(_ItemInput) _then;

/// Create a copy of ItemInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? quantity = null,Object? equipped = null,Object? attuned = null,}) {
  return _then(_ItemInput(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,equipped: null == equipped ? _self.equipped : equipped // ignore: cast_nullable_to_non_nullable
as bool,attuned: null == attuned ? _self.attuned : attuned // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$CharacterInput {

 String get name; String? get player;/// `pc` ou `npc_full`.
 String get kind; String get speciesId; Map<String, String> get speciesChoices; String get backgroundId; BaseScores get baseScores; BackgroundChoice get backgroundChoice; List<ClassLevelInput> get classLevels; List<FeatInput> get feats;/// Choix des effets `choice`, par identifiant de choix (design §2).
 Map<String, List<String>> get choices; List<String> get languages; List<WeaponMasteryInput> get weaponMasteries; List<ItemInput> get items; int get xp;
/// Create a copy of CharacterInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CharacterInputCopyWith<CharacterInput> get copyWith => _$CharacterInputCopyWithImpl<CharacterInput>(this as CharacterInput, _$identity);

  /// Serializes this CharacterInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CharacterInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CharacterInput&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.player, _this.player) || other.player == _this.player)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.speciesId, _this.speciesId) || other.speciesId == _this.speciesId)&&const DeepCollectionEquality().equals(other.speciesChoices, _this.speciesChoices)&&(identical(other.backgroundId, _this.backgroundId) || other.backgroundId == _this.backgroundId)&&(identical(other.baseScores, _this.baseScores) || other.baseScores == _this.baseScores)&&(identical(other.backgroundChoice, _this.backgroundChoice) || other.backgroundChoice == _this.backgroundChoice)&&const DeepCollectionEquality().equals(other.classLevels, _this.classLevels)&&const DeepCollectionEquality().equals(other.feats, _this.feats)&&const DeepCollectionEquality().equals(other.choices, _this.choices)&&const DeepCollectionEquality().equals(other.languages, _this.languages)&&const DeepCollectionEquality().equals(other.weaponMasteries, _this.weaponMasteries)&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.xp, _this.xp) || other.xp == _this.xp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CharacterInput;
  return Object.hash(runtimeType,_this.name,_this.player,_this.kind,_this.speciesId,const DeepCollectionEquality().hash(_this.speciesChoices),_this.backgroundId,_this.baseScores,_this.backgroundChoice,const DeepCollectionEquality().hash(_this.classLevels),const DeepCollectionEquality().hash(_this.feats),const DeepCollectionEquality().hash(_this.choices),const DeepCollectionEquality().hash(_this.languages),const DeepCollectionEquality().hash(_this.weaponMasteries),const DeepCollectionEquality().hash(_this.items),_this.xp);
}

@override
String toString() {
  final _this = this as CharacterInput;
  return 'CharacterInput(name: ${_this.name}, player: ${_this.player}, kind: ${_this.kind}, speciesId: ${_this.speciesId}, speciesChoices: ${_this.speciesChoices}, backgroundId: ${_this.backgroundId}, baseScores: ${_this.baseScores}, backgroundChoice: ${_this.backgroundChoice}, classLevels: ${_this.classLevels}, feats: ${_this.feats}, choices: ${_this.choices}, languages: ${_this.languages}, weaponMasteries: ${_this.weaponMasteries}, items: ${_this.items}, xp: ${_this.xp})';
}


}

/// @nodoc
abstract mixin class $CharacterInputCopyWith<$Res>  {
  factory $CharacterInputCopyWith(CharacterInput value, $Res Function(CharacterInput) _then) = _$CharacterInputCopyWithImpl;
@useResult
$Res call({
 String name, String? player, String kind, String speciesId, Map<String, String> speciesChoices, String backgroundId, BaseScores baseScores, BackgroundChoice backgroundChoice, List<ClassLevelInput> classLevels, List<FeatInput> feats, Map<String, List<String>> choices, List<String> languages, List<WeaponMasteryInput> weaponMasteries, List<ItemInput> items, int xp
});


$BaseScoresCopyWith<$Res> get baseScores;$BackgroundChoiceCopyWith<$Res> get backgroundChoice;

}
/// @nodoc
class _$CharacterInputCopyWithImpl<$Res>
    implements $CharacterInputCopyWith<$Res> {
  _$CharacterInputCopyWithImpl(this._self, this._then);

  final CharacterInput _self;
  final $Res Function(CharacterInput) _then;

/// Create a copy of CharacterInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? player = freezed,Object? kind = null,Object? speciesId = null,Object? speciesChoices = null,Object? backgroundId = null,Object? baseScores = null,Object? backgroundChoice = null,Object? classLevels = null,Object? feats = null,Object? choices = null,Object? languages = null,Object? weaponMasteries = null,Object? items = null,Object? xp = null,}) {
  return _then(CharacterInput(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,player: freezed == player ? _self.player : player // ignore: cast_nullable_to_non_nullable
as String?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,speciesId: null == speciesId ? _self.speciesId : speciesId // ignore: cast_nullable_to_non_nullable
as String,speciesChoices: null == speciesChoices ? _self.speciesChoices : speciesChoices // ignore: cast_nullable_to_non_nullable
as Map<String, String>,backgroundId: null == backgroundId ? _self.backgroundId : backgroundId // ignore: cast_nullable_to_non_nullable
as String,baseScores: null == baseScores ? _self.baseScores : baseScores // ignore: cast_nullable_to_non_nullable
as BaseScores,backgroundChoice: null == backgroundChoice ? _self.backgroundChoice : backgroundChoice // ignore: cast_nullable_to_non_nullable
as BackgroundChoice,classLevels: null == classLevels ? _self.classLevels : classLevels // ignore: cast_nullable_to_non_nullable
as List<ClassLevelInput>,feats: null == feats ? _self.feats : feats // ignore: cast_nullable_to_non_nullable
as List<FeatInput>,choices: null == choices ? _self.choices : choices // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,weaponMasteries: null == weaponMasteries ? _self.weaponMasteries : weaponMasteries // ignore: cast_nullable_to_non_nullable
as List<WeaponMasteryInput>,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ItemInput>,xp: null == xp ? _self.xp : xp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of CharacterInput
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BaseScoresCopyWith<$Res> get baseScores {
  
  return $BaseScoresCopyWith<$Res>(_self.baseScores, (value) {
    return _then(_self.copyWith(baseScores: value));
  });
}/// Create a copy of CharacterInput
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BackgroundChoiceCopyWith<$Res> get backgroundChoice {
  
  return $BackgroundChoiceCopyWith<$Res>(_self.backgroundChoice, (value) {
    return _then(_self.copyWith(backgroundChoice: value));
  });
}
}


/// Adds pattern-matching-related methods to [CharacterInput].
extension CharacterInputPatterns on CharacterInput {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CharacterInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CharacterInput() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CharacterInput value)  $default,){
final _that = this;
switch (_that) {
case _CharacterInput():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CharacterInput value)?  $default,){
final _that = this;
switch (_that) {
case _CharacterInput() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? player,  String kind,  String speciesId,  Map<String, String> speciesChoices,  String backgroundId,  BaseScores baseScores,  BackgroundChoice backgroundChoice,  List<ClassLevelInput> classLevels,  List<FeatInput> feats,  Map<String, List<String>> choices,  List<String> languages,  List<WeaponMasteryInput> weaponMasteries,  List<ItemInput> items,  int xp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CharacterInput() when $default != null:
return $default(_that.name,_that.player,_that.kind,_that.speciesId,_that.speciesChoices,_that.backgroundId,_that.baseScores,_that.backgroundChoice,_that.classLevels,_that.feats,_that.choices,_that.languages,_that.weaponMasteries,_that.items,_that.xp);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? player,  String kind,  String speciesId,  Map<String, String> speciesChoices,  String backgroundId,  BaseScores baseScores,  BackgroundChoice backgroundChoice,  List<ClassLevelInput> classLevels,  List<FeatInput> feats,  Map<String, List<String>> choices,  List<String> languages,  List<WeaponMasteryInput> weaponMasteries,  List<ItemInput> items,  int xp)  $default,) {final _that = this;
switch (_that) {
case _CharacterInput():
return $default(_that.name,_that.player,_that.kind,_that.speciesId,_that.speciesChoices,_that.backgroundId,_that.baseScores,_that.backgroundChoice,_that.classLevels,_that.feats,_that.choices,_that.languages,_that.weaponMasteries,_that.items,_that.xp);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? player,  String kind,  String speciesId,  Map<String, String> speciesChoices,  String backgroundId,  BaseScores baseScores,  BackgroundChoice backgroundChoice,  List<ClassLevelInput> classLevels,  List<FeatInput> feats,  Map<String, List<String>> choices,  List<String> languages,  List<WeaponMasteryInput> weaponMasteries,  List<ItemInput> items,  int xp)?  $default,) {final _that = this;
switch (_that) {
case _CharacterInput() when $default != null:
return $default(_that.name,_that.player,_that.kind,_that.speciesId,_that.speciesChoices,_that.backgroundId,_that.baseScores,_that.backgroundChoice,_that.classLevels,_that.feats,_that.choices,_that.languages,_that.weaponMasteries,_that.items,_that.xp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CharacterInput implements CharacterInput {
  const _CharacterInput({required this.name, this.player, required this.kind, required this.speciesId,  Map<String, String> speciesChoices = const <String, String>{}, required this.backgroundId, required this.baseScores, required this.backgroundChoice, required  List<ClassLevelInput> classLevels,  List<FeatInput> feats = const <FeatInput>[],  Map<String, List<String>> choices = const <String, List<String>>{},  List<String> languages = const <String>[],  List<WeaponMasteryInput> weaponMasteries = const <WeaponMasteryInput>[],  List<ItemInput> items = const <ItemInput>[], this.xp = 0}): _speciesChoices = speciesChoices,_classLevels = classLevels,_feats = feats,_choices = choices,_languages = languages,_weaponMasteries = weaponMasteries,_items = items;
  factory _CharacterInput.fromJson(Map<String, dynamic> json) => _$CharacterInputFromJson(json);

@override final  String name;
@override final  String? player;
/// `pc` ou `npc_full`.
@override final  String kind;
@override final  String speciesId;
 final  Map<String, String> _speciesChoices;
@override@JsonKey() Map<String, String> get speciesChoices {
  if (_speciesChoices is EqualUnmodifiableMapView) return _speciesChoices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_speciesChoices);
}

@override final  String backgroundId;
@override final  BaseScores baseScores;
@override final  BackgroundChoice backgroundChoice;
 final  List<ClassLevelInput> _classLevels;
@override List<ClassLevelInput> get classLevels {
  if (_classLevels is EqualUnmodifiableListView) return _classLevels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_classLevels);
}

 final  List<FeatInput> _feats;
@override@JsonKey() List<FeatInput> get feats {
  if (_feats is EqualUnmodifiableListView) return _feats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_feats);
}

/// Choix des effets `choice`, par identifiant de choix (design §2).
 final  Map<String, List<String>> _choices;
/// Choix des effets `choice`, par identifiant de choix (design §2).
@override@JsonKey() Map<String, List<String>> get choices {
  if (_choices is EqualUnmodifiableMapView) return _choices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_choices);
}

 final  List<String> _languages;
@override@JsonKey() List<String> get languages {
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_languages);
}

 final  List<WeaponMasteryInput> _weaponMasteries;
@override@JsonKey() List<WeaponMasteryInput> get weaponMasteries {
  if (_weaponMasteries is EqualUnmodifiableListView) return _weaponMasteries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weaponMasteries);
}

 final  List<ItemInput> _items;
@override@JsonKey() List<ItemInput> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  int xp;

/// Create a copy of CharacterInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CharacterInputCopyWith<_CharacterInput> get copyWith => __$CharacterInputCopyWithImpl<_CharacterInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CharacterInputToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CharacterInput&&(identical(other.name, name) || other.name == name)&&(identical(other.player, player) || other.player == player)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.speciesId, speciesId) || other.speciesId == speciesId)&&const DeepCollectionEquality().equals(other.speciesChoices, _speciesChoices)&&(identical(other.backgroundId, backgroundId) || other.backgroundId == backgroundId)&&(identical(other.baseScores, baseScores) || other.baseScores == baseScores)&&(identical(other.backgroundChoice, backgroundChoice) || other.backgroundChoice == backgroundChoice)&&const DeepCollectionEquality().equals(other.classLevels, _classLevels)&&const DeepCollectionEquality().equals(other.feats, _feats)&&const DeepCollectionEquality().equals(other.choices, _choices)&&const DeepCollectionEquality().equals(other.languages, _languages)&&const DeepCollectionEquality().equals(other.weaponMasteries, _weaponMasteries)&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.xp, xp) || other.xp == xp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,player,kind,speciesId,const DeepCollectionEquality().hash(_speciesChoices),backgroundId,baseScores,backgroundChoice,const DeepCollectionEquality().hash(_classLevels),const DeepCollectionEquality().hash(_feats),const DeepCollectionEquality().hash(_choices),const DeepCollectionEquality().hash(_languages),const DeepCollectionEquality().hash(_weaponMasteries),const DeepCollectionEquality().hash(_items),xp);
}

@override
String toString() {
    return 'CharacterInput(name: $name, player: $player, kind: $kind, speciesId: $speciesId, speciesChoices: $speciesChoices, backgroundId: $backgroundId, baseScores: $baseScores, backgroundChoice: $backgroundChoice, classLevels: $classLevels, feats: $feats, choices: $choices, languages: $languages, weaponMasteries: $weaponMasteries, items: $items, xp: $xp)';
}


}

/// @nodoc
abstract mixin class _$CharacterInputCopyWith<$Res> implements $CharacterInputCopyWith<$Res> {
  factory _$CharacterInputCopyWith(_CharacterInput value, $Res Function(_CharacterInput) _then) = __$CharacterInputCopyWithImpl;
@override @useResult
$Res call({
 String name, String? player, String kind, String speciesId, Map<String, String> speciesChoices, String backgroundId, BaseScores baseScores, BackgroundChoice backgroundChoice, List<ClassLevelInput> classLevels, List<FeatInput> feats, Map<String, List<String>> choices, List<String> languages, List<WeaponMasteryInput> weaponMasteries, List<ItemInput> items, int xp
});


@override $BaseScoresCopyWith<$Res> get baseScores;@override $BackgroundChoiceCopyWith<$Res> get backgroundChoice;

}
/// @nodoc
class __$CharacterInputCopyWithImpl<$Res>
    implements _$CharacterInputCopyWith<$Res> {
  __$CharacterInputCopyWithImpl(this._self, this._then);

  final _CharacterInput _self;
  final $Res Function(_CharacterInput) _then;

/// Create a copy of CharacterInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? player = freezed,Object? kind = null,Object? speciesId = null,Object? speciesChoices = null,Object? backgroundId = null,Object? baseScores = null,Object? backgroundChoice = null,Object? classLevels = null,Object? feats = null,Object? choices = null,Object? languages = null,Object? weaponMasteries = null,Object? items = null,Object? xp = null,}) {
  return _then(_CharacterInput(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,player: freezed == player ? _self.player : player // ignore: cast_nullable_to_non_nullable
as String?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,speciesId: null == speciesId ? _self.speciesId : speciesId // ignore: cast_nullable_to_non_nullable
as String,speciesChoices: null == speciesChoices ? _self._speciesChoices : speciesChoices // ignore: cast_nullable_to_non_nullable
as Map<String, String>,backgroundId: null == backgroundId ? _self.backgroundId : backgroundId // ignore: cast_nullable_to_non_nullable
as String,baseScores: null == baseScores ? _self.baseScores : baseScores // ignore: cast_nullable_to_non_nullable
as BaseScores,backgroundChoice: null == backgroundChoice ? _self.backgroundChoice : backgroundChoice // ignore: cast_nullable_to_non_nullable
as BackgroundChoice,classLevels: null == classLevels ? _self._classLevels : classLevels // ignore: cast_nullable_to_non_nullable
as List<ClassLevelInput>,feats: null == feats ? _self._feats : feats // ignore: cast_nullable_to_non_nullable
as List<FeatInput>,choices: null == choices ? _self._choices : choices // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,languages: null == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,weaponMasteries: null == weaponMasteries ? _self._weaponMasteries : weaponMasteries // ignore: cast_nullable_to_non_nullable
as List<WeaponMasteryInput>,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ItemInput>,xp: null == xp ? _self.xp : xp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of CharacterInput
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BaseScoresCopyWith<$Res> get baseScores {
  
  return $BaseScoresCopyWith<$Res>(_self.baseScores, (value) {
    return _then(_self.copyWith(baseScores: value));
  });
}/// Create a copy of CharacterInput
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BackgroundChoiceCopyWith<$Res> get backgroundChoice {
  
  return $BackgroundChoiceCopyWith<$Res>(_self.backgroundChoice, (value) {
    return _then(_self.copyWith(backgroundChoice: value));
  });
}
}

// dart format on
