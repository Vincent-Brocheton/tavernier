// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entity_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AbilityData {

 String get abbreviation;
/// Create a copy of AbilityData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AbilityDataCopyWith<AbilityData> get copyWith => _$AbilityDataCopyWithImpl<AbilityData>(this as AbilityData, _$identity);

  /// Serializes this AbilityData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AbilityData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AbilityData&&(identical(other.abbreviation, _this.abbreviation) || other.abbreviation == _this.abbreviation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AbilityData;
  return Object.hash(runtimeType,_this.abbreviation);
}

@override
String toString() {
  final _this = this as AbilityData;
  return 'AbilityData(abbreviation: ${_this.abbreviation})';
}


}

/// @nodoc
abstract mixin class $AbilityDataCopyWith<$Res>  {
  factory $AbilityDataCopyWith(AbilityData value, $Res Function(AbilityData) _then) = _$AbilityDataCopyWithImpl;
@useResult
$Res call({
 String abbreviation
});




}
/// @nodoc
class _$AbilityDataCopyWithImpl<$Res>
    implements $AbilityDataCopyWith<$Res> {
  _$AbilityDataCopyWithImpl(this._self, this._then);

  final AbilityData _self;
  final $Res Function(AbilityData) _then;

/// Create a copy of AbilityData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? abbreviation = null,}) {
  return _then(AbilityData(
abbreviation: null == abbreviation ? _self.abbreviation : abbreviation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AbilityData].
extension AbilityDataPatterns on AbilityData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AbilityData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AbilityData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AbilityData value)  $default,){
final _that = this;
switch (_that) {
case _AbilityData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AbilityData value)?  $default,){
final _that = this;
switch (_that) {
case _AbilityData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String abbreviation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AbilityData() when $default != null:
return $default(_that.abbreviation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String abbreviation)  $default,) {final _that = this;
switch (_that) {
case _AbilityData():
return $default(_that.abbreviation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String abbreviation)?  $default,) {final _that = this;
switch (_that) {
case _AbilityData() when $default != null:
return $default(_that.abbreviation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AbilityData implements AbilityData {
  const _AbilityData({required this.abbreviation});
  factory _AbilityData.fromJson(Map<String, dynamic> json) => _$AbilityDataFromJson(json);

@override final  String abbreviation;

/// Create a copy of AbilityData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AbilityDataCopyWith<_AbilityData> get copyWith => __$AbilityDataCopyWithImpl<_AbilityData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AbilityDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AbilityData&&(identical(other.abbreviation, abbreviation) || other.abbreviation == abbreviation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,abbreviation);
}

@override
String toString() {
    return 'AbilityData(abbreviation: $abbreviation)';
}


}

/// @nodoc
abstract mixin class _$AbilityDataCopyWith<$Res> implements $AbilityDataCopyWith<$Res> {
  factory _$AbilityDataCopyWith(_AbilityData value, $Res Function(_AbilityData) _then) = __$AbilityDataCopyWithImpl;
@override @useResult
$Res call({
 String abbreviation
});




}
/// @nodoc
class __$AbilityDataCopyWithImpl<$Res>
    implements _$AbilityDataCopyWith<$Res> {
  __$AbilityDataCopyWithImpl(this._self, this._then);

  final _AbilityData _self;
  final $Res Function(_AbilityData) _then;

/// Create a copy of AbilityData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? abbreviation = null,}) {
  return _then(_AbilityData(
abbreviation: null == abbreviation ? _self.abbreviation : abbreviation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SkillData {

@ContentIdConverter() ContentId get ability;
/// Create a copy of SkillData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SkillDataCopyWith<SkillData> get copyWith => _$SkillDataCopyWithImpl<SkillData>(this as SkillData, _$identity);

  /// Serializes this SkillData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SkillData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SkillData&&(identical(other.ability, _this.ability) || other.ability == _this.ability));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SkillData;
  return Object.hash(runtimeType,_this.ability);
}

@override
String toString() {
  final _this = this as SkillData;
  return 'SkillData(ability: ${_this.ability})';
}


}

/// @nodoc
abstract mixin class $SkillDataCopyWith<$Res>  {
  factory $SkillDataCopyWith(SkillData value, $Res Function(SkillData) _then) = _$SkillDataCopyWithImpl;
@useResult
$Res call({
@ContentIdConverter() ContentId ability
});




}
/// @nodoc
class _$SkillDataCopyWithImpl<$Res>
    implements $SkillDataCopyWith<$Res> {
  _$SkillDataCopyWithImpl(this._self, this._then);

  final SkillData _self;
  final $Res Function(SkillData) _then;

/// Create a copy of SkillData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ability = null,}) {
  return _then(SkillData(
ability: null == ability ? _self.ability : ability // ignore: cast_nullable_to_non_nullable
as ContentId,
  ));
}

}


/// Adds pattern-matching-related methods to [SkillData].
extension SkillDataPatterns on SkillData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SkillData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SkillData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SkillData value)  $default,){
final _that = this;
switch (_that) {
case _SkillData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SkillData value)?  $default,){
final _that = this;
switch (_that) {
case _SkillData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@ContentIdConverter()  ContentId ability)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SkillData() when $default != null:
return $default(_that.ability);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@ContentIdConverter()  ContentId ability)  $default,) {final _that = this;
switch (_that) {
case _SkillData():
return $default(_that.ability);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@ContentIdConverter()  ContentId ability)?  $default,) {final _that = this;
switch (_that) {
case _SkillData() when $default != null:
return $default(_that.ability);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SkillData implements SkillData {
  const _SkillData({@ContentIdConverter() required this.ability});
  factory _SkillData.fromJson(Map<String, dynamic> json) => _$SkillDataFromJson(json);

@override@ContentIdConverter() final  ContentId ability;

/// Create a copy of SkillData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SkillDataCopyWith<_SkillData> get copyWith => __$SkillDataCopyWithImpl<_SkillData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SkillDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SkillData&&(identical(other.ability, ability) || other.ability == ability));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,ability);
}

@override
String toString() {
    return 'SkillData(ability: $ability)';
}


}

/// @nodoc
abstract mixin class _$SkillDataCopyWith<$Res> implements $SkillDataCopyWith<$Res> {
  factory _$SkillDataCopyWith(_SkillData value, $Res Function(_SkillData) _then) = __$SkillDataCopyWithImpl;
@override @useResult
$Res call({
@ContentIdConverter() ContentId ability
});




}
/// @nodoc
class __$SkillDataCopyWithImpl<$Res>
    implements _$SkillDataCopyWith<$Res> {
  __$SkillDataCopyWithImpl(this._self, this._then);

  final _SkillData _self;
  final $Res Function(_SkillData) _then;

/// Create a copy of SkillData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ability = null,}) {
  return _then(_SkillData(
ability: null == ability ? _self.ability : ability // ignore: cast_nullable_to_non_nullable
as ContentId,
  ));
}


}


/// @nodoc
mixin _$LanguageData {

 LanguageCategory get category;
/// Create a copy of LanguageData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LanguageDataCopyWith<LanguageData> get copyWith => _$LanguageDataCopyWithImpl<LanguageData>(this as LanguageData, _$identity);

  /// Serializes this LanguageData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LanguageData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LanguageData&&(identical(other.category, _this.category) || other.category == _this.category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LanguageData;
  return Object.hash(runtimeType,_this.category);
}

@override
String toString() {
  final _this = this as LanguageData;
  return 'LanguageData(category: ${_this.category})';
}


}

/// @nodoc
abstract mixin class $LanguageDataCopyWith<$Res>  {
  factory $LanguageDataCopyWith(LanguageData value, $Res Function(LanguageData) _then) = _$LanguageDataCopyWithImpl;
@useResult
$Res call({
 LanguageCategory category
});




}
/// @nodoc
class _$LanguageDataCopyWithImpl<$Res>
    implements $LanguageDataCopyWith<$Res> {
  _$LanguageDataCopyWithImpl(this._self, this._then);

  final LanguageData _self;
  final $Res Function(LanguageData) _then;

/// Create a copy of LanguageData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,}) {
  return _then(LanguageData(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as LanguageCategory,
  ));
}

}


/// Adds pattern-matching-related methods to [LanguageData].
extension LanguageDataPatterns on LanguageData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LanguageData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LanguageData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LanguageData value)  $default,){
final _that = this;
switch (_that) {
case _LanguageData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LanguageData value)?  $default,){
final _that = this;
switch (_that) {
case _LanguageData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LanguageCategory category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LanguageData() when $default != null:
return $default(_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LanguageCategory category)  $default,) {final _that = this;
switch (_that) {
case _LanguageData():
return $default(_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LanguageCategory category)?  $default,) {final _that = this;
switch (_that) {
case _LanguageData() when $default != null:
return $default(_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LanguageData implements LanguageData {
  const _LanguageData({required this.category});
  factory _LanguageData.fromJson(Map<String, dynamic> json) => _$LanguageDataFromJson(json);

@override final  LanguageCategory category;

/// Create a copy of LanguageData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LanguageDataCopyWith<_LanguageData> get copyWith => __$LanguageDataCopyWithImpl<_LanguageData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LanguageDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LanguageData&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,category);
}

@override
String toString() {
    return 'LanguageData(category: $category)';
}


}

/// @nodoc
abstract mixin class _$LanguageDataCopyWith<$Res> implements $LanguageDataCopyWith<$Res> {
  factory _$LanguageDataCopyWith(_LanguageData value, $Res Function(_LanguageData) _then) = __$LanguageDataCopyWithImpl;
@override @useResult
$Res call({
 LanguageCategory category
});




}
/// @nodoc
class __$LanguageDataCopyWithImpl<$Res>
    implements _$LanguageDataCopyWith<$Res> {
  __$LanguageDataCopyWithImpl(this._self, this._then);

  final _LanguageData _self;
  final $Res Function(_LanguageData) _then;

/// Create a copy of LanguageData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,}) {
  return _then(_LanguageData(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as LanguageCategory,
  ));
}


}


/// @nodoc
mixin _$EmptyData {



  /// Serializes this EmptyData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EmptyData);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'EmptyData()';
}


}

/// @nodoc
class $EmptyDataCopyWith<$Res>  {
$EmptyDataCopyWith(EmptyData _, $Res Function(EmptyData) __);
}


/// Adds pattern-matching-related methods to [EmptyData].
extension EmptyDataPatterns on EmptyData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmptyData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmptyData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmptyData value)  $default,){
final _that = this;
switch (_that) {
case _EmptyData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmptyData value)?  $default,){
final _that = this;
switch (_that) {
case _EmptyData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function()?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmptyData() when $default != null:
return $default();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function()  $default,) {final _that = this;
switch (_that) {
case _EmptyData():
return $default();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function()?  $default,) {final _that = this;
switch (_that) {
case _EmptyData() when $default != null:
return $default();case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmptyData implements EmptyData {
  const _EmptyData();
  factory _EmptyData.fromJson(Map<String, dynamic> json) => _$EmptyDataFromJson(json);




@override
Map<String, dynamic> toJson() {
  return _$EmptyDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmptyData);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'EmptyData()';
}


}





/// @nodoc
mixin _$WeaponData {

 WeaponCategory get category; WeaponKind get kind; String get damage;@ContentIdConverter() ContentId get damageType; List<String> get properties; String? get versatileDamage; List<int>? get rangeFeet;@ContentIdConverter() ContentId get mastery; double? get weightKg; int get costCp;
/// Create a copy of WeaponData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeaponDataCopyWith<WeaponData> get copyWith => _$WeaponDataCopyWithImpl<WeaponData>(this as WeaponData, _$identity);

  /// Serializes this WeaponData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WeaponData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeaponData&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.damage, _this.damage) || other.damage == _this.damage)&&(identical(other.damageType, _this.damageType) || other.damageType == _this.damageType)&&const DeepCollectionEquality().equals(other.properties, _this.properties)&&(identical(other.versatileDamage, _this.versatileDamage) || other.versatileDamage == _this.versatileDamage)&&const DeepCollectionEquality().equals(other.rangeFeet, _this.rangeFeet)&&(identical(other.mastery, _this.mastery) || other.mastery == _this.mastery)&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg)&&(identical(other.costCp, _this.costCp) || other.costCp == _this.costCp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WeaponData;
  return Object.hash(runtimeType,_this.category,_this.kind,_this.damage,_this.damageType,const DeepCollectionEquality().hash(_this.properties),_this.versatileDamage,const DeepCollectionEquality().hash(_this.rangeFeet),_this.mastery,_this.weightKg,_this.costCp);
}

@override
String toString() {
  final _this = this as WeaponData;
  return 'WeaponData(category: ${_this.category}, kind: ${_this.kind}, damage: ${_this.damage}, damageType: ${_this.damageType}, properties: ${_this.properties}, versatileDamage: ${_this.versatileDamage}, rangeFeet: ${_this.rangeFeet}, mastery: ${_this.mastery}, weightKg: ${_this.weightKg}, costCp: ${_this.costCp})';
}


}

/// @nodoc
abstract mixin class $WeaponDataCopyWith<$Res>  {
  factory $WeaponDataCopyWith(WeaponData value, $Res Function(WeaponData) _then) = _$WeaponDataCopyWithImpl;
@useResult
$Res call({
 WeaponCategory category, WeaponKind kind, String damage,@ContentIdConverter() ContentId damageType, List<String> properties, String? versatileDamage, List<int>? rangeFeet,@ContentIdConverter() ContentId mastery, double? weightKg, int costCp
});




}
/// @nodoc
class _$WeaponDataCopyWithImpl<$Res>
    implements $WeaponDataCopyWith<$Res> {
  _$WeaponDataCopyWithImpl(this._self, this._then);

  final WeaponData _self;
  final $Res Function(WeaponData) _then;

/// Create a copy of WeaponData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? kind = null,Object? damage = null,Object? damageType = null,Object? properties = null,Object? versatileDamage = freezed,Object? rangeFeet = freezed,Object? mastery = null,Object? weightKg = freezed,Object? costCp = null,}) {
  return _then(WeaponData(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as WeaponCategory,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as WeaponKind,damage: null == damage ? _self.damage : damage // ignore: cast_nullable_to_non_nullable
as String,damageType: null == damageType ? _self.damageType : damageType // ignore: cast_nullable_to_non_nullable
as ContentId,properties: null == properties ? _self.properties : properties // ignore: cast_nullable_to_non_nullable
as List<String>,versatileDamage: freezed == versatileDamage ? _self.versatileDamage : versatileDamage // ignore: cast_nullable_to_non_nullable
as String?,rangeFeet: freezed == rangeFeet ? _self.rangeFeet : rangeFeet // ignore: cast_nullable_to_non_nullable
as List<int>?,mastery: null == mastery ? _self.mastery : mastery // ignore: cast_nullable_to_non_nullable
as ContentId,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,costCp: null == costCp ? _self.costCp : costCp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WeaponData].
extension WeaponDataPatterns on WeaponData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeaponData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeaponData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeaponData value)  $default,){
final _that = this;
switch (_that) {
case _WeaponData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeaponData value)?  $default,){
final _that = this;
switch (_that) {
case _WeaponData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WeaponCategory category,  WeaponKind kind,  String damage, @ContentIdConverter()  ContentId damageType,  List<String> properties,  String? versatileDamage,  List<int>? rangeFeet, @ContentIdConverter()  ContentId mastery,  double? weightKg,  int costCp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeaponData() when $default != null:
return $default(_that.category,_that.kind,_that.damage,_that.damageType,_that.properties,_that.versatileDamage,_that.rangeFeet,_that.mastery,_that.weightKg,_that.costCp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WeaponCategory category,  WeaponKind kind,  String damage, @ContentIdConverter()  ContentId damageType,  List<String> properties,  String? versatileDamage,  List<int>? rangeFeet, @ContentIdConverter()  ContentId mastery,  double? weightKg,  int costCp)  $default,) {final _that = this;
switch (_that) {
case _WeaponData():
return $default(_that.category,_that.kind,_that.damage,_that.damageType,_that.properties,_that.versatileDamage,_that.rangeFeet,_that.mastery,_that.weightKg,_that.costCp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WeaponCategory category,  WeaponKind kind,  String damage, @ContentIdConverter()  ContentId damageType,  List<String> properties,  String? versatileDamage,  List<int>? rangeFeet, @ContentIdConverter()  ContentId mastery,  double? weightKg,  int costCp)?  $default,) {final _that = this;
switch (_that) {
case _WeaponData() when $default != null:
return $default(_that.category,_that.kind,_that.damage,_that.damageType,_that.properties,_that.versatileDamage,_that.rangeFeet,_that.mastery,_that.weightKg,_that.costCp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeaponData implements WeaponData {
  const _WeaponData({required this.category, required this.kind, required this.damage, @ContentIdConverter() required this.damageType,  List<String> properties = const <String>[], this.versatileDamage,  List<int>? rangeFeet, @ContentIdConverter() required this.mastery, this.weightKg, required this.costCp}): _properties = properties,_rangeFeet = rangeFeet;
  factory _WeaponData.fromJson(Map<String, dynamic> json) => _$WeaponDataFromJson(json);

@override final  WeaponCategory category;
@override final  WeaponKind kind;
@override final  String damage;
@override@ContentIdConverter() final  ContentId damageType;
 final  List<String> _properties;
@override@JsonKey() List<String> get properties {
  if (_properties is EqualUnmodifiableListView) return _properties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_properties);
}

@override final  String? versatileDamage;
 final  List<int>? _rangeFeet;
@override List<int>? get rangeFeet {
  final value = _rangeFeet;
  if (value == null) return null;
  if (_rangeFeet is EqualUnmodifiableListView) return _rangeFeet;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@ContentIdConverter() final  ContentId mastery;
@override final  double? weightKg;
@override final  int costCp;

/// Create a copy of WeaponData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeaponDataCopyWith<_WeaponData> get copyWith => __$WeaponDataCopyWithImpl<_WeaponData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeaponDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeaponData&&(identical(other.category, category) || other.category == category)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.damage, damage) || other.damage == damage)&&(identical(other.damageType, damageType) || other.damageType == damageType)&&const DeepCollectionEquality().equals(other.properties, _properties)&&(identical(other.versatileDamage, versatileDamage) || other.versatileDamage == versatileDamage)&&const DeepCollectionEquality().equals(other.rangeFeet, _rangeFeet)&&(identical(other.mastery, mastery) || other.mastery == mastery)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.costCp, costCp) || other.costCp == costCp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,category,kind,damage,damageType,const DeepCollectionEquality().hash(_properties),versatileDamage,const DeepCollectionEquality().hash(_rangeFeet),mastery,weightKg,costCp);
}

@override
String toString() {
    return 'WeaponData(category: $category, kind: $kind, damage: $damage, damageType: $damageType, properties: $properties, versatileDamage: $versatileDamage, rangeFeet: $rangeFeet, mastery: $mastery, weightKg: $weightKg, costCp: $costCp)';
}


}

/// @nodoc
abstract mixin class _$WeaponDataCopyWith<$Res> implements $WeaponDataCopyWith<$Res> {
  factory _$WeaponDataCopyWith(_WeaponData value, $Res Function(_WeaponData) _then) = __$WeaponDataCopyWithImpl;
@override @useResult
$Res call({
 WeaponCategory category, WeaponKind kind, String damage,@ContentIdConverter() ContentId damageType, List<String> properties, String? versatileDamage, List<int>? rangeFeet,@ContentIdConverter() ContentId mastery, double? weightKg, int costCp
});




}
/// @nodoc
class __$WeaponDataCopyWithImpl<$Res>
    implements _$WeaponDataCopyWith<$Res> {
  __$WeaponDataCopyWithImpl(this._self, this._then);

  final _WeaponData _self;
  final $Res Function(_WeaponData) _then;

/// Create a copy of WeaponData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? kind = null,Object? damage = null,Object? damageType = null,Object? properties = null,Object? versatileDamage = freezed,Object? rangeFeet = freezed,Object? mastery = null,Object? weightKg = freezed,Object? costCp = null,}) {
  return _then(_WeaponData(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as WeaponCategory,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as WeaponKind,damage: null == damage ? _self.damage : damage // ignore: cast_nullable_to_non_nullable
as String,damageType: null == damageType ? _self.damageType : damageType // ignore: cast_nullable_to_non_nullable
as ContentId,properties: null == properties ? _self._properties : properties // ignore: cast_nullable_to_non_nullable
as List<String>,versatileDamage: freezed == versatileDamage ? _self.versatileDamage : versatileDamage // ignore: cast_nullable_to_non_nullable
as String?,rangeFeet: freezed == rangeFeet ? _self._rangeFeet : rangeFeet // ignore: cast_nullable_to_non_nullable
as List<int>?,mastery: null == mastery ? _self.mastery : mastery // ignore: cast_nullable_to_non_nullable
as ContentId,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,costCp: null == costCp ? _self.costCp : costCp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ArmorData {

 ArmorCategory get category; int get baseAc;/// Plafond du modificateur de DEX : absent = sans limite, 0 = ignoré.
 int? get dexCap; int? get strRequirement; bool get stealthDisadvantage; double get weightKg; int get costCp;
/// Create a copy of ArmorData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArmorDataCopyWith<ArmorData> get copyWith => _$ArmorDataCopyWithImpl<ArmorData>(this as ArmorData, _$identity);

  /// Serializes this ArmorData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ArmorData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArmorData&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.baseAc, _this.baseAc) || other.baseAc == _this.baseAc)&&(identical(other.dexCap, _this.dexCap) || other.dexCap == _this.dexCap)&&(identical(other.strRequirement, _this.strRequirement) || other.strRequirement == _this.strRequirement)&&(identical(other.stealthDisadvantage, _this.stealthDisadvantage) || other.stealthDisadvantage == _this.stealthDisadvantage)&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg)&&(identical(other.costCp, _this.costCp) || other.costCp == _this.costCp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ArmorData;
  return Object.hash(runtimeType,_this.category,_this.baseAc,_this.dexCap,_this.strRequirement,_this.stealthDisadvantage,_this.weightKg,_this.costCp);
}

@override
String toString() {
  final _this = this as ArmorData;
  return 'ArmorData(category: ${_this.category}, baseAc: ${_this.baseAc}, dexCap: ${_this.dexCap}, strRequirement: ${_this.strRequirement}, stealthDisadvantage: ${_this.stealthDisadvantage}, weightKg: ${_this.weightKg}, costCp: ${_this.costCp})';
}


}

/// @nodoc
abstract mixin class $ArmorDataCopyWith<$Res>  {
  factory $ArmorDataCopyWith(ArmorData value, $Res Function(ArmorData) _then) = _$ArmorDataCopyWithImpl;
@useResult
$Res call({
 ArmorCategory category, int baseAc, int? dexCap, int? strRequirement, bool stealthDisadvantage, double weightKg, int costCp
});




}
/// @nodoc
class _$ArmorDataCopyWithImpl<$Res>
    implements $ArmorDataCopyWith<$Res> {
  _$ArmorDataCopyWithImpl(this._self, this._then);

  final ArmorData _self;
  final $Res Function(ArmorData) _then;

/// Create a copy of ArmorData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? baseAc = null,Object? dexCap = freezed,Object? strRequirement = freezed,Object? stealthDisadvantage = null,Object? weightKg = null,Object? costCp = null,}) {
  return _then(ArmorData(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ArmorCategory,baseAc: null == baseAc ? _self.baseAc : baseAc // ignore: cast_nullable_to_non_nullable
as int,dexCap: freezed == dexCap ? _self.dexCap : dexCap // ignore: cast_nullable_to_non_nullable
as int?,strRequirement: freezed == strRequirement ? _self.strRequirement : strRequirement // ignore: cast_nullable_to_non_nullable
as int?,stealthDisadvantage: null == stealthDisadvantage ? _self.stealthDisadvantage : stealthDisadvantage // ignore: cast_nullable_to_non_nullable
as bool,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,costCp: null == costCp ? _self.costCp : costCp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ArmorData].
extension ArmorDataPatterns on ArmorData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArmorData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArmorData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArmorData value)  $default,){
final _that = this;
switch (_that) {
case _ArmorData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArmorData value)?  $default,){
final _that = this;
switch (_that) {
case _ArmorData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ArmorCategory category,  int baseAc,  int? dexCap,  int? strRequirement,  bool stealthDisadvantage,  double weightKg,  int costCp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArmorData() when $default != null:
return $default(_that.category,_that.baseAc,_that.dexCap,_that.strRequirement,_that.stealthDisadvantage,_that.weightKg,_that.costCp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ArmorCategory category,  int baseAc,  int? dexCap,  int? strRequirement,  bool stealthDisadvantage,  double weightKg,  int costCp)  $default,) {final _that = this;
switch (_that) {
case _ArmorData():
return $default(_that.category,_that.baseAc,_that.dexCap,_that.strRequirement,_that.stealthDisadvantage,_that.weightKg,_that.costCp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ArmorCategory category,  int baseAc,  int? dexCap,  int? strRequirement,  bool stealthDisadvantage,  double weightKg,  int costCp)?  $default,) {final _that = this;
switch (_that) {
case _ArmorData() when $default != null:
return $default(_that.category,_that.baseAc,_that.dexCap,_that.strRequirement,_that.stealthDisadvantage,_that.weightKg,_that.costCp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArmorData implements ArmorData {
  const _ArmorData({required this.category, required this.baseAc, this.dexCap, this.strRequirement, this.stealthDisadvantage = false, required this.weightKg, required this.costCp});
  factory _ArmorData.fromJson(Map<String, dynamic> json) => _$ArmorDataFromJson(json);

@override final  ArmorCategory category;
@override final  int baseAc;
/// Plafond du modificateur de DEX : absent = sans limite, 0 = ignoré.
@override final  int? dexCap;
@override final  int? strRequirement;
@override@JsonKey() final  bool stealthDisadvantage;
@override final  double weightKg;
@override final  int costCp;

/// Create a copy of ArmorData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArmorDataCopyWith<_ArmorData> get copyWith => __$ArmorDataCopyWithImpl<_ArmorData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArmorDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArmorData&&(identical(other.category, category) || other.category == category)&&(identical(other.baseAc, baseAc) || other.baseAc == baseAc)&&(identical(other.dexCap, dexCap) || other.dexCap == dexCap)&&(identical(other.strRequirement, strRequirement) || other.strRequirement == strRequirement)&&(identical(other.stealthDisadvantage, stealthDisadvantage) || other.stealthDisadvantage == stealthDisadvantage)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.costCp, costCp) || other.costCp == costCp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,category,baseAc,dexCap,strRequirement,stealthDisadvantage,weightKg,costCp);
}

@override
String toString() {
    return 'ArmorData(category: $category, baseAc: $baseAc, dexCap: $dexCap, strRequirement: $strRequirement, stealthDisadvantage: $stealthDisadvantage, weightKg: $weightKg, costCp: $costCp)';
}


}

/// @nodoc
abstract mixin class _$ArmorDataCopyWith<$Res> implements $ArmorDataCopyWith<$Res> {
  factory _$ArmorDataCopyWith(_ArmorData value, $Res Function(_ArmorData) _then) = __$ArmorDataCopyWithImpl;
@override @useResult
$Res call({
 ArmorCategory category, int baseAc, int? dexCap, int? strRequirement, bool stealthDisadvantage, double weightKg, int costCp
});




}
/// @nodoc
class __$ArmorDataCopyWithImpl<$Res>
    implements _$ArmorDataCopyWith<$Res> {
  __$ArmorDataCopyWithImpl(this._self, this._then);

  final _ArmorData _self;
  final $Res Function(_ArmorData) _then;

/// Create a copy of ArmorData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? baseAc = null,Object? dexCap = freezed,Object? strRequirement = freezed,Object? stealthDisadvantage = null,Object? weightKg = null,Object? costCp = null,}) {
  return _then(_ArmorData(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ArmorCategory,baseAc: null == baseAc ? _self.baseAc : baseAc // ignore: cast_nullable_to_non_nullable
as int,dexCap: freezed == dexCap ? _self.dexCap : dexCap // ignore: cast_nullable_to_non_nullable
as int?,strRequirement: freezed == strRequirement ? _self.strRequirement : strRequirement // ignore: cast_nullable_to_non_nullable
as int?,stealthDisadvantage: null == stealthDisadvantage ? _self.stealthDisadvantage : stealthDisadvantage // ignore: cast_nullable_to_non_nullable
as bool,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,costCp: null == costCp ? _self.costCp : costCp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ToolData {

 ToolCategory get category;@ContentIdConverter() ContentId? get ability; double? get weightKg; int get costCp;
/// Create a copy of ToolData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToolDataCopyWith<ToolData> get copyWith => _$ToolDataCopyWithImpl<ToolData>(this as ToolData, _$identity);

  /// Serializes this ToolData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ToolData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToolData&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.ability, _this.ability) || other.ability == _this.ability)&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg)&&(identical(other.costCp, _this.costCp) || other.costCp == _this.costCp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ToolData;
  return Object.hash(runtimeType,_this.category,_this.ability,_this.weightKg,_this.costCp);
}

@override
String toString() {
  final _this = this as ToolData;
  return 'ToolData(category: ${_this.category}, ability: ${_this.ability}, weightKg: ${_this.weightKg}, costCp: ${_this.costCp})';
}


}

/// @nodoc
abstract mixin class $ToolDataCopyWith<$Res>  {
  factory $ToolDataCopyWith(ToolData value, $Res Function(ToolData) _then) = _$ToolDataCopyWithImpl;
@useResult
$Res call({
 ToolCategory category,@ContentIdConverter() ContentId? ability, double? weightKg, int costCp
});




}
/// @nodoc
class _$ToolDataCopyWithImpl<$Res>
    implements $ToolDataCopyWith<$Res> {
  _$ToolDataCopyWithImpl(this._self, this._then);

  final ToolData _self;
  final $Res Function(ToolData) _then;

/// Create a copy of ToolData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? ability = freezed,Object? weightKg = freezed,Object? costCp = null,}) {
  return _then(ToolData(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ToolCategory,ability: freezed == ability ? _self.ability : ability // ignore: cast_nullable_to_non_nullable
as ContentId?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,costCp: null == costCp ? _self.costCp : costCp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ToolData].
extension ToolDataPatterns on ToolData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ToolData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ToolData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ToolData value)  $default,){
final _that = this;
switch (_that) {
case _ToolData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ToolData value)?  $default,){
final _that = this;
switch (_that) {
case _ToolData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ToolCategory category, @ContentIdConverter()  ContentId? ability,  double? weightKg,  int costCp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ToolData() when $default != null:
return $default(_that.category,_that.ability,_that.weightKg,_that.costCp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ToolCategory category, @ContentIdConverter()  ContentId? ability,  double? weightKg,  int costCp)  $default,) {final _that = this;
switch (_that) {
case _ToolData():
return $default(_that.category,_that.ability,_that.weightKg,_that.costCp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ToolCategory category, @ContentIdConverter()  ContentId? ability,  double? weightKg,  int costCp)?  $default,) {final _that = this;
switch (_that) {
case _ToolData() when $default != null:
return $default(_that.category,_that.ability,_that.weightKg,_that.costCp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ToolData implements ToolData {
  const _ToolData({required this.category, @ContentIdConverter() this.ability, this.weightKg, required this.costCp});
  factory _ToolData.fromJson(Map<String, dynamic> json) => _$ToolDataFromJson(json);

@override final  ToolCategory category;
@override@ContentIdConverter() final  ContentId? ability;
@override final  double? weightKg;
@override final  int costCp;

/// Create a copy of ToolData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ToolDataCopyWith<_ToolData> get copyWith => __$ToolDataCopyWithImpl<_ToolData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ToolDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToolData&&(identical(other.category, category) || other.category == category)&&(identical(other.ability, ability) || other.ability == ability)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.costCp, costCp) || other.costCp == costCp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,category,ability,weightKg,costCp);
}

@override
String toString() {
    return 'ToolData(category: $category, ability: $ability, weightKg: $weightKg, costCp: $costCp)';
}


}

/// @nodoc
abstract mixin class _$ToolDataCopyWith<$Res> implements $ToolDataCopyWith<$Res> {
  factory _$ToolDataCopyWith(_ToolData value, $Res Function(_ToolData) _then) = __$ToolDataCopyWithImpl;
@override @useResult
$Res call({
 ToolCategory category,@ContentIdConverter() ContentId? ability, double? weightKg, int costCp
});




}
/// @nodoc
class __$ToolDataCopyWithImpl<$Res>
    implements _$ToolDataCopyWith<$Res> {
  __$ToolDataCopyWithImpl(this._self, this._then);

  final _ToolData _self;
  final $Res Function(_ToolData) _then;

/// Create a copy of ToolData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? ability = freezed,Object? weightKg = freezed,Object? costCp = null,}) {
  return _then(_ToolData(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ToolCategory,ability: freezed == ability ? _self.ability : ability // ignore: cast_nullable_to_non_nullable
as ContentId?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,costCp: null == costCp ? _self.costCp : costCp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ItemData {

 double? get weightKg; int? get costCp;
/// Create a copy of ItemData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemDataCopyWith<ItemData> get copyWith => _$ItemDataCopyWithImpl<ItemData>(this as ItemData, _$identity);

  /// Serializes this ItemData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ItemData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemData&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg)&&(identical(other.costCp, _this.costCp) || other.costCp == _this.costCp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ItemData;
  return Object.hash(runtimeType,_this.weightKg,_this.costCp);
}

@override
String toString() {
  final _this = this as ItemData;
  return 'ItemData(weightKg: ${_this.weightKg}, costCp: ${_this.costCp})';
}


}

/// @nodoc
abstract mixin class $ItemDataCopyWith<$Res>  {
  factory $ItemDataCopyWith(ItemData value, $Res Function(ItemData) _then) = _$ItemDataCopyWithImpl;
@useResult
$Res call({
 double? weightKg, int? costCp
});




}
/// @nodoc
class _$ItemDataCopyWithImpl<$Res>
    implements $ItemDataCopyWith<$Res> {
  _$ItemDataCopyWithImpl(this._self, this._then);

  final ItemData _self;
  final $Res Function(ItemData) _then;

/// Create a copy of ItemData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weightKg = freezed,Object? costCp = freezed,}) {
  return _then(ItemData(
weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,costCp: freezed == costCp ? _self.costCp : costCp // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemData].
extension ItemDataPatterns on ItemData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemData value)  $default,){
final _that = this;
switch (_that) {
case _ItemData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemData value)?  $default,){
final _that = this;
switch (_that) {
case _ItemData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? weightKg,  int? costCp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemData() when $default != null:
return $default(_that.weightKg,_that.costCp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? weightKg,  int? costCp)  $default,) {final _that = this;
switch (_that) {
case _ItemData():
return $default(_that.weightKg,_that.costCp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? weightKg,  int? costCp)?  $default,) {final _that = this;
switch (_that) {
case _ItemData() when $default != null:
return $default(_that.weightKg,_that.costCp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemData implements ItemData {
  const _ItemData({this.weightKg, this.costCp});
  factory _ItemData.fromJson(Map<String, dynamic> json) => _$ItemDataFromJson(json);

@override final  double? weightKg;
@override final  int? costCp;

/// Create a copy of ItemData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemDataCopyWith<_ItemData> get copyWith => __$ItemDataCopyWithImpl<_ItemData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemData&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.costCp, costCp) || other.costCp == costCp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,weightKg,costCp);
}

@override
String toString() {
    return 'ItemData(weightKg: $weightKg, costCp: $costCp)';
}


}

/// @nodoc
abstract mixin class _$ItemDataCopyWith<$Res> implements $ItemDataCopyWith<$Res> {
  factory _$ItemDataCopyWith(_ItemData value, $Res Function(_ItemData) _then) = __$ItemDataCopyWithImpl;
@override @useResult
$Res call({
 double? weightKg, int? costCp
});




}
/// @nodoc
class __$ItemDataCopyWithImpl<$Res>
    implements _$ItemDataCopyWith<$Res> {
  __$ItemDataCopyWithImpl(this._self, this._then);

  final _ItemData _self;
  final $Res Function(_ItemData) _then;

/// Create a copy of ItemData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weightKg = freezed,Object? costCp = freezed,}) {
  return _then(_ItemData(
weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,costCp: freezed == costCp ? _self.costCp : costCp // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$MagicItemData {

 MagicItemCategory get category; Rarity get rarity;/// Ligne de type du SRD, recopiée telle quelle.
 String get typeLine; bool get attunement;/// Créature exigée pour l'harmonisation (« un Magicien »).
 String? get attunementBy;
/// Create a copy of MagicItemData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MagicItemDataCopyWith<MagicItemData> get copyWith => _$MagicItemDataCopyWithImpl<MagicItemData>(this as MagicItemData, _$identity);

  /// Serializes this MagicItemData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MagicItemData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MagicItemData&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.rarity, _this.rarity) || other.rarity == _this.rarity)&&(identical(other.typeLine, _this.typeLine) || other.typeLine == _this.typeLine)&&(identical(other.attunement, _this.attunement) || other.attunement == _this.attunement)&&(identical(other.attunementBy, _this.attunementBy) || other.attunementBy == _this.attunementBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MagicItemData;
  return Object.hash(runtimeType,_this.category,_this.rarity,_this.typeLine,_this.attunement,_this.attunementBy);
}

@override
String toString() {
  final _this = this as MagicItemData;
  return 'MagicItemData(category: ${_this.category}, rarity: ${_this.rarity}, typeLine: ${_this.typeLine}, attunement: ${_this.attunement}, attunementBy: ${_this.attunementBy})';
}


}

/// @nodoc
abstract mixin class $MagicItemDataCopyWith<$Res>  {
  factory $MagicItemDataCopyWith(MagicItemData value, $Res Function(MagicItemData) _then) = _$MagicItemDataCopyWithImpl;
@useResult
$Res call({
 MagicItemCategory category, Rarity rarity, String typeLine, bool attunement, String? attunementBy
});




}
/// @nodoc
class _$MagicItemDataCopyWithImpl<$Res>
    implements $MagicItemDataCopyWith<$Res> {
  _$MagicItemDataCopyWithImpl(this._self, this._then);

  final MagicItemData _self;
  final $Res Function(MagicItemData) _then;

/// Create a copy of MagicItemData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? rarity = null,Object? typeLine = null,Object? attunement = null,Object? attunementBy = freezed,}) {
  return _then(MagicItemData(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MagicItemCategory,rarity: null == rarity ? _self.rarity : rarity // ignore: cast_nullable_to_non_nullable
as Rarity,typeLine: null == typeLine ? _self.typeLine : typeLine // ignore: cast_nullable_to_non_nullable
as String,attunement: null == attunement ? _self.attunement : attunement // ignore: cast_nullable_to_non_nullable
as bool,attunementBy: freezed == attunementBy ? _self.attunementBy : attunementBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MagicItemData].
extension MagicItemDataPatterns on MagicItemData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MagicItemData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MagicItemData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MagicItemData value)  $default,){
final _that = this;
switch (_that) {
case _MagicItemData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MagicItemData value)?  $default,){
final _that = this;
switch (_that) {
case _MagicItemData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MagicItemCategory category,  Rarity rarity,  String typeLine,  bool attunement,  String? attunementBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MagicItemData() when $default != null:
return $default(_that.category,_that.rarity,_that.typeLine,_that.attunement,_that.attunementBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MagicItemCategory category,  Rarity rarity,  String typeLine,  bool attunement,  String? attunementBy)  $default,) {final _that = this;
switch (_that) {
case _MagicItemData():
return $default(_that.category,_that.rarity,_that.typeLine,_that.attunement,_that.attunementBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MagicItemCategory category,  Rarity rarity,  String typeLine,  bool attunement,  String? attunementBy)?  $default,) {final _that = this;
switch (_that) {
case _MagicItemData() when $default != null:
return $default(_that.category,_that.rarity,_that.typeLine,_that.attunement,_that.attunementBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MagicItemData implements MagicItemData {
  const _MagicItemData({required this.category, required this.rarity, required this.typeLine, this.attunement = false, this.attunementBy});
  factory _MagicItemData.fromJson(Map<String, dynamic> json) => _$MagicItemDataFromJson(json);

@override final  MagicItemCategory category;
@override final  Rarity rarity;
/// Ligne de type du SRD, recopiée telle quelle.
@override final  String typeLine;
@override@JsonKey() final  bool attunement;
/// Créature exigée pour l'harmonisation (« un Magicien »).
@override final  String? attunementBy;

/// Create a copy of MagicItemData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MagicItemDataCopyWith<_MagicItemData> get copyWith => __$MagicItemDataCopyWithImpl<_MagicItemData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MagicItemDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MagicItemData&&(identical(other.category, category) || other.category == category)&&(identical(other.rarity, rarity) || other.rarity == rarity)&&(identical(other.typeLine, typeLine) || other.typeLine == typeLine)&&(identical(other.attunement, attunement) || other.attunement == attunement)&&(identical(other.attunementBy, attunementBy) || other.attunementBy == attunementBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,category,rarity,typeLine,attunement,attunementBy);
}

@override
String toString() {
    return 'MagicItemData(category: $category, rarity: $rarity, typeLine: $typeLine, attunement: $attunement, attunementBy: $attunementBy)';
}


}

/// @nodoc
abstract mixin class _$MagicItemDataCopyWith<$Res> implements $MagicItemDataCopyWith<$Res> {
  factory _$MagicItemDataCopyWith(_MagicItemData value, $Res Function(_MagicItemData) _then) = __$MagicItemDataCopyWithImpl;
@override @useResult
$Res call({
 MagicItemCategory category, Rarity rarity, String typeLine, bool attunement, String? attunementBy
});




}
/// @nodoc
class __$MagicItemDataCopyWithImpl<$Res>
    implements _$MagicItemDataCopyWith<$Res> {
  __$MagicItemDataCopyWithImpl(this._self, this._then);

  final _MagicItemData _self;
  final $Res Function(_MagicItemData) _then;

/// Create a copy of MagicItemData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? rarity = null,Object? typeLine = null,Object? attunement = null,Object? attunementBy = freezed,}) {
  return _then(_MagicItemData(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MagicItemCategory,rarity: null == rarity ? _self.rarity : rarity // ignore: cast_nullable_to_non_nullable
as Rarity,typeLine: null == typeLine ? _self.typeLine : typeLine // ignore: cast_nullable_to_non_nullable
as String,attunement: null == attunement ? _self.attunement : attunement // ignore: cast_nullable_to_non_nullable
as bool,attunementBy: freezed == attunementBy ? _self.attunementBy : attunementBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ItemQuantity {

@ContentIdConverter() ContentId get item; int get quantity;
/// Create a copy of ItemQuantity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemQuantityCopyWith<ItemQuantity> get copyWith => _$ItemQuantityCopyWithImpl<ItemQuantity>(this as ItemQuantity, _$identity);

  /// Serializes this ItemQuantity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ItemQuantity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemQuantity&&(identical(other.item, _this.item) || other.item == _this.item)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ItemQuantity;
  return Object.hash(runtimeType,_this.item,_this.quantity);
}

@override
String toString() {
  final _this = this as ItemQuantity;
  return 'ItemQuantity(item: ${_this.item}, quantity: ${_this.quantity})';
}


}

/// @nodoc
abstract mixin class $ItemQuantityCopyWith<$Res>  {
  factory $ItemQuantityCopyWith(ItemQuantity value, $Res Function(ItemQuantity) _then) = _$ItemQuantityCopyWithImpl;
@useResult
$Res call({
@ContentIdConverter() ContentId item, int quantity
});




}
/// @nodoc
class _$ItemQuantityCopyWithImpl<$Res>
    implements $ItemQuantityCopyWith<$Res> {
  _$ItemQuantityCopyWithImpl(this._self, this._then);

  final ItemQuantity _self;
  final $Res Function(ItemQuantity) _then;

/// Create a copy of ItemQuantity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? item = null,Object? quantity = null,}) {
  return _then(ItemQuantity(
item: null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as ContentId,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemQuantity].
extension ItemQuantityPatterns on ItemQuantity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemQuantity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemQuantity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemQuantity value)  $default,){
final _that = this;
switch (_that) {
case _ItemQuantity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemQuantity value)?  $default,){
final _that = this;
switch (_that) {
case _ItemQuantity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@ContentIdConverter()  ContentId item,  int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemQuantity() when $default != null:
return $default(_that.item,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@ContentIdConverter()  ContentId item,  int quantity)  $default,) {final _that = this;
switch (_that) {
case _ItemQuantity():
return $default(_that.item,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@ContentIdConverter()  ContentId item,  int quantity)?  $default,) {final _that = this;
switch (_that) {
case _ItemQuantity() when $default != null:
return $default(_that.item,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemQuantity implements ItemQuantity {
  const _ItemQuantity({@ContentIdConverter() required this.item, required this.quantity});
  factory _ItemQuantity.fromJson(Map<String, dynamic> json) => _$ItemQuantityFromJson(json);

@override@ContentIdConverter() final  ContentId item;
@override final  int quantity;

/// Create a copy of ItemQuantity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemQuantityCopyWith<_ItemQuantity> get copyWith => __$ItemQuantityCopyWithImpl<_ItemQuantity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemQuantityToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemQuantity&&(identical(other.item, item) || other.item == item)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,item,quantity);
}

@override
String toString() {
    return 'ItemQuantity(item: $item, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$ItemQuantityCopyWith<$Res> implements $ItemQuantityCopyWith<$Res> {
  factory _$ItemQuantityCopyWith(_ItemQuantity value, $Res Function(_ItemQuantity) _then) = __$ItemQuantityCopyWithImpl;
@override @useResult
$Res call({
@ContentIdConverter() ContentId item, int quantity
});




}
/// @nodoc
class __$ItemQuantityCopyWithImpl<$Res>
    implements _$ItemQuantityCopyWith<$Res> {
  __$ItemQuantityCopyWithImpl(this._self, this._then);

  final _ItemQuantity _self;
  final $Res Function(_ItemQuantity) _then;

/// Create a copy of ItemQuantity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? item = null,Object? quantity = null,}) {
  return _then(_ItemQuantity(
item: null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as ContentId,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$StartingEquipmentOption {

 List<ItemQuantity> get items;/// Un outil à choisir parmi ces catégories (« instrument de musique de
/// votre choix »).
 List<ToolCategory> get toolChoice;/// Pièces d'or.
 int get gold;
/// Create a copy of StartingEquipmentOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StartingEquipmentOptionCopyWith<StartingEquipmentOption> get copyWith => _$StartingEquipmentOptionCopyWithImpl<StartingEquipmentOption>(this as StartingEquipmentOption, _$identity);

  /// Serializes this StartingEquipmentOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StartingEquipmentOption;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StartingEquipmentOption&&const DeepCollectionEquality().equals(other.items, _this.items)&&const DeepCollectionEquality().equals(other.toolChoice, _this.toolChoice)&&(identical(other.gold, _this.gold) || other.gold == _this.gold));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StartingEquipmentOption;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),const DeepCollectionEquality().hash(_this.toolChoice),_this.gold);
}

@override
String toString() {
  final _this = this as StartingEquipmentOption;
  return 'StartingEquipmentOption(items: ${_this.items}, toolChoice: ${_this.toolChoice}, gold: ${_this.gold})';
}


}

/// @nodoc
abstract mixin class $StartingEquipmentOptionCopyWith<$Res>  {
  factory $StartingEquipmentOptionCopyWith(StartingEquipmentOption value, $Res Function(StartingEquipmentOption) _then) = _$StartingEquipmentOptionCopyWithImpl;
@useResult
$Res call({
 List<ItemQuantity> items, List<ToolCategory> toolChoice, int gold
});




}
/// @nodoc
class _$StartingEquipmentOptionCopyWithImpl<$Res>
    implements $StartingEquipmentOptionCopyWith<$Res> {
  _$StartingEquipmentOptionCopyWithImpl(this._self, this._then);

  final StartingEquipmentOption _self;
  final $Res Function(StartingEquipmentOption) _then;

/// Create a copy of StartingEquipmentOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? toolChoice = null,Object? gold = null,}) {
  return _then(StartingEquipmentOption(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ItemQuantity>,toolChoice: null == toolChoice ? _self.toolChoice : toolChoice // ignore: cast_nullable_to_non_nullable
as List<ToolCategory>,gold: null == gold ? _self.gold : gold // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StartingEquipmentOption].
extension StartingEquipmentOptionPatterns on StartingEquipmentOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StartingEquipmentOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StartingEquipmentOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StartingEquipmentOption value)  $default,){
final _that = this;
switch (_that) {
case _StartingEquipmentOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StartingEquipmentOption value)?  $default,){
final _that = this;
switch (_that) {
case _StartingEquipmentOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ItemQuantity> items,  List<ToolCategory> toolChoice,  int gold)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StartingEquipmentOption() when $default != null:
return $default(_that.items,_that.toolChoice,_that.gold);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ItemQuantity> items,  List<ToolCategory> toolChoice,  int gold)  $default,) {final _that = this;
switch (_that) {
case _StartingEquipmentOption():
return $default(_that.items,_that.toolChoice,_that.gold);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ItemQuantity> items,  List<ToolCategory> toolChoice,  int gold)?  $default,) {final _that = this;
switch (_that) {
case _StartingEquipmentOption() when $default != null:
return $default(_that.items,_that.toolChoice,_that.gold);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StartingEquipmentOption implements StartingEquipmentOption {
  const _StartingEquipmentOption({ List<ItemQuantity> items = const <ItemQuantity>[],  List<ToolCategory> toolChoice = const <ToolCategory>[], required this.gold}): _items = items,_toolChoice = toolChoice;
  factory _StartingEquipmentOption.fromJson(Map<String, dynamic> json) => _$StartingEquipmentOptionFromJson(json);

 final  List<ItemQuantity> _items;
@override@JsonKey() List<ItemQuantity> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Un outil à choisir parmi ces catégories (« instrument de musique de
/// votre choix »).
 final  List<ToolCategory> _toolChoice;
/// Un outil à choisir parmi ces catégories (« instrument de musique de
/// votre choix »).
@override@JsonKey() List<ToolCategory> get toolChoice {
  if (_toolChoice is EqualUnmodifiableListView) return _toolChoice;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_toolChoice);
}

/// Pièces d'or.
@override final  int gold;

/// Create a copy of StartingEquipmentOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartingEquipmentOptionCopyWith<_StartingEquipmentOption> get copyWith => __$StartingEquipmentOptionCopyWithImpl<_StartingEquipmentOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StartingEquipmentOptionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StartingEquipmentOption&&const DeepCollectionEquality().equals(other.items, _items)&&const DeepCollectionEquality().equals(other.toolChoice, _toolChoice)&&(identical(other.gold, gold) || other.gold == gold));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_toolChoice),gold);
}

@override
String toString() {
    return 'StartingEquipmentOption(items: $items, toolChoice: $toolChoice, gold: $gold)';
}


}

/// @nodoc
abstract mixin class _$StartingEquipmentOptionCopyWith<$Res> implements $StartingEquipmentOptionCopyWith<$Res> {
  factory _$StartingEquipmentOptionCopyWith(_StartingEquipmentOption value, $Res Function(_StartingEquipmentOption) _then) = __$StartingEquipmentOptionCopyWithImpl;
@override @useResult
$Res call({
 List<ItemQuantity> items, List<ToolCategory> toolChoice, int gold
});




}
/// @nodoc
class __$StartingEquipmentOptionCopyWithImpl<$Res>
    implements _$StartingEquipmentOptionCopyWith<$Res> {
  __$StartingEquipmentOptionCopyWithImpl(this._self, this._then);

  final _StartingEquipmentOption _self;
  final $Res Function(_StartingEquipmentOption) _then;

/// Create a copy of StartingEquipmentOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? toolChoice = null,Object? gold = null,}) {
  return _then(_StartingEquipmentOption(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ItemQuantity>,toolChoice: null == toolChoice ? _self._toolChoice : toolChoice // ignore: cast_nullable_to_non_nullable
as List<ToolCategory>,gold: null == gold ? _self.gold : gold // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BackgroundData {

@ContentIdConverter() List<ContentId> get abilities;@ContentIdConverter() ContentId get originFeat;/// Sous-choix imposé du don d'origine, ex. `{"spell_list": "cleric"}`.
 Map<String, String>? get originFeatChoices;@ContentIdConverter() List<ContentId> get skillProficiencies;@ContentIdConverter() ContentId? get toolProficiency; ToolCategory? get toolChoiceCategory; List<ItemQuantity> get equipmentA; int get goldA; int get goldB;
/// Create a copy of BackgroundData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackgroundDataCopyWith<BackgroundData> get copyWith => _$BackgroundDataCopyWithImpl<BackgroundData>(this as BackgroundData, _$identity);

  /// Serializes this BackgroundData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BackgroundData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackgroundData&&const DeepCollectionEquality().equals(other.abilities, _this.abilities)&&(identical(other.originFeat, _this.originFeat) || other.originFeat == _this.originFeat)&&const DeepCollectionEquality().equals(other.originFeatChoices, _this.originFeatChoices)&&const DeepCollectionEquality().equals(other.skillProficiencies, _this.skillProficiencies)&&(identical(other.toolProficiency, _this.toolProficiency) || other.toolProficiency == _this.toolProficiency)&&(identical(other.toolChoiceCategory, _this.toolChoiceCategory) || other.toolChoiceCategory == _this.toolChoiceCategory)&&const DeepCollectionEquality().equals(other.equipmentA, _this.equipmentA)&&(identical(other.goldA, _this.goldA) || other.goldA == _this.goldA)&&(identical(other.goldB, _this.goldB) || other.goldB == _this.goldB));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BackgroundData;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.abilities),_this.originFeat,const DeepCollectionEquality().hash(_this.originFeatChoices),const DeepCollectionEquality().hash(_this.skillProficiencies),_this.toolProficiency,_this.toolChoiceCategory,const DeepCollectionEquality().hash(_this.equipmentA),_this.goldA,_this.goldB);
}

@override
String toString() {
  final _this = this as BackgroundData;
  return 'BackgroundData(abilities: ${_this.abilities}, originFeat: ${_this.originFeat}, originFeatChoices: ${_this.originFeatChoices}, skillProficiencies: ${_this.skillProficiencies}, toolProficiency: ${_this.toolProficiency}, toolChoiceCategory: ${_this.toolChoiceCategory}, equipmentA: ${_this.equipmentA}, goldA: ${_this.goldA}, goldB: ${_this.goldB})';
}


}

/// @nodoc
abstract mixin class $BackgroundDataCopyWith<$Res>  {
  factory $BackgroundDataCopyWith(BackgroundData value, $Res Function(BackgroundData) _then) = _$BackgroundDataCopyWithImpl;
@useResult
$Res call({
@ContentIdConverter() List<ContentId> abilities,@ContentIdConverter() ContentId originFeat, Map<String, String>? originFeatChoices,@ContentIdConverter() List<ContentId> skillProficiencies,@ContentIdConverter() ContentId? toolProficiency, ToolCategory? toolChoiceCategory, List<ItemQuantity> equipmentA, int goldA, int goldB
});




}
/// @nodoc
class _$BackgroundDataCopyWithImpl<$Res>
    implements $BackgroundDataCopyWith<$Res> {
  _$BackgroundDataCopyWithImpl(this._self, this._then);

  final BackgroundData _self;
  final $Res Function(BackgroundData) _then;

/// Create a copy of BackgroundData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? abilities = null,Object? originFeat = null,Object? originFeatChoices = freezed,Object? skillProficiencies = null,Object? toolProficiency = freezed,Object? toolChoiceCategory = freezed,Object? equipmentA = null,Object? goldA = null,Object? goldB = null,}) {
  return _then(BackgroundData(
abilities: null == abilities ? _self.abilities : abilities // ignore: cast_nullable_to_non_nullable
as List<ContentId>,originFeat: null == originFeat ? _self.originFeat : originFeat // ignore: cast_nullable_to_non_nullable
as ContentId,originFeatChoices: freezed == originFeatChoices ? _self.originFeatChoices : originFeatChoices // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,skillProficiencies: null == skillProficiencies ? _self.skillProficiencies : skillProficiencies // ignore: cast_nullable_to_non_nullable
as List<ContentId>,toolProficiency: freezed == toolProficiency ? _self.toolProficiency : toolProficiency // ignore: cast_nullable_to_non_nullable
as ContentId?,toolChoiceCategory: freezed == toolChoiceCategory ? _self.toolChoiceCategory : toolChoiceCategory // ignore: cast_nullable_to_non_nullable
as ToolCategory?,equipmentA: null == equipmentA ? _self.equipmentA : equipmentA // ignore: cast_nullable_to_non_nullable
as List<ItemQuantity>,goldA: null == goldA ? _self.goldA : goldA // ignore: cast_nullable_to_non_nullable
as int,goldB: null == goldB ? _self.goldB : goldB // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BackgroundData].
extension BackgroundDataPatterns on BackgroundData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackgroundData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackgroundData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackgroundData value)  $default,){
final _that = this;
switch (_that) {
case _BackgroundData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackgroundData value)?  $default,){
final _that = this;
switch (_that) {
case _BackgroundData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@ContentIdConverter()  List<ContentId> abilities, @ContentIdConverter()  ContentId originFeat,  Map<String, String>? originFeatChoices, @ContentIdConverter()  List<ContentId> skillProficiencies, @ContentIdConverter()  ContentId? toolProficiency,  ToolCategory? toolChoiceCategory,  List<ItemQuantity> equipmentA,  int goldA,  int goldB)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackgroundData() when $default != null:
return $default(_that.abilities,_that.originFeat,_that.originFeatChoices,_that.skillProficiencies,_that.toolProficiency,_that.toolChoiceCategory,_that.equipmentA,_that.goldA,_that.goldB);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@ContentIdConverter()  List<ContentId> abilities, @ContentIdConverter()  ContentId originFeat,  Map<String, String>? originFeatChoices, @ContentIdConverter()  List<ContentId> skillProficiencies, @ContentIdConverter()  ContentId? toolProficiency,  ToolCategory? toolChoiceCategory,  List<ItemQuantity> equipmentA,  int goldA,  int goldB)  $default,) {final _that = this;
switch (_that) {
case _BackgroundData():
return $default(_that.abilities,_that.originFeat,_that.originFeatChoices,_that.skillProficiencies,_that.toolProficiency,_that.toolChoiceCategory,_that.equipmentA,_that.goldA,_that.goldB);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@ContentIdConverter()  List<ContentId> abilities, @ContentIdConverter()  ContentId originFeat,  Map<String, String>? originFeatChoices, @ContentIdConverter()  List<ContentId> skillProficiencies, @ContentIdConverter()  ContentId? toolProficiency,  ToolCategory? toolChoiceCategory,  List<ItemQuantity> equipmentA,  int goldA,  int goldB)?  $default,) {final _that = this;
switch (_that) {
case _BackgroundData() when $default != null:
return $default(_that.abilities,_that.originFeat,_that.originFeatChoices,_that.skillProficiencies,_that.toolProficiency,_that.toolChoiceCategory,_that.equipmentA,_that.goldA,_that.goldB);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackgroundData implements BackgroundData {
  const _BackgroundData({@ContentIdConverter() required  List<ContentId> abilities, @ContentIdConverter() required this.originFeat,  Map<String, String>? originFeatChoices, @ContentIdConverter() required  List<ContentId> skillProficiencies, @ContentIdConverter() this.toolProficiency, this.toolChoiceCategory, required  List<ItemQuantity> equipmentA, required this.goldA, required this.goldB}): _abilities = abilities,_originFeatChoices = originFeatChoices,_skillProficiencies = skillProficiencies,_equipmentA = equipmentA;
  factory _BackgroundData.fromJson(Map<String, dynamic> json) => _$BackgroundDataFromJson(json);

 final  List<ContentId> _abilities;
@override@ContentIdConverter() List<ContentId> get abilities {
  if (_abilities is EqualUnmodifiableListView) return _abilities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_abilities);
}

@override@ContentIdConverter() final  ContentId originFeat;
/// Sous-choix imposé du don d'origine, ex. `{"spell_list": "cleric"}`.
 final  Map<String, String>? _originFeatChoices;
/// Sous-choix imposé du don d'origine, ex. `{"spell_list": "cleric"}`.
@override Map<String, String>? get originFeatChoices {
  final value = _originFeatChoices;
  if (value == null) return null;
  if (_originFeatChoices is EqualUnmodifiableMapView) return _originFeatChoices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  List<ContentId> _skillProficiencies;
@override@ContentIdConverter() List<ContentId> get skillProficiencies {
  if (_skillProficiencies is EqualUnmodifiableListView) return _skillProficiencies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skillProficiencies);
}

@override@ContentIdConverter() final  ContentId? toolProficiency;
@override final  ToolCategory? toolChoiceCategory;
 final  List<ItemQuantity> _equipmentA;
@override List<ItemQuantity> get equipmentA {
  if (_equipmentA is EqualUnmodifiableListView) return _equipmentA;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_equipmentA);
}

@override final  int goldA;
@override final  int goldB;

/// Create a copy of BackgroundData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackgroundDataCopyWith<_BackgroundData> get copyWith => __$BackgroundDataCopyWithImpl<_BackgroundData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackgroundDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackgroundData&&const DeepCollectionEquality().equals(other.abilities, _abilities)&&(identical(other.originFeat, originFeat) || other.originFeat == originFeat)&&const DeepCollectionEquality().equals(other.originFeatChoices, _originFeatChoices)&&const DeepCollectionEquality().equals(other.skillProficiencies, _skillProficiencies)&&(identical(other.toolProficiency, toolProficiency) || other.toolProficiency == toolProficiency)&&(identical(other.toolChoiceCategory, toolChoiceCategory) || other.toolChoiceCategory == toolChoiceCategory)&&const DeepCollectionEquality().equals(other.equipmentA, _equipmentA)&&(identical(other.goldA, goldA) || other.goldA == goldA)&&(identical(other.goldB, goldB) || other.goldB == goldB));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_abilities),originFeat,const DeepCollectionEquality().hash(_originFeatChoices),const DeepCollectionEquality().hash(_skillProficiencies),toolProficiency,toolChoiceCategory,const DeepCollectionEquality().hash(_equipmentA),goldA,goldB);
}

@override
String toString() {
    return 'BackgroundData(abilities: $abilities, originFeat: $originFeat, originFeatChoices: $originFeatChoices, skillProficiencies: $skillProficiencies, toolProficiency: $toolProficiency, toolChoiceCategory: $toolChoiceCategory, equipmentA: $equipmentA, goldA: $goldA, goldB: $goldB)';
}


}

/// @nodoc
abstract mixin class _$BackgroundDataCopyWith<$Res> implements $BackgroundDataCopyWith<$Res> {
  factory _$BackgroundDataCopyWith(_BackgroundData value, $Res Function(_BackgroundData) _then) = __$BackgroundDataCopyWithImpl;
@override @useResult
$Res call({
@ContentIdConverter() List<ContentId> abilities,@ContentIdConverter() ContentId originFeat, Map<String, String>? originFeatChoices,@ContentIdConverter() List<ContentId> skillProficiencies,@ContentIdConverter() ContentId? toolProficiency, ToolCategory? toolChoiceCategory, List<ItemQuantity> equipmentA, int goldA, int goldB
});




}
/// @nodoc
class __$BackgroundDataCopyWithImpl<$Res>
    implements _$BackgroundDataCopyWith<$Res> {
  __$BackgroundDataCopyWithImpl(this._self, this._then);

  final _BackgroundData _self;
  final $Res Function(_BackgroundData) _then;

/// Create a copy of BackgroundData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? abilities = null,Object? originFeat = null,Object? originFeatChoices = freezed,Object? skillProficiencies = null,Object? toolProficiency = freezed,Object? toolChoiceCategory = freezed,Object? equipmentA = null,Object? goldA = null,Object? goldB = null,}) {
  return _then(_BackgroundData(
abilities: null == abilities ? _self._abilities : abilities // ignore: cast_nullable_to_non_nullable
as List<ContentId>,originFeat: null == originFeat ? _self.originFeat : originFeat // ignore: cast_nullable_to_non_nullable
as ContentId,originFeatChoices: freezed == originFeatChoices ? _self._originFeatChoices : originFeatChoices // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,skillProficiencies: null == skillProficiencies ? _self._skillProficiencies : skillProficiencies // ignore: cast_nullable_to_non_nullable
as List<ContentId>,toolProficiency: freezed == toolProficiency ? _self.toolProficiency : toolProficiency // ignore: cast_nullable_to_non_nullable
as ContentId?,toolChoiceCategory: freezed == toolChoiceCategory ? _self.toolChoiceCategory : toolChoiceCategory // ignore: cast_nullable_to_non_nullable
as ToolCategory?,equipmentA: null == equipmentA ? _self._equipmentA : equipmentA // ignore: cast_nullable_to_non_nullable
as List<ItemQuantity>,goldA: null == goldA ? _self.goldA : goldA // ignore: cast_nullable_to_non_nullable
as int,goldB: null == goldB ? _self.goldB : goldB // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SpeciesData {

 String get creatureType; List<String> get sizes; int get speedFeet;@ContentIdConverter() List<ContentId> get traits;
/// Create a copy of SpeciesData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeciesDataCopyWith<SpeciesData> get copyWith => _$SpeciesDataCopyWithImpl<SpeciesData>(this as SpeciesData, _$identity);

  /// Serializes this SpeciesData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SpeciesData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeciesData&&(identical(other.creatureType, _this.creatureType) || other.creatureType == _this.creatureType)&&const DeepCollectionEquality().equals(other.sizes, _this.sizes)&&(identical(other.speedFeet, _this.speedFeet) || other.speedFeet == _this.speedFeet)&&const DeepCollectionEquality().equals(other.traits, _this.traits));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SpeciesData;
  return Object.hash(runtimeType,_this.creatureType,const DeepCollectionEquality().hash(_this.sizes),_this.speedFeet,const DeepCollectionEquality().hash(_this.traits));
}

@override
String toString() {
  final _this = this as SpeciesData;
  return 'SpeciesData(creatureType: ${_this.creatureType}, sizes: ${_this.sizes}, speedFeet: ${_this.speedFeet}, traits: ${_this.traits})';
}


}

/// @nodoc
abstract mixin class $SpeciesDataCopyWith<$Res>  {
  factory $SpeciesDataCopyWith(SpeciesData value, $Res Function(SpeciesData) _then) = _$SpeciesDataCopyWithImpl;
@useResult
$Res call({
 String creatureType, List<String> sizes, int speedFeet,@ContentIdConverter() List<ContentId> traits
});




}
/// @nodoc
class _$SpeciesDataCopyWithImpl<$Res>
    implements $SpeciesDataCopyWith<$Res> {
  _$SpeciesDataCopyWithImpl(this._self, this._then);

  final SpeciesData _self;
  final $Res Function(SpeciesData) _then;

/// Create a copy of SpeciesData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? creatureType = null,Object? sizes = null,Object? speedFeet = null,Object? traits = null,}) {
  return _then(SpeciesData(
creatureType: null == creatureType ? _self.creatureType : creatureType // ignore: cast_nullable_to_non_nullable
as String,sizes: null == sizes ? _self.sizes : sizes // ignore: cast_nullable_to_non_nullable
as List<String>,speedFeet: null == speedFeet ? _self.speedFeet : speedFeet // ignore: cast_nullable_to_non_nullable
as int,traits: null == traits ? _self.traits : traits // ignore: cast_nullable_to_non_nullable
as List<ContentId>,
  ));
}

}


/// Adds pattern-matching-related methods to [SpeciesData].
extension SpeciesDataPatterns on SpeciesData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeciesData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeciesData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeciesData value)  $default,){
final _that = this;
switch (_that) {
case _SpeciesData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeciesData value)?  $default,){
final _that = this;
switch (_that) {
case _SpeciesData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String creatureType,  List<String> sizes,  int speedFeet, @ContentIdConverter()  List<ContentId> traits)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeciesData() when $default != null:
return $default(_that.creatureType,_that.sizes,_that.speedFeet,_that.traits);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String creatureType,  List<String> sizes,  int speedFeet, @ContentIdConverter()  List<ContentId> traits)  $default,) {final _that = this;
switch (_that) {
case _SpeciesData():
return $default(_that.creatureType,_that.sizes,_that.speedFeet,_that.traits);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String creatureType,  List<String> sizes,  int speedFeet, @ContentIdConverter()  List<ContentId> traits)?  $default,) {final _that = this;
switch (_that) {
case _SpeciesData() when $default != null:
return $default(_that.creatureType,_that.sizes,_that.speedFeet,_that.traits);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpeciesData implements SpeciesData {
  const _SpeciesData({required this.creatureType, required  List<String> sizes, required this.speedFeet, @ContentIdConverter() required  List<ContentId> traits}): _sizes = sizes,_traits = traits;
  factory _SpeciesData.fromJson(Map<String, dynamic> json) => _$SpeciesDataFromJson(json);

@override final  String creatureType;
 final  List<String> _sizes;
@override List<String> get sizes {
  if (_sizes is EqualUnmodifiableListView) return _sizes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sizes);
}

@override final  int speedFeet;
 final  List<ContentId> _traits;
@override@ContentIdConverter() List<ContentId> get traits {
  if (_traits is EqualUnmodifiableListView) return _traits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_traits);
}


/// Create a copy of SpeciesData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeciesDataCopyWith<_SpeciesData> get copyWith => __$SpeciesDataCopyWithImpl<_SpeciesData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpeciesDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeciesData&&(identical(other.creatureType, creatureType) || other.creatureType == creatureType)&&const DeepCollectionEquality().equals(other.sizes, _sizes)&&(identical(other.speedFeet, speedFeet) || other.speedFeet == speedFeet)&&const DeepCollectionEquality().equals(other.traits, _traits));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,creatureType,const DeepCollectionEquality().hash(_sizes),speedFeet,const DeepCollectionEquality().hash(_traits));
}

@override
String toString() {
    return 'SpeciesData(creatureType: $creatureType, sizes: $sizes, speedFeet: $speedFeet, traits: $traits)';
}


}

/// @nodoc
abstract mixin class _$SpeciesDataCopyWith<$Res> implements $SpeciesDataCopyWith<$Res> {
  factory _$SpeciesDataCopyWith(_SpeciesData value, $Res Function(_SpeciesData) _then) = __$SpeciesDataCopyWithImpl;
@override @useResult
$Res call({
 String creatureType, List<String> sizes, int speedFeet,@ContentIdConverter() List<ContentId> traits
});




}
/// @nodoc
class __$SpeciesDataCopyWithImpl<$Res>
    implements _$SpeciesDataCopyWith<$Res> {
  __$SpeciesDataCopyWithImpl(this._self, this._then);

  final _SpeciesData _self;
  final $Res Function(_SpeciesData) _then;

/// Create a copy of SpeciesData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? creatureType = null,Object? sizes = null,Object? speedFeet = null,Object? traits = null,}) {
  return _then(_SpeciesData(
creatureType: null == creatureType ? _self.creatureType : creatureType // ignore: cast_nullable_to_non_nullable
as String,sizes: null == sizes ? _self._sizes : sizes // ignore: cast_nullable_to_non_nullable
as List<String>,speedFeet: null == speedFeet ? _self.speedFeet : speedFeet // ignore: cast_nullable_to_non_nullable
as int,traits: null == traits ? _self._traits : traits // ignore: cast_nullable_to_non_nullable
as List<ContentId>,
  ));
}


}


/// @nodoc
mixin _$FeatPrerequisites {

 int? get minLevel;/// Au moins une de ces valeurs minimales, ex. `{"str": 13, "dex": 13}`.
 Map<String, int>? get abilityMinAny;/// Aptitude requise : `fighting_style` ou `spellcasting`.
 String? get feature;
/// Create a copy of FeatPrerequisites
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeatPrerequisitesCopyWith<FeatPrerequisites> get copyWith => _$FeatPrerequisitesCopyWithImpl<FeatPrerequisites>(this as FeatPrerequisites, _$identity);

  /// Serializes this FeatPrerequisites to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FeatPrerequisites;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeatPrerequisites&&(identical(other.minLevel, _this.minLevel) || other.minLevel == _this.minLevel)&&const DeepCollectionEquality().equals(other.abilityMinAny, _this.abilityMinAny)&&(identical(other.feature, _this.feature) || other.feature == _this.feature));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FeatPrerequisites;
  return Object.hash(runtimeType,_this.minLevel,const DeepCollectionEquality().hash(_this.abilityMinAny),_this.feature);
}

@override
String toString() {
  final _this = this as FeatPrerequisites;
  return 'FeatPrerequisites(minLevel: ${_this.minLevel}, abilityMinAny: ${_this.abilityMinAny}, feature: ${_this.feature})';
}


}

/// @nodoc
abstract mixin class $FeatPrerequisitesCopyWith<$Res>  {
  factory $FeatPrerequisitesCopyWith(FeatPrerequisites value, $Res Function(FeatPrerequisites) _then) = _$FeatPrerequisitesCopyWithImpl;
@useResult
$Res call({
 int? minLevel, Map<String, int>? abilityMinAny, String? feature
});




}
/// @nodoc
class _$FeatPrerequisitesCopyWithImpl<$Res>
    implements $FeatPrerequisitesCopyWith<$Res> {
  _$FeatPrerequisitesCopyWithImpl(this._self, this._then);

  final FeatPrerequisites _self;
  final $Res Function(FeatPrerequisites) _then;

/// Create a copy of FeatPrerequisites
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? minLevel = freezed,Object? abilityMinAny = freezed,Object? feature = freezed,}) {
  return _then(FeatPrerequisites(
minLevel: freezed == minLevel ? _self.minLevel : minLevel // ignore: cast_nullable_to_non_nullable
as int?,abilityMinAny: freezed == abilityMinAny ? _self.abilityMinAny : abilityMinAny // ignore: cast_nullable_to_non_nullable
as Map<String, int>?,feature: freezed == feature ? _self.feature : feature // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FeatPrerequisites].
extension FeatPrerequisitesPatterns on FeatPrerequisites {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeatPrerequisites value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeatPrerequisites() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeatPrerequisites value)  $default,){
final _that = this;
switch (_that) {
case _FeatPrerequisites():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeatPrerequisites value)?  $default,){
final _that = this;
switch (_that) {
case _FeatPrerequisites() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? minLevel,  Map<String, int>? abilityMinAny,  String? feature)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeatPrerequisites() when $default != null:
return $default(_that.minLevel,_that.abilityMinAny,_that.feature);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? minLevel,  Map<String, int>? abilityMinAny,  String? feature)  $default,) {final _that = this;
switch (_that) {
case _FeatPrerequisites():
return $default(_that.minLevel,_that.abilityMinAny,_that.feature);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? minLevel,  Map<String, int>? abilityMinAny,  String? feature)?  $default,) {final _that = this;
switch (_that) {
case _FeatPrerequisites() when $default != null:
return $default(_that.minLevel,_that.abilityMinAny,_that.feature);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeatPrerequisites implements FeatPrerequisites {
  const _FeatPrerequisites({this.minLevel,  Map<String, int>? abilityMinAny, this.feature}): _abilityMinAny = abilityMinAny;
  factory _FeatPrerequisites.fromJson(Map<String, dynamic> json) => _$FeatPrerequisitesFromJson(json);

@override final  int? minLevel;
/// Au moins une de ces valeurs minimales, ex. `{"str": 13, "dex": 13}`.
 final  Map<String, int>? _abilityMinAny;
/// Au moins une de ces valeurs minimales, ex. `{"str": 13, "dex": 13}`.
@override Map<String, int>? get abilityMinAny {
  final value = _abilityMinAny;
  if (value == null) return null;
  if (_abilityMinAny is EqualUnmodifiableMapView) return _abilityMinAny;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

/// Aptitude requise : `fighting_style` ou `spellcasting`.
@override final  String? feature;

/// Create a copy of FeatPrerequisites
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeatPrerequisitesCopyWith<_FeatPrerequisites> get copyWith => __$FeatPrerequisitesCopyWithImpl<_FeatPrerequisites>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeatPrerequisitesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeatPrerequisites&&(identical(other.minLevel, minLevel) || other.minLevel == minLevel)&&const DeepCollectionEquality().equals(other.abilityMinAny, _abilityMinAny)&&(identical(other.feature, feature) || other.feature == feature));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,minLevel,const DeepCollectionEquality().hash(_abilityMinAny),feature);
}

@override
String toString() {
    return 'FeatPrerequisites(minLevel: $minLevel, abilityMinAny: $abilityMinAny, feature: $feature)';
}


}

/// @nodoc
abstract mixin class _$FeatPrerequisitesCopyWith<$Res> implements $FeatPrerequisitesCopyWith<$Res> {
  factory _$FeatPrerequisitesCopyWith(_FeatPrerequisites value, $Res Function(_FeatPrerequisites) _then) = __$FeatPrerequisitesCopyWithImpl;
@override @useResult
$Res call({
 int? minLevel, Map<String, int>? abilityMinAny, String? feature
});




}
/// @nodoc
class __$FeatPrerequisitesCopyWithImpl<$Res>
    implements _$FeatPrerequisitesCopyWith<$Res> {
  __$FeatPrerequisitesCopyWithImpl(this._self, this._then);

  final _FeatPrerequisites _self;
  final $Res Function(_FeatPrerequisites) _then;

/// Create a copy of FeatPrerequisites
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? minLevel = freezed,Object? abilityMinAny = freezed,Object? feature = freezed,}) {
  return _then(_FeatPrerequisites(
minLevel: freezed == minLevel ? _self.minLevel : minLevel // ignore: cast_nullable_to_non_nullable
as int?,abilityMinAny: freezed == abilityMinAny ? _self._abilityMinAny : abilityMinAny // ignore: cast_nullable_to_non_nullable
as Map<String, int>?,feature: freezed == feature ? _self.feature : feature // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$FeatData {

 FeatCategory get category; FeatPrerequisites? get prerequisites; bool get repeatable;
/// Create a copy of FeatData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeatDataCopyWith<FeatData> get copyWith => _$FeatDataCopyWithImpl<FeatData>(this as FeatData, _$identity);

  /// Serializes this FeatData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FeatData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeatData&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.prerequisites, _this.prerequisites) || other.prerequisites == _this.prerequisites)&&(identical(other.repeatable, _this.repeatable) || other.repeatable == _this.repeatable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FeatData;
  return Object.hash(runtimeType,_this.category,_this.prerequisites,_this.repeatable);
}

@override
String toString() {
  final _this = this as FeatData;
  return 'FeatData(category: ${_this.category}, prerequisites: ${_this.prerequisites}, repeatable: ${_this.repeatable})';
}


}

/// @nodoc
abstract mixin class $FeatDataCopyWith<$Res>  {
  factory $FeatDataCopyWith(FeatData value, $Res Function(FeatData) _then) = _$FeatDataCopyWithImpl;
@useResult
$Res call({
 FeatCategory category, FeatPrerequisites? prerequisites, bool repeatable
});


$FeatPrerequisitesCopyWith<$Res>? get prerequisites;

}
/// @nodoc
class _$FeatDataCopyWithImpl<$Res>
    implements $FeatDataCopyWith<$Res> {
  _$FeatDataCopyWithImpl(this._self, this._then);

  final FeatData _self;
  final $Res Function(FeatData) _then;

/// Create a copy of FeatData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? prerequisites = freezed,Object? repeatable = null,}) {
  return _then(FeatData(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as FeatCategory,prerequisites: freezed == prerequisites ? _self.prerequisites : prerequisites // ignore: cast_nullable_to_non_nullable
as FeatPrerequisites?,repeatable: null == repeatable ? _self.repeatable : repeatable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of FeatData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeatPrerequisitesCopyWith<$Res>? get prerequisites {
    if (_self.prerequisites == null) {
    return null;
  }

  return $FeatPrerequisitesCopyWith<$Res>(_self.prerequisites!, (value) {
    return _then(_self.copyWith(prerequisites: value));
  });
}
}


/// Adds pattern-matching-related methods to [FeatData].
extension FeatDataPatterns on FeatData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeatData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeatData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeatData value)  $default,){
final _that = this;
switch (_that) {
case _FeatData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeatData value)?  $default,){
final _that = this;
switch (_that) {
case _FeatData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FeatCategory category,  FeatPrerequisites? prerequisites,  bool repeatable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeatData() when $default != null:
return $default(_that.category,_that.prerequisites,_that.repeatable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FeatCategory category,  FeatPrerequisites? prerequisites,  bool repeatable)  $default,) {final _that = this;
switch (_that) {
case _FeatData():
return $default(_that.category,_that.prerequisites,_that.repeatable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FeatCategory category,  FeatPrerequisites? prerequisites,  bool repeatable)?  $default,) {final _that = this;
switch (_that) {
case _FeatData() when $default != null:
return $default(_that.category,_that.prerequisites,_that.repeatable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeatData implements FeatData {
  const _FeatData({required this.category, this.prerequisites, this.repeatable = false});
  factory _FeatData.fromJson(Map<String, dynamic> json) => _$FeatDataFromJson(json);

@override final  FeatCategory category;
@override final  FeatPrerequisites? prerequisites;
@override@JsonKey() final  bool repeatable;

/// Create a copy of FeatData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeatDataCopyWith<_FeatData> get copyWith => __$FeatDataCopyWithImpl<_FeatData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeatDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeatData&&(identical(other.category, category) || other.category == category)&&(identical(other.prerequisites, prerequisites) || other.prerequisites == prerequisites)&&(identical(other.repeatable, repeatable) || other.repeatable == repeatable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,category,prerequisites,repeatable);
}

@override
String toString() {
    return 'FeatData(category: $category, prerequisites: $prerequisites, repeatable: $repeatable)';
}


}

/// @nodoc
abstract mixin class _$FeatDataCopyWith<$Res> implements $FeatDataCopyWith<$Res> {
  factory _$FeatDataCopyWith(_FeatData value, $Res Function(_FeatData) _then) = __$FeatDataCopyWithImpl;
@override @useResult
$Res call({
 FeatCategory category, FeatPrerequisites? prerequisites, bool repeatable
});


@override $FeatPrerequisitesCopyWith<$Res>? get prerequisites;

}
/// @nodoc
class __$FeatDataCopyWithImpl<$Res>
    implements _$FeatDataCopyWith<$Res> {
  __$FeatDataCopyWithImpl(this._self, this._then);

  final _FeatData _self;
  final $Res Function(_FeatData) _then;

/// Create a copy of FeatData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? prerequisites = freezed,Object? repeatable = null,}) {
  return _then(_FeatData(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as FeatCategory,prerequisites: freezed == prerequisites ? _self.prerequisites : prerequisites // ignore: cast_nullable_to_non_nullable
as FeatPrerequisites?,repeatable: null == repeatable ? _self.repeatable : repeatable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of FeatData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeatPrerequisitesCopyWith<$Res>? get prerequisites {
    if (_self.prerequisites == null) {
    return null;
  }

  return $FeatPrerequisitesCopyWith<$Res>(_self.prerequisites!, (value) {
    return _then(_self.copyWith(prerequisites: value));
  });
}
}


/// @nodoc
mixin _$ClassLevelData {

 int get level; int get proficiencyBonus;@ContentIdConverter() List<ContentId> get features;/// Colonnes propres à la classe, ex. `second_wind`, `weapon_mastery`.
 Map<String, int> get columns;
/// Create a copy of ClassLevelData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassLevelDataCopyWith<ClassLevelData> get copyWith => _$ClassLevelDataCopyWithImpl<ClassLevelData>(this as ClassLevelData, _$identity);

  /// Serializes this ClassLevelData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ClassLevelData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassLevelData&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.proficiencyBonus, _this.proficiencyBonus) || other.proficiencyBonus == _this.proficiencyBonus)&&const DeepCollectionEquality().equals(other.features, _this.features)&&const DeepCollectionEquality().equals(other.columns, _this.columns));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ClassLevelData;
  return Object.hash(runtimeType,_this.level,_this.proficiencyBonus,const DeepCollectionEquality().hash(_this.features),const DeepCollectionEquality().hash(_this.columns));
}

@override
String toString() {
  final _this = this as ClassLevelData;
  return 'ClassLevelData(level: ${_this.level}, proficiencyBonus: ${_this.proficiencyBonus}, features: ${_this.features}, columns: ${_this.columns})';
}


}

/// @nodoc
abstract mixin class $ClassLevelDataCopyWith<$Res>  {
  factory $ClassLevelDataCopyWith(ClassLevelData value, $Res Function(ClassLevelData) _then) = _$ClassLevelDataCopyWithImpl;
@useResult
$Res call({
 int level, int proficiencyBonus,@ContentIdConverter() List<ContentId> features, Map<String, int> columns
});




}
/// @nodoc
class _$ClassLevelDataCopyWithImpl<$Res>
    implements $ClassLevelDataCopyWith<$Res> {
  _$ClassLevelDataCopyWithImpl(this._self, this._then);

  final ClassLevelData _self;
  final $Res Function(ClassLevelData) _then;

/// Create a copy of ClassLevelData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? proficiencyBonus = null,Object? features = null,Object? columns = null,}) {
  return _then(ClassLevelData(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,proficiencyBonus: null == proficiencyBonus ? _self.proficiencyBonus : proficiencyBonus // ignore: cast_nullable_to_non_nullable
as int,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as List<ContentId>,columns: null == columns ? _self.columns : columns // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [ClassLevelData].
extension ClassLevelDataPatterns on ClassLevelData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClassLevelData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClassLevelData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClassLevelData value)  $default,){
final _that = this;
switch (_that) {
case _ClassLevelData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClassLevelData value)?  $default,){
final _that = this;
switch (_that) {
case _ClassLevelData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int level,  int proficiencyBonus, @ContentIdConverter()  List<ContentId> features,  Map<String, int> columns)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClassLevelData() when $default != null:
return $default(_that.level,_that.proficiencyBonus,_that.features,_that.columns);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int level,  int proficiencyBonus, @ContentIdConverter()  List<ContentId> features,  Map<String, int> columns)  $default,) {final _that = this;
switch (_that) {
case _ClassLevelData():
return $default(_that.level,_that.proficiencyBonus,_that.features,_that.columns);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int level,  int proficiencyBonus, @ContentIdConverter()  List<ContentId> features,  Map<String, int> columns)?  $default,) {final _that = this;
switch (_that) {
case _ClassLevelData() when $default != null:
return $default(_that.level,_that.proficiencyBonus,_that.features,_that.columns);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClassLevelData implements ClassLevelData {
  const _ClassLevelData({required this.level, required this.proficiencyBonus, @ContentIdConverter()  List<ContentId> features = const <ContentId>[],  Map<String, int> columns = const <String, int>{}}): _features = features,_columns = columns;
  factory _ClassLevelData.fromJson(Map<String, dynamic> json) => _$ClassLevelDataFromJson(json);

@override final  int level;
@override final  int proficiencyBonus;
 final  List<ContentId> _features;
@override@JsonKey()@ContentIdConverter() List<ContentId> get features {
  if (_features is EqualUnmodifiableListView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_features);
}

/// Colonnes propres à la classe, ex. `second_wind`, `weapon_mastery`.
 final  Map<String, int> _columns;
/// Colonnes propres à la classe, ex. `second_wind`, `weapon_mastery`.
@override@JsonKey() Map<String, int> get columns {
  if (_columns is EqualUnmodifiableMapView) return _columns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_columns);
}


/// Create a copy of ClassLevelData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassLevelDataCopyWith<_ClassLevelData> get copyWith => __$ClassLevelDataCopyWithImpl<_ClassLevelData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClassLevelDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassLevelData&&(identical(other.level, level) || other.level == level)&&(identical(other.proficiencyBonus, proficiencyBonus) || other.proficiencyBonus == proficiencyBonus)&&const DeepCollectionEquality().equals(other.features, _features)&&const DeepCollectionEquality().equals(other.columns, _columns));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,level,proficiencyBonus,const DeepCollectionEquality().hash(_features),const DeepCollectionEquality().hash(_columns));
}

@override
String toString() {
    return 'ClassLevelData(level: $level, proficiencyBonus: $proficiencyBonus, features: $features, columns: $columns)';
}


}

/// @nodoc
abstract mixin class _$ClassLevelDataCopyWith<$Res> implements $ClassLevelDataCopyWith<$Res> {
  factory _$ClassLevelDataCopyWith(_ClassLevelData value, $Res Function(_ClassLevelData) _then) = __$ClassLevelDataCopyWithImpl;
@override @useResult
$Res call({
 int level, int proficiencyBonus,@ContentIdConverter() List<ContentId> features, Map<String, int> columns
});




}
/// @nodoc
class __$ClassLevelDataCopyWithImpl<$Res>
    implements _$ClassLevelDataCopyWith<$Res> {
  __$ClassLevelDataCopyWithImpl(this._self, this._then);

  final _ClassLevelData _self;
  final $Res Function(_ClassLevelData) _then;

/// Create a copy of ClassLevelData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? proficiencyBonus = null,Object? features = null,Object? columns = null,}) {
  return _then(_ClassLevelData(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,proficiencyBonus: null == proficiencyBonus ? _self.proficiencyBonus : proficiencyBonus // ignore: cast_nullable_to_non_nullable
as int,features: null == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as List<ContentId>,columns: null == columns ? _self._columns : columns // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}


/// @nodoc
mixin _$MulticlassTraits {

 List<String> get weaponProficiencies; List<String> get armorTraining;@ContentIdConverter() List<ContentId> get toolProficiencies;/// Compétences à choisir dans celles de la classe.
 int get skillChoiceCount;/// Outils à choisir dans la catégorie de la classe.
 int get toolChoiceCount;/// Part des niveaux de la classe dans le niveau de lanceur : 1 pour tous,
/// 2 pour la moitié, 0 si elle n'y compte pas (SRD p. 27).
 int get casterDivisor;
/// Create a copy of MulticlassTraits
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MulticlassTraitsCopyWith<MulticlassTraits> get copyWith => _$MulticlassTraitsCopyWithImpl<MulticlassTraits>(this as MulticlassTraits, _$identity);

  /// Serializes this MulticlassTraits to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MulticlassTraits;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MulticlassTraits&&const DeepCollectionEquality().equals(other.weaponProficiencies, _this.weaponProficiencies)&&const DeepCollectionEquality().equals(other.armorTraining, _this.armorTraining)&&const DeepCollectionEquality().equals(other.toolProficiencies, _this.toolProficiencies)&&(identical(other.skillChoiceCount, _this.skillChoiceCount) || other.skillChoiceCount == _this.skillChoiceCount)&&(identical(other.toolChoiceCount, _this.toolChoiceCount) || other.toolChoiceCount == _this.toolChoiceCount)&&(identical(other.casterDivisor, _this.casterDivisor) || other.casterDivisor == _this.casterDivisor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MulticlassTraits;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.weaponProficiencies),const DeepCollectionEquality().hash(_this.armorTraining),const DeepCollectionEquality().hash(_this.toolProficiencies),_this.skillChoiceCount,_this.toolChoiceCount,_this.casterDivisor);
}

@override
String toString() {
  final _this = this as MulticlassTraits;
  return 'MulticlassTraits(weaponProficiencies: ${_this.weaponProficiencies}, armorTraining: ${_this.armorTraining}, toolProficiencies: ${_this.toolProficiencies}, skillChoiceCount: ${_this.skillChoiceCount}, toolChoiceCount: ${_this.toolChoiceCount}, casterDivisor: ${_this.casterDivisor})';
}


}

/// @nodoc
abstract mixin class $MulticlassTraitsCopyWith<$Res>  {
  factory $MulticlassTraitsCopyWith(MulticlassTraits value, $Res Function(MulticlassTraits) _then) = _$MulticlassTraitsCopyWithImpl;
@useResult
$Res call({
 List<String> weaponProficiencies, List<String> armorTraining,@ContentIdConverter() List<ContentId> toolProficiencies, int skillChoiceCount, int toolChoiceCount, int casterDivisor
});




}
/// @nodoc
class _$MulticlassTraitsCopyWithImpl<$Res>
    implements $MulticlassTraitsCopyWith<$Res> {
  _$MulticlassTraitsCopyWithImpl(this._self, this._then);

  final MulticlassTraits _self;
  final $Res Function(MulticlassTraits) _then;

/// Create a copy of MulticlassTraits
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weaponProficiencies = null,Object? armorTraining = null,Object? toolProficiencies = null,Object? skillChoiceCount = null,Object? toolChoiceCount = null,Object? casterDivisor = null,}) {
  return _then(MulticlassTraits(
weaponProficiencies: null == weaponProficiencies ? _self.weaponProficiencies : weaponProficiencies // ignore: cast_nullable_to_non_nullable
as List<String>,armorTraining: null == armorTraining ? _self.armorTraining : armorTraining // ignore: cast_nullable_to_non_nullable
as List<String>,toolProficiencies: null == toolProficiencies ? _self.toolProficiencies : toolProficiencies // ignore: cast_nullable_to_non_nullable
as List<ContentId>,skillChoiceCount: null == skillChoiceCount ? _self.skillChoiceCount : skillChoiceCount // ignore: cast_nullable_to_non_nullable
as int,toolChoiceCount: null == toolChoiceCount ? _self.toolChoiceCount : toolChoiceCount // ignore: cast_nullable_to_non_nullable
as int,casterDivisor: null == casterDivisor ? _self.casterDivisor : casterDivisor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MulticlassTraits].
extension MulticlassTraitsPatterns on MulticlassTraits {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MulticlassTraits value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MulticlassTraits() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MulticlassTraits value)  $default,){
final _that = this;
switch (_that) {
case _MulticlassTraits():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MulticlassTraits value)?  $default,){
final _that = this;
switch (_that) {
case _MulticlassTraits() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> weaponProficiencies,  List<String> armorTraining, @ContentIdConverter()  List<ContentId> toolProficiencies,  int skillChoiceCount,  int toolChoiceCount,  int casterDivisor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MulticlassTraits() when $default != null:
return $default(_that.weaponProficiencies,_that.armorTraining,_that.toolProficiencies,_that.skillChoiceCount,_that.toolChoiceCount,_that.casterDivisor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> weaponProficiencies,  List<String> armorTraining, @ContentIdConverter()  List<ContentId> toolProficiencies,  int skillChoiceCount,  int toolChoiceCount,  int casterDivisor)  $default,) {final _that = this;
switch (_that) {
case _MulticlassTraits():
return $default(_that.weaponProficiencies,_that.armorTraining,_that.toolProficiencies,_that.skillChoiceCount,_that.toolChoiceCount,_that.casterDivisor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> weaponProficiencies,  List<String> armorTraining, @ContentIdConverter()  List<ContentId> toolProficiencies,  int skillChoiceCount,  int toolChoiceCount,  int casterDivisor)?  $default,) {final _that = this;
switch (_that) {
case _MulticlassTraits() when $default != null:
return $default(_that.weaponProficiencies,_that.armorTraining,_that.toolProficiencies,_that.skillChoiceCount,_that.toolChoiceCount,_that.casterDivisor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MulticlassTraits implements MulticlassTraits {
  const _MulticlassTraits({ List<String> weaponProficiencies = const <String>[],  List<String> armorTraining = const <String>[], @ContentIdConverter()  List<ContentId> toolProficiencies = const <ContentId>[], this.skillChoiceCount = 0, this.toolChoiceCount = 0, this.casterDivisor = 0}): _weaponProficiencies = weaponProficiencies,_armorTraining = armorTraining,_toolProficiencies = toolProficiencies;
  factory _MulticlassTraits.fromJson(Map<String, dynamic> json) => _$MulticlassTraitsFromJson(json);

 final  List<String> _weaponProficiencies;
@override@JsonKey() List<String> get weaponProficiencies {
  if (_weaponProficiencies is EqualUnmodifiableListView) return _weaponProficiencies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weaponProficiencies);
}

 final  List<String> _armorTraining;
@override@JsonKey() List<String> get armorTraining {
  if (_armorTraining is EqualUnmodifiableListView) return _armorTraining;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_armorTraining);
}

 final  List<ContentId> _toolProficiencies;
@override@JsonKey()@ContentIdConverter() List<ContentId> get toolProficiencies {
  if (_toolProficiencies is EqualUnmodifiableListView) return _toolProficiencies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_toolProficiencies);
}

/// Compétences à choisir dans celles de la classe.
@override@JsonKey() final  int skillChoiceCount;
/// Outils à choisir dans la catégorie de la classe.
@override@JsonKey() final  int toolChoiceCount;
/// Part des niveaux de la classe dans le niveau de lanceur : 1 pour tous,
/// 2 pour la moitié, 0 si elle n'y compte pas (SRD p. 27).
@override@JsonKey() final  int casterDivisor;

/// Create a copy of MulticlassTraits
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MulticlassTraitsCopyWith<_MulticlassTraits> get copyWith => __$MulticlassTraitsCopyWithImpl<_MulticlassTraits>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MulticlassTraitsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MulticlassTraits&&const DeepCollectionEquality().equals(other.weaponProficiencies, _weaponProficiencies)&&const DeepCollectionEquality().equals(other.armorTraining, _armorTraining)&&const DeepCollectionEquality().equals(other.toolProficiencies, _toolProficiencies)&&(identical(other.skillChoiceCount, skillChoiceCount) || other.skillChoiceCount == skillChoiceCount)&&(identical(other.toolChoiceCount, toolChoiceCount) || other.toolChoiceCount == toolChoiceCount)&&(identical(other.casterDivisor, casterDivisor) || other.casterDivisor == casterDivisor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_weaponProficiencies),const DeepCollectionEquality().hash(_armorTraining),const DeepCollectionEquality().hash(_toolProficiencies),skillChoiceCount,toolChoiceCount,casterDivisor);
}

@override
String toString() {
    return 'MulticlassTraits(weaponProficiencies: $weaponProficiencies, armorTraining: $armorTraining, toolProficiencies: $toolProficiencies, skillChoiceCount: $skillChoiceCount, toolChoiceCount: $toolChoiceCount, casterDivisor: $casterDivisor)';
}


}

/// @nodoc
abstract mixin class _$MulticlassTraitsCopyWith<$Res> implements $MulticlassTraitsCopyWith<$Res> {
  factory _$MulticlassTraitsCopyWith(_MulticlassTraits value, $Res Function(_MulticlassTraits) _then) = __$MulticlassTraitsCopyWithImpl;
@override @useResult
$Res call({
 List<String> weaponProficiencies, List<String> armorTraining,@ContentIdConverter() List<ContentId> toolProficiencies, int skillChoiceCount, int toolChoiceCount, int casterDivisor
});




}
/// @nodoc
class __$MulticlassTraitsCopyWithImpl<$Res>
    implements _$MulticlassTraitsCopyWith<$Res> {
  __$MulticlassTraitsCopyWithImpl(this._self, this._then);

  final _MulticlassTraits _self;
  final $Res Function(_MulticlassTraits) _then;

/// Create a copy of MulticlassTraits
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weaponProficiencies = null,Object? armorTraining = null,Object? toolProficiencies = null,Object? skillChoiceCount = null,Object? toolChoiceCount = null,Object? casterDivisor = null,}) {
  return _then(_MulticlassTraits(
weaponProficiencies: null == weaponProficiencies ? _self._weaponProficiencies : weaponProficiencies // ignore: cast_nullable_to_non_nullable
as List<String>,armorTraining: null == armorTraining ? _self._armorTraining : armorTraining // ignore: cast_nullable_to_non_nullable
as List<String>,toolProficiencies: null == toolProficiencies ? _self._toolProficiencies : toolProficiencies // ignore: cast_nullable_to_non_nullable
as List<ContentId>,skillChoiceCount: null == skillChoiceCount ? _self.skillChoiceCount : skillChoiceCount // ignore: cast_nullable_to_non_nullable
as int,toolChoiceCount: null == toolChoiceCount ? _self.toolChoiceCount : toolChoiceCount // ignore: cast_nullable_to_non_nullable
as int,casterDivisor: null == casterDivisor ? _self.casterDivisor : casterDivisor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ClassData {

@ContentIdConverter() List<ContentId> get primaryAbilities;/// L'une des caractéristiques principales suffit (Guerrier : Force ou
/// Dextérité) ; sinon toutes sont requises (Moine).
 bool get primaryAbilitiesAny; int get hitDie;@ContentIdConverter() List<ContentId> get savingThrows; int get skillChoiceCount;@ContentIdConverter() List<ContentId> get skillChoices; List<String> get weaponProficiencies; List<String> get armorTraining; int get subclassLevel; List<ClassLevelData> get levels;/// Liste de sorts de la classe (le sort ne cite pas ses classes).
@ContentIdConverter() List<ContentId> get spellList;/// Caractéristique d'incantation des sorts de la classe.
@ContentIdConverter() ContentId? get spellcastingAbility;/// Outils maîtrisés d'office (Druide : matériel d'herboriste).
@ContentIdConverter() List<ContentId> get toolProficiencies;/// Outils à choisir dans une catégorie (Barde : 3 instruments).
 int get toolChoiceCount; ToolCategory? get toolChoiceCategory;/// Options d'équipement de départ, dans l'ordre du SRD (A, B, C).
 List<StartingEquipmentOption> get startingEquipment;/// Façon de changer les sorts préparés ; vide sans lanceur.
 PreparedChange? get preparedChange;/// Traits reçus quand ce n'est pas la classe de départ.
 MulticlassTraits get multiclass;
/// Create a copy of ClassData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassDataCopyWith<ClassData> get copyWith => _$ClassDataCopyWithImpl<ClassData>(this as ClassData, _$identity);

  /// Serializes this ClassData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ClassData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassData&&const DeepCollectionEquality().equals(other.primaryAbilities, _this.primaryAbilities)&&(identical(other.primaryAbilitiesAny, _this.primaryAbilitiesAny) || other.primaryAbilitiesAny == _this.primaryAbilitiesAny)&&(identical(other.hitDie, _this.hitDie) || other.hitDie == _this.hitDie)&&const DeepCollectionEquality().equals(other.savingThrows, _this.savingThrows)&&(identical(other.skillChoiceCount, _this.skillChoiceCount) || other.skillChoiceCount == _this.skillChoiceCount)&&const DeepCollectionEquality().equals(other.skillChoices, _this.skillChoices)&&const DeepCollectionEquality().equals(other.weaponProficiencies, _this.weaponProficiencies)&&const DeepCollectionEquality().equals(other.armorTraining, _this.armorTraining)&&(identical(other.subclassLevel, _this.subclassLevel) || other.subclassLevel == _this.subclassLevel)&&const DeepCollectionEquality().equals(other.levels, _this.levels)&&const DeepCollectionEquality().equals(other.spellList, _this.spellList)&&(identical(other.spellcastingAbility, _this.spellcastingAbility) || other.spellcastingAbility == _this.spellcastingAbility)&&const DeepCollectionEquality().equals(other.toolProficiencies, _this.toolProficiencies)&&(identical(other.toolChoiceCount, _this.toolChoiceCount) || other.toolChoiceCount == _this.toolChoiceCount)&&(identical(other.toolChoiceCategory, _this.toolChoiceCategory) || other.toolChoiceCategory == _this.toolChoiceCategory)&&const DeepCollectionEquality().equals(other.startingEquipment, _this.startingEquipment)&&(identical(other.preparedChange, _this.preparedChange) || other.preparedChange == _this.preparedChange)&&(identical(other.multiclass, _this.multiclass) || other.multiclass == _this.multiclass));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ClassData;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.primaryAbilities),_this.primaryAbilitiesAny,_this.hitDie,const DeepCollectionEquality().hash(_this.savingThrows),_this.skillChoiceCount,const DeepCollectionEquality().hash(_this.skillChoices),const DeepCollectionEquality().hash(_this.weaponProficiencies),const DeepCollectionEquality().hash(_this.armorTraining),_this.subclassLevel,const DeepCollectionEquality().hash(_this.levels),const DeepCollectionEquality().hash(_this.spellList),_this.spellcastingAbility,const DeepCollectionEquality().hash(_this.toolProficiencies),_this.toolChoiceCount,_this.toolChoiceCategory,const DeepCollectionEquality().hash(_this.startingEquipment),_this.preparedChange,_this.multiclass);
}

@override
String toString() {
  final _this = this as ClassData;
  return 'ClassData(primaryAbilities: ${_this.primaryAbilities}, primaryAbilitiesAny: ${_this.primaryAbilitiesAny}, hitDie: ${_this.hitDie}, savingThrows: ${_this.savingThrows}, skillChoiceCount: ${_this.skillChoiceCount}, skillChoices: ${_this.skillChoices}, weaponProficiencies: ${_this.weaponProficiencies}, armorTraining: ${_this.armorTraining}, subclassLevel: ${_this.subclassLevel}, levels: ${_this.levels}, spellList: ${_this.spellList}, spellcastingAbility: ${_this.spellcastingAbility}, toolProficiencies: ${_this.toolProficiencies}, toolChoiceCount: ${_this.toolChoiceCount}, toolChoiceCategory: ${_this.toolChoiceCategory}, startingEquipment: ${_this.startingEquipment}, preparedChange: ${_this.preparedChange}, multiclass: ${_this.multiclass})';
}


}

/// @nodoc
abstract mixin class $ClassDataCopyWith<$Res>  {
  factory $ClassDataCopyWith(ClassData value, $Res Function(ClassData) _then) = _$ClassDataCopyWithImpl;
@useResult
$Res call({
@ContentIdConverter() List<ContentId> primaryAbilities, bool primaryAbilitiesAny, int hitDie,@ContentIdConverter() List<ContentId> savingThrows, int skillChoiceCount,@ContentIdConverter() List<ContentId> skillChoices, List<String> weaponProficiencies, List<String> armorTraining, int subclassLevel, List<ClassLevelData> levels,@ContentIdConverter() List<ContentId> spellList,@ContentIdConverter() ContentId? spellcastingAbility,@ContentIdConverter() List<ContentId> toolProficiencies, int toolChoiceCount, ToolCategory? toolChoiceCategory, List<StartingEquipmentOption> startingEquipment, PreparedChange? preparedChange, MulticlassTraits multiclass
});


$MulticlassTraitsCopyWith<$Res> get multiclass;

}
/// @nodoc
class _$ClassDataCopyWithImpl<$Res>
    implements $ClassDataCopyWith<$Res> {
  _$ClassDataCopyWithImpl(this._self, this._then);

  final ClassData _self;
  final $Res Function(ClassData) _then;

/// Create a copy of ClassData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? primaryAbilities = null,Object? primaryAbilitiesAny = null,Object? hitDie = null,Object? savingThrows = null,Object? skillChoiceCount = null,Object? skillChoices = null,Object? weaponProficiencies = null,Object? armorTraining = null,Object? subclassLevel = null,Object? levels = null,Object? spellList = null,Object? spellcastingAbility = freezed,Object? toolProficiencies = null,Object? toolChoiceCount = null,Object? toolChoiceCategory = freezed,Object? startingEquipment = null,Object? preparedChange = freezed,Object? multiclass = null,}) {
  return _then(ClassData(
primaryAbilities: null == primaryAbilities ? _self.primaryAbilities : primaryAbilities // ignore: cast_nullable_to_non_nullable
as List<ContentId>,primaryAbilitiesAny: null == primaryAbilitiesAny ? _self.primaryAbilitiesAny : primaryAbilitiesAny // ignore: cast_nullable_to_non_nullable
as bool,hitDie: null == hitDie ? _self.hitDie : hitDie // ignore: cast_nullable_to_non_nullable
as int,savingThrows: null == savingThrows ? _self.savingThrows : savingThrows // ignore: cast_nullable_to_non_nullable
as List<ContentId>,skillChoiceCount: null == skillChoiceCount ? _self.skillChoiceCount : skillChoiceCount // ignore: cast_nullable_to_non_nullable
as int,skillChoices: null == skillChoices ? _self.skillChoices : skillChoices // ignore: cast_nullable_to_non_nullable
as List<ContentId>,weaponProficiencies: null == weaponProficiencies ? _self.weaponProficiencies : weaponProficiencies // ignore: cast_nullable_to_non_nullable
as List<String>,armorTraining: null == armorTraining ? _self.armorTraining : armorTraining // ignore: cast_nullable_to_non_nullable
as List<String>,subclassLevel: null == subclassLevel ? _self.subclassLevel : subclassLevel // ignore: cast_nullable_to_non_nullable
as int,levels: null == levels ? _self.levels : levels // ignore: cast_nullable_to_non_nullable
as List<ClassLevelData>,spellList: null == spellList ? _self.spellList : spellList // ignore: cast_nullable_to_non_nullable
as List<ContentId>,spellcastingAbility: freezed == spellcastingAbility ? _self.spellcastingAbility : spellcastingAbility // ignore: cast_nullable_to_non_nullable
as ContentId?,toolProficiencies: null == toolProficiencies ? _self.toolProficiencies : toolProficiencies // ignore: cast_nullable_to_non_nullable
as List<ContentId>,toolChoiceCount: null == toolChoiceCount ? _self.toolChoiceCount : toolChoiceCount // ignore: cast_nullable_to_non_nullable
as int,toolChoiceCategory: freezed == toolChoiceCategory ? _self.toolChoiceCategory : toolChoiceCategory // ignore: cast_nullable_to_non_nullable
as ToolCategory?,startingEquipment: null == startingEquipment ? _self.startingEquipment : startingEquipment // ignore: cast_nullable_to_non_nullable
as List<StartingEquipmentOption>,preparedChange: freezed == preparedChange ? _self.preparedChange : preparedChange // ignore: cast_nullable_to_non_nullable
as PreparedChange?,multiclass: null == multiclass ? _self.multiclass : multiclass // ignore: cast_nullable_to_non_nullable
as MulticlassTraits,
  ));
}
/// Create a copy of ClassData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MulticlassTraitsCopyWith<$Res> get multiclass {
  
  return $MulticlassTraitsCopyWith<$Res>(_self.multiclass, (value) {
    return _then(_self.copyWith(multiclass: value));
  });
}
}


/// Adds pattern-matching-related methods to [ClassData].
extension ClassDataPatterns on ClassData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClassData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClassData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClassData value)  $default,){
final _that = this;
switch (_that) {
case _ClassData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClassData value)?  $default,){
final _that = this;
switch (_that) {
case _ClassData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@ContentIdConverter()  List<ContentId> primaryAbilities,  bool primaryAbilitiesAny,  int hitDie, @ContentIdConverter()  List<ContentId> savingThrows,  int skillChoiceCount, @ContentIdConverter()  List<ContentId> skillChoices,  List<String> weaponProficiencies,  List<String> armorTraining,  int subclassLevel,  List<ClassLevelData> levels, @ContentIdConverter()  List<ContentId> spellList, @ContentIdConverter()  ContentId? spellcastingAbility, @ContentIdConverter()  List<ContentId> toolProficiencies,  int toolChoiceCount,  ToolCategory? toolChoiceCategory,  List<StartingEquipmentOption> startingEquipment,  PreparedChange? preparedChange,  MulticlassTraits multiclass)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClassData() when $default != null:
return $default(_that.primaryAbilities,_that.primaryAbilitiesAny,_that.hitDie,_that.savingThrows,_that.skillChoiceCount,_that.skillChoices,_that.weaponProficiencies,_that.armorTraining,_that.subclassLevel,_that.levels,_that.spellList,_that.spellcastingAbility,_that.toolProficiencies,_that.toolChoiceCount,_that.toolChoiceCategory,_that.startingEquipment,_that.preparedChange,_that.multiclass);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@ContentIdConverter()  List<ContentId> primaryAbilities,  bool primaryAbilitiesAny,  int hitDie, @ContentIdConverter()  List<ContentId> savingThrows,  int skillChoiceCount, @ContentIdConverter()  List<ContentId> skillChoices,  List<String> weaponProficiencies,  List<String> armorTraining,  int subclassLevel,  List<ClassLevelData> levels, @ContentIdConverter()  List<ContentId> spellList, @ContentIdConverter()  ContentId? spellcastingAbility, @ContentIdConverter()  List<ContentId> toolProficiencies,  int toolChoiceCount,  ToolCategory? toolChoiceCategory,  List<StartingEquipmentOption> startingEquipment,  PreparedChange? preparedChange,  MulticlassTraits multiclass)  $default,) {final _that = this;
switch (_that) {
case _ClassData():
return $default(_that.primaryAbilities,_that.primaryAbilitiesAny,_that.hitDie,_that.savingThrows,_that.skillChoiceCount,_that.skillChoices,_that.weaponProficiencies,_that.armorTraining,_that.subclassLevel,_that.levels,_that.spellList,_that.spellcastingAbility,_that.toolProficiencies,_that.toolChoiceCount,_that.toolChoiceCategory,_that.startingEquipment,_that.preparedChange,_that.multiclass);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@ContentIdConverter()  List<ContentId> primaryAbilities,  bool primaryAbilitiesAny,  int hitDie, @ContentIdConverter()  List<ContentId> savingThrows,  int skillChoiceCount, @ContentIdConverter()  List<ContentId> skillChoices,  List<String> weaponProficiencies,  List<String> armorTraining,  int subclassLevel,  List<ClassLevelData> levels, @ContentIdConverter()  List<ContentId> spellList, @ContentIdConverter()  ContentId? spellcastingAbility, @ContentIdConverter()  List<ContentId> toolProficiencies,  int toolChoiceCount,  ToolCategory? toolChoiceCategory,  List<StartingEquipmentOption> startingEquipment,  PreparedChange? preparedChange,  MulticlassTraits multiclass)?  $default,) {final _that = this;
switch (_that) {
case _ClassData() when $default != null:
return $default(_that.primaryAbilities,_that.primaryAbilitiesAny,_that.hitDie,_that.savingThrows,_that.skillChoiceCount,_that.skillChoices,_that.weaponProficiencies,_that.armorTraining,_that.subclassLevel,_that.levels,_that.spellList,_that.spellcastingAbility,_that.toolProficiencies,_that.toolChoiceCount,_that.toolChoiceCategory,_that.startingEquipment,_that.preparedChange,_that.multiclass);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClassData implements ClassData {
  const _ClassData({@ContentIdConverter() required  List<ContentId> primaryAbilities, this.primaryAbilitiesAny = false, required this.hitDie, @ContentIdConverter() required  List<ContentId> savingThrows, required this.skillChoiceCount, @ContentIdConverter() required  List<ContentId> skillChoices, required  List<String> weaponProficiencies, required  List<String> armorTraining, required this.subclassLevel, required  List<ClassLevelData> levels, @ContentIdConverter()  List<ContentId> spellList = const <ContentId>[], @ContentIdConverter() this.spellcastingAbility, @ContentIdConverter()  List<ContentId> toolProficiencies = const <ContentId>[], this.toolChoiceCount = 0, this.toolChoiceCategory,  List<StartingEquipmentOption> startingEquipment = const <StartingEquipmentOption>[], this.preparedChange, this.multiclass = const MulticlassTraits()}): _primaryAbilities = primaryAbilities,_savingThrows = savingThrows,_skillChoices = skillChoices,_weaponProficiencies = weaponProficiencies,_armorTraining = armorTraining,_levels = levels,_spellList = spellList,_toolProficiencies = toolProficiencies,_startingEquipment = startingEquipment;
  factory _ClassData.fromJson(Map<String, dynamic> json) => _$ClassDataFromJson(json);

 final  List<ContentId> _primaryAbilities;
@override@ContentIdConverter() List<ContentId> get primaryAbilities {
  if (_primaryAbilities is EqualUnmodifiableListView) return _primaryAbilities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_primaryAbilities);
}

/// L'une des caractéristiques principales suffit (Guerrier : Force ou
/// Dextérité) ; sinon toutes sont requises (Moine).
@override@JsonKey() final  bool primaryAbilitiesAny;
@override final  int hitDie;
 final  List<ContentId> _savingThrows;
@override@ContentIdConverter() List<ContentId> get savingThrows {
  if (_savingThrows is EqualUnmodifiableListView) return _savingThrows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_savingThrows);
}

@override final  int skillChoiceCount;
 final  List<ContentId> _skillChoices;
@override@ContentIdConverter() List<ContentId> get skillChoices {
  if (_skillChoices is EqualUnmodifiableListView) return _skillChoices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skillChoices);
}

 final  List<String> _weaponProficiencies;
@override List<String> get weaponProficiencies {
  if (_weaponProficiencies is EqualUnmodifiableListView) return _weaponProficiencies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weaponProficiencies);
}

 final  List<String> _armorTraining;
@override List<String> get armorTraining {
  if (_armorTraining is EqualUnmodifiableListView) return _armorTraining;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_armorTraining);
}

@override final  int subclassLevel;
 final  List<ClassLevelData> _levels;
@override List<ClassLevelData> get levels {
  if (_levels is EqualUnmodifiableListView) return _levels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_levels);
}

/// Liste de sorts de la classe (le sort ne cite pas ses classes).
 final  List<ContentId> _spellList;
/// Liste de sorts de la classe (le sort ne cite pas ses classes).
@override@JsonKey()@ContentIdConverter() List<ContentId> get spellList {
  if (_spellList is EqualUnmodifiableListView) return _spellList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_spellList);
}

/// Caractéristique d'incantation des sorts de la classe.
@override@ContentIdConverter() final  ContentId? spellcastingAbility;
/// Outils maîtrisés d'office (Druide : matériel d'herboriste).
 final  List<ContentId> _toolProficiencies;
/// Outils maîtrisés d'office (Druide : matériel d'herboriste).
@override@JsonKey()@ContentIdConverter() List<ContentId> get toolProficiencies {
  if (_toolProficiencies is EqualUnmodifiableListView) return _toolProficiencies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_toolProficiencies);
}

/// Outils à choisir dans une catégorie (Barde : 3 instruments).
@override@JsonKey() final  int toolChoiceCount;
@override final  ToolCategory? toolChoiceCategory;
/// Options d'équipement de départ, dans l'ordre du SRD (A, B, C).
 final  List<StartingEquipmentOption> _startingEquipment;
/// Options d'équipement de départ, dans l'ordre du SRD (A, B, C).
@override@JsonKey() List<StartingEquipmentOption> get startingEquipment {
  if (_startingEquipment is EqualUnmodifiableListView) return _startingEquipment;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_startingEquipment);
}

/// Façon de changer les sorts préparés ; vide sans lanceur.
@override final  PreparedChange? preparedChange;
/// Traits reçus quand ce n'est pas la classe de départ.
@override@JsonKey() final  MulticlassTraits multiclass;

/// Create a copy of ClassData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassDataCopyWith<_ClassData> get copyWith => __$ClassDataCopyWithImpl<_ClassData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClassDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassData&&const DeepCollectionEquality().equals(other.primaryAbilities, _primaryAbilities)&&(identical(other.primaryAbilitiesAny, primaryAbilitiesAny) || other.primaryAbilitiesAny == primaryAbilitiesAny)&&(identical(other.hitDie, hitDie) || other.hitDie == hitDie)&&const DeepCollectionEquality().equals(other.savingThrows, _savingThrows)&&(identical(other.skillChoiceCount, skillChoiceCount) || other.skillChoiceCount == skillChoiceCount)&&const DeepCollectionEquality().equals(other.skillChoices, _skillChoices)&&const DeepCollectionEquality().equals(other.weaponProficiencies, _weaponProficiencies)&&const DeepCollectionEquality().equals(other.armorTraining, _armorTraining)&&(identical(other.subclassLevel, subclassLevel) || other.subclassLevel == subclassLevel)&&const DeepCollectionEquality().equals(other.levels, _levels)&&const DeepCollectionEquality().equals(other.spellList, _spellList)&&(identical(other.spellcastingAbility, spellcastingAbility) || other.spellcastingAbility == spellcastingAbility)&&const DeepCollectionEquality().equals(other.toolProficiencies, _toolProficiencies)&&(identical(other.toolChoiceCount, toolChoiceCount) || other.toolChoiceCount == toolChoiceCount)&&(identical(other.toolChoiceCategory, toolChoiceCategory) || other.toolChoiceCategory == toolChoiceCategory)&&const DeepCollectionEquality().equals(other.startingEquipment, _startingEquipment)&&(identical(other.preparedChange, preparedChange) || other.preparedChange == preparedChange)&&(identical(other.multiclass, multiclass) || other.multiclass == multiclass));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_primaryAbilities),primaryAbilitiesAny,hitDie,const DeepCollectionEquality().hash(_savingThrows),skillChoiceCount,const DeepCollectionEquality().hash(_skillChoices),const DeepCollectionEquality().hash(_weaponProficiencies),const DeepCollectionEquality().hash(_armorTraining),subclassLevel,const DeepCollectionEquality().hash(_levels),const DeepCollectionEquality().hash(_spellList),spellcastingAbility,const DeepCollectionEquality().hash(_toolProficiencies),toolChoiceCount,toolChoiceCategory,const DeepCollectionEquality().hash(_startingEquipment),preparedChange,multiclass);
}

@override
String toString() {
    return 'ClassData(primaryAbilities: $primaryAbilities, primaryAbilitiesAny: $primaryAbilitiesAny, hitDie: $hitDie, savingThrows: $savingThrows, skillChoiceCount: $skillChoiceCount, skillChoices: $skillChoices, weaponProficiencies: $weaponProficiencies, armorTraining: $armorTraining, subclassLevel: $subclassLevel, levels: $levels, spellList: $spellList, spellcastingAbility: $spellcastingAbility, toolProficiencies: $toolProficiencies, toolChoiceCount: $toolChoiceCount, toolChoiceCategory: $toolChoiceCategory, startingEquipment: $startingEquipment, preparedChange: $preparedChange, multiclass: $multiclass)';
}


}

/// @nodoc
abstract mixin class _$ClassDataCopyWith<$Res> implements $ClassDataCopyWith<$Res> {
  factory _$ClassDataCopyWith(_ClassData value, $Res Function(_ClassData) _then) = __$ClassDataCopyWithImpl;
@override @useResult
$Res call({
@ContentIdConverter() List<ContentId> primaryAbilities, bool primaryAbilitiesAny, int hitDie,@ContentIdConverter() List<ContentId> savingThrows, int skillChoiceCount,@ContentIdConverter() List<ContentId> skillChoices, List<String> weaponProficiencies, List<String> armorTraining, int subclassLevel, List<ClassLevelData> levels,@ContentIdConverter() List<ContentId> spellList,@ContentIdConverter() ContentId? spellcastingAbility,@ContentIdConverter() List<ContentId> toolProficiencies, int toolChoiceCount, ToolCategory? toolChoiceCategory, List<StartingEquipmentOption> startingEquipment, PreparedChange? preparedChange, MulticlassTraits multiclass
});


@override $MulticlassTraitsCopyWith<$Res> get multiclass;

}
/// @nodoc
class __$ClassDataCopyWithImpl<$Res>
    implements _$ClassDataCopyWith<$Res> {
  __$ClassDataCopyWithImpl(this._self, this._then);

  final _ClassData _self;
  final $Res Function(_ClassData) _then;

/// Create a copy of ClassData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? primaryAbilities = null,Object? primaryAbilitiesAny = null,Object? hitDie = null,Object? savingThrows = null,Object? skillChoiceCount = null,Object? skillChoices = null,Object? weaponProficiencies = null,Object? armorTraining = null,Object? subclassLevel = null,Object? levels = null,Object? spellList = null,Object? spellcastingAbility = freezed,Object? toolProficiencies = null,Object? toolChoiceCount = null,Object? toolChoiceCategory = freezed,Object? startingEquipment = null,Object? preparedChange = freezed,Object? multiclass = null,}) {
  return _then(_ClassData(
primaryAbilities: null == primaryAbilities ? _self._primaryAbilities : primaryAbilities // ignore: cast_nullable_to_non_nullable
as List<ContentId>,primaryAbilitiesAny: null == primaryAbilitiesAny ? _self.primaryAbilitiesAny : primaryAbilitiesAny // ignore: cast_nullable_to_non_nullable
as bool,hitDie: null == hitDie ? _self.hitDie : hitDie // ignore: cast_nullable_to_non_nullable
as int,savingThrows: null == savingThrows ? _self._savingThrows : savingThrows // ignore: cast_nullable_to_non_nullable
as List<ContentId>,skillChoiceCount: null == skillChoiceCount ? _self.skillChoiceCount : skillChoiceCount // ignore: cast_nullable_to_non_nullable
as int,skillChoices: null == skillChoices ? _self._skillChoices : skillChoices // ignore: cast_nullable_to_non_nullable
as List<ContentId>,weaponProficiencies: null == weaponProficiencies ? _self._weaponProficiencies : weaponProficiencies // ignore: cast_nullable_to_non_nullable
as List<String>,armorTraining: null == armorTraining ? _self._armorTraining : armorTraining // ignore: cast_nullable_to_non_nullable
as List<String>,subclassLevel: null == subclassLevel ? _self.subclassLevel : subclassLevel // ignore: cast_nullable_to_non_nullable
as int,levels: null == levels ? _self._levels : levels // ignore: cast_nullable_to_non_nullable
as List<ClassLevelData>,spellList: null == spellList ? _self._spellList : spellList // ignore: cast_nullable_to_non_nullable
as List<ContentId>,spellcastingAbility: freezed == spellcastingAbility ? _self.spellcastingAbility : spellcastingAbility // ignore: cast_nullable_to_non_nullable
as ContentId?,toolProficiencies: null == toolProficiencies ? _self._toolProficiencies : toolProficiencies // ignore: cast_nullable_to_non_nullable
as List<ContentId>,toolChoiceCount: null == toolChoiceCount ? _self.toolChoiceCount : toolChoiceCount // ignore: cast_nullable_to_non_nullable
as int,toolChoiceCategory: freezed == toolChoiceCategory ? _self.toolChoiceCategory : toolChoiceCategory // ignore: cast_nullable_to_non_nullable
as ToolCategory?,startingEquipment: null == startingEquipment ? _self._startingEquipment : startingEquipment // ignore: cast_nullable_to_non_nullable
as List<StartingEquipmentOption>,preparedChange: freezed == preparedChange ? _self.preparedChange : preparedChange // ignore: cast_nullable_to_non_nullable
as PreparedChange?,multiclass: null == multiclass ? _self.multiclass : multiclass // ignore: cast_nullable_to_non_nullable
as MulticlassTraits,
  ));
}

/// Create a copy of ClassData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MulticlassTraitsCopyWith<$Res> get multiclass {
  
  return $MulticlassTraitsCopyWith<$Res>(_self.multiclass, (value) {
    return _then(_self.copyWith(multiclass: value));
  });
}
}


/// @nodoc
mixin _$SubclassData {

@ContentIdConverter() ContentId get parentClass;@ContentIdConverter() List<ContentId> get features;
/// Create a copy of SubclassData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubclassDataCopyWith<SubclassData> get copyWith => _$SubclassDataCopyWithImpl<SubclassData>(this as SubclassData, _$identity);

  /// Serializes this SubclassData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SubclassData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubclassData&&(identical(other.parentClass, _this.parentClass) || other.parentClass == _this.parentClass)&&const DeepCollectionEquality().equals(other.features, _this.features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SubclassData;
  return Object.hash(runtimeType,_this.parentClass,const DeepCollectionEquality().hash(_this.features));
}

@override
String toString() {
  final _this = this as SubclassData;
  return 'SubclassData(parentClass: ${_this.parentClass}, features: ${_this.features})';
}


}

/// @nodoc
abstract mixin class $SubclassDataCopyWith<$Res>  {
  factory $SubclassDataCopyWith(SubclassData value, $Res Function(SubclassData) _then) = _$SubclassDataCopyWithImpl;
@useResult
$Res call({
@ContentIdConverter() ContentId parentClass,@ContentIdConverter() List<ContentId> features
});




}
/// @nodoc
class _$SubclassDataCopyWithImpl<$Res>
    implements $SubclassDataCopyWith<$Res> {
  _$SubclassDataCopyWithImpl(this._self, this._then);

  final SubclassData _self;
  final $Res Function(SubclassData) _then;

/// Create a copy of SubclassData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? parentClass = null,Object? features = null,}) {
  return _then(SubclassData(
parentClass: null == parentClass ? _self.parentClass : parentClass // ignore: cast_nullable_to_non_nullable
as ContentId,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as List<ContentId>,
  ));
}

}


/// Adds pattern-matching-related methods to [SubclassData].
extension SubclassDataPatterns on SubclassData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubclassData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubclassData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubclassData value)  $default,){
final _that = this;
switch (_that) {
case _SubclassData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubclassData value)?  $default,){
final _that = this;
switch (_that) {
case _SubclassData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@ContentIdConverter()  ContentId parentClass, @ContentIdConverter()  List<ContentId> features)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubclassData() when $default != null:
return $default(_that.parentClass,_that.features);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@ContentIdConverter()  ContentId parentClass, @ContentIdConverter()  List<ContentId> features)  $default,) {final _that = this;
switch (_that) {
case _SubclassData():
return $default(_that.parentClass,_that.features);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@ContentIdConverter()  ContentId parentClass, @ContentIdConverter()  List<ContentId> features)?  $default,) {final _that = this;
switch (_that) {
case _SubclassData() when $default != null:
return $default(_that.parentClass,_that.features);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubclassData implements SubclassData {
  const _SubclassData({@ContentIdConverter() required this.parentClass, @ContentIdConverter() required  List<ContentId> features}): _features = features;
  factory _SubclassData.fromJson(Map<String, dynamic> json) => _$SubclassDataFromJson(json);

@override@ContentIdConverter() final  ContentId parentClass;
 final  List<ContentId> _features;
@override@ContentIdConverter() List<ContentId> get features {
  if (_features is EqualUnmodifiableListView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_features);
}


/// Create a copy of SubclassData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubclassDataCopyWith<_SubclassData> get copyWith => __$SubclassDataCopyWithImpl<_SubclassData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubclassDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubclassData&&(identical(other.parentClass, parentClass) || other.parentClass == parentClass)&&const DeepCollectionEquality().equals(other.features, _features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,parentClass,const DeepCollectionEquality().hash(_features));
}

@override
String toString() {
    return 'SubclassData(parentClass: $parentClass, features: $features)';
}


}

/// @nodoc
abstract mixin class _$SubclassDataCopyWith<$Res> implements $SubclassDataCopyWith<$Res> {
  factory _$SubclassDataCopyWith(_SubclassData value, $Res Function(_SubclassData) _then) = __$SubclassDataCopyWithImpl;
@override @useResult
$Res call({
@ContentIdConverter() ContentId parentClass,@ContentIdConverter() List<ContentId> features
});




}
/// @nodoc
class __$SubclassDataCopyWithImpl<$Res>
    implements _$SubclassDataCopyWith<$Res> {
  __$SubclassDataCopyWithImpl(this._self, this._then);

  final _SubclassData _self;
  final $Res Function(_SubclassData) _then;

/// Create a copy of SubclassData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? parentClass = null,Object? features = null,}) {
  return _then(_SubclassData(
parentClass: null == parentClass ? _self.parentClass : parentClass // ignore: cast_nullable_to_non_nullable
as ContentId,features: null == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as List<ContentId>,
  ));
}


}


/// @nodoc
mixin _$FeatureData {

@ContentIdConverter() ContentId get source; int? get level;
/// Create a copy of FeatureData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeatureDataCopyWith<FeatureData> get copyWith => _$FeatureDataCopyWithImpl<FeatureData>(this as FeatureData, _$identity);

  /// Serializes this FeatureData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FeatureData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeatureData&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.level, _this.level) || other.level == _this.level));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FeatureData;
  return Object.hash(runtimeType,_this.source,_this.level);
}

@override
String toString() {
  final _this = this as FeatureData;
  return 'FeatureData(source: ${_this.source}, level: ${_this.level})';
}


}

/// @nodoc
abstract mixin class $FeatureDataCopyWith<$Res>  {
  factory $FeatureDataCopyWith(FeatureData value, $Res Function(FeatureData) _then) = _$FeatureDataCopyWithImpl;
@useResult
$Res call({
@ContentIdConverter() ContentId source, int? level
});




}
/// @nodoc
class _$FeatureDataCopyWithImpl<$Res>
    implements $FeatureDataCopyWith<$Res> {
  _$FeatureDataCopyWithImpl(this._self, this._then);

  final FeatureData _self;
  final $Res Function(FeatureData) _then;

/// Create a copy of FeatureData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? source = null,Object? level = freezed,}) {
  return _then(FeatureData(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ContentId,level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [FeatureData].
extension FeatureDataPatterns on FeatureData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeatureData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeatureData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeatureData value)  $default,){
final _that = this;
switch (_that) {
case _FeatureData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeatureData value)?  $default,){
final _that = this;
switch (_that) {
case _FeatureData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@ContentIdConverter()  ContentId source,  int? level)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeatureData() when $default != null:
return $default(_that.source,_that.level);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@ContentIdConverter()  ContentId source,  int? level)  $default,) {final _that = this;
switch (_that) {
case _FeatureData():
return $default(_that.source,_that.level);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@ContentIdConverter()  ContentId source,  int? level)?  $default,) {final _that = this;
switch (_that) {
case _FeatureData() when $default != null:
return $default(_that.source,_that.level);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeatureData implements FeatureData {
  const _FeatureData({@ContentIdConverter() required this.source, this.level});
  factory _FeatureData.fromJson(Map<String, dynamic> json) => _$FeatureDataFromJson(json);

@override@ContentIdConverter() final  ContentId source;
@override final  int? level;

/// Create a copy of FeatureData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeatureDataCopyWith<_FeatureData> get copyWith => __$FeatureDataCopyWithImpl<_FeatureData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeatureDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeatureData&&(identical(other.source, source) || other.source == source)&&(identical(other.level, level) || other.level == level));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,source,level);
}

@override
String toString() {
    return 'FeatureData(source: $source, level: $level)';
}


}

/// @nodoc
abstract mixin class _$FeatureDataCopyWith<$Res> implements $FeatureDataCopyWith<$Res> {
  factory _$FeatureDataCopyWith(_FeatureData value, $Res Function(_FeatureData) _then) = __$FeatureDataCopyWithImpl;
@override @useResult
$Res call({
@ContentIdConverter() ContentId source, int? level
});




}
/// @nodoc
class __$FeatureDataCopyWithImpl<$Res>
    implements _$FeatureDataCopyWith<$Res> {
  __$FeatureDataCopyWithImpl(this._self, this._then);

  final _FeatureData _self;
  final $Res Function(_FeatureData) _then;

/// Create a copy of FeatureData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? source = null,Object? level = freezed,}) {
  return _then(_FeatureData(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ContentId,level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$SpellRange {

 RangeKind get kind; int? get feet;
/// Create a copy of SpellRange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpellRangeCopyWith<SpellRange> get copyWith => _$SpellRangeCopyWithImpl<SpellRange>(this as SpellRange, _$identity);

  /// Serializes this SpellRange to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SpellRange;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpellRange&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.feet, _this.feet) || other.feet == _this.feet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SpellRange;
  return Object.hash(runtimeType,_this.kind,_this.feet);
}

@override
String toString() {
  final _this = this as SpellRange;
  return 'SpellRange(kind: ${_this.kind}, feet: ${_this.feet})';
}


}

/// @nodoc
abstract mixin class $SpellRangeCopyWith<$Res>  {
  factory $SpellRangeCopyWith(SpellRange value, $Res Function(SpellRange) _then) = _$SpellRangeCopyWithImpl;
@useResult
$Res call({
 RangeKind kind, int? feet
});




}
/// @nodoc
class _$SpellRangeCopyWithImpl<$Res>
    implements $SpellRangeCopyWith<$Res> {
  _$SpellRangeCopyWithImpl(this._self, this._then);

  final SpellRange _self;
  final $Res Function(SpellRange) _then;

/// Create a copy of SpellRange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? feet = freezed,}) {
  return _then(SpellRange(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as RangeKind,feet: freezed == feet ? _self.feet : feet // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SpellRange].
extension SpellRangePatterns on SpellRange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpellRange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpellRange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpellRange value)  $default,){
final _that = this;
switch (_that) {
case _SpellRange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpellRange value)?  $default,){
final _that = this;
switch (_that) {
case _SpellRange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RangeKind kind,  int? feet)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpellRange() when $default != null:
return $default(_that.kind,_that.feet);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RangeKind kind,  int? feet)  $default,) {final _that = this;
switch (_that) {
case _SpellRange():
return $default(_that.kind,_that.feet);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RangeKind kind,  int? feet)?  $default,) {final _that = this;
switch (_that) {
case _SpellRange() when $default != null:
return $default(_that.kind,_that.feet);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpellRange implements SpellRange {
  const _SpellRange({required this.kind, this.feet});
  factory _SpellRange.fromJson(Map<String, dynamic> json) => _$SpellRangeFromJson(json);

@override final  RangeKind kind;
@override final  int? feet;

/// Create a copy of SpellRange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpellRangeCopyWith<_SpellRange> get copyWith => __$SpellRangeCopyWithImpl<_SpellRange>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpellRangeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpellRange&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.feet, feet) || other.feet == feet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,feet);
}

@override
String toString() {
    return 'SpellRange(kind: $kind, feet: $feet)';
}


}

/// @nodoc
abstract mixin class _$SpellRangeCopyWith<$Res> implements $SpellRangeCopyWith<$Res> {
  factory _$SpellRangeCopyWith(_SpellRange value, $Res Function(_SpellRange) _then) = __$SpellRangeCopyWithImpl;
@override @useResult
$Res call({
 RangeKind kind, int? feet
});




}
/// @nodoc
class __$SpellRangeCopyWithImpl<$Res>
    implements _$SpellRangeCopyWith<$Res> {
  __$SpellRangeCopyWithImpl(this._self, this._then);

  final _SpellRange _self;
  final $Res Function(_SpellRange) _then;

/// Create a copy of SpellRange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? feet = freezed,}) {
  return _then(_SpellRange(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as RangeKind,feet: freezed == feet ? _self.feet : feet // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$SpellComponents {

 bool get verbal; bool get somatic; String? get material;
/// Create a copy of SpellComponents
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpellComponentsCopyWith<SpellComponents> get copyWith => _$SpellComponentsCopyWithImpl<SpellComponents>(this as SpellComponents, _$identity);

  /// Serializes this SpellComponents to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SpellComponents;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpellComponents&&(identical(other.verbal, _this.verbal) || other.verbal == _this.verbal)&&(identical(other.somatic, _this.somatic) || other.somatic == _this.somatic)&&(identical(other.material, _this.material) || other.material == _this.material));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SpellComponents;
  return Object.hash(runtimeType,_this.verbal,_this.somatic,_this.material);
}

@override
String toString() {
  final _this = this as SpellComponents;
  return 'SpellComponents(verbal: ${_this.verbal}, somatic: ${_this.somatic}, material: ${_this.material})';
}


}

/// @nodoc
abstract mixin class $SpellComponentsCopyWith<$Res>  {
  factory $SpellComponentsCopyWith(SpellComponents value, $Res Function(SpellComponents) _then) = _$SpellComponentsCopyWithImpl;
@useResult
$Res call({
 bool verbal, bool somatic, String? material
});




}
/// @nodoc
class _$SpellComponentsCopyWithImpl<$Res>
    implements $SpellComponentsCopyWith<$Res> {
  _$SpellComponentsCopyWithImpl(this._self, this._then);

  final SpellComponents _self;
  final $Res Function(SpellComponents) _then;

/// Create a copy of SpellComponents
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? verbal = null,Object? somatic = null,Object? material = freezed,}) {
  return _then(SpellComponents(
verbal: null == verbal ? _self.verbal : verbal // ignore: cast_nullable_to_non_nullable
as bool,somatic: null == somatic ? _self.somatic : somatic // ignore: cast_nullable_to_non_nullable
as bool,material: freezed == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SpellComponents].
extension SpellComponentsPatterns on SpellComponents {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpellComponents value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpellComponents() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpellComponents value)  $default,){
final _that = this;
switch (_that) {
case _SpellComponents():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpellComponents value)?  $default,){
final _that = this;
switch (_that) {
case _SpellComponents() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool verbal,  bool somatic,  String? material)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpellComponents() when $default != null:
return $default(_that.verbal,_that.somatic,_that.material);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool verbal,  bool somatic,  String? material)  $default,) {final _that = this;
switch (_that) {
case _SpellComponents():
return $default(_that.verbal,_that.somatic,_that.material);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool verbal,  bool somatic,  String? material)?  $default,) {final _that = this;
switch (_that) {
case _SpellComponents() when $default != null:
return $default(_that.verbal,_that.somatic,_that.material);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpellComponents implements SpellComponents {
  const _SpellComponents({required this.verbal, required this.somatic, this.material});
  factory _SpellComponents.fromJson(Map<String, dynamic> json) => _$SpellComponentsFromJson(json);

@override final  bool verbal;
@override final  bool somatic;
@override final  String? material;

/// Create a copy of SpellComponents
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpellComponentsCopyWith<_SpellComponents> get copyWith => __$SpellComponentsCopyWithImpl<_SpellComponents>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpellComponentsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpellComponents&&(identical(other.verbal, verbal) || other.verbal == verbal)&&(identical(other.somatic, somatic) || other.somatic == somatic)&&(identical(other.material, material) || other.material == material));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,verbal,somatic,material);
}

@override
String toString() {
    return 'SpellComponents(verbal: $verbal, somatic: $somatic, material: $material)';
}


}

/// @nodoc
abstract mixin class _$SpellComponentsCopyWith<$Res> implements $SpellComponentsCopyWith<$Res> {
  factory _$SpellComponentsCopyWith(_SpellComponents value, $Res Function(_SpellComponents) _then) = __$SpellComponentsCopyWithImpl;
@override @useResult
$Res call({
 bool verbal, bool somatic, String? material
});




}
/// @nodoc
class __$SpellComponentsCopyWithImpl<$Res>
    implements _$SpellComponentsCopyWith<$Res> {
  __$SpellComponentsCopyWithImpl(this._self, this._then);

  final _SpellComponents _self;
  final $Res Function(_SpellComponents) _then;

/// Create a copy of SpellComponents
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? verbal = null,Object? somatic = null,Object? material = freezed,}) {
  return _then(_SpellComponents(
verbal: null == verbal ? _self.verbal : verbal // ignore: cast_nullable_to_non_nullable
as bool,somatic: null == somatic ? _self.somatic : somatic // ignore: cast_nullable_to_non_nullable
as bool,material: freezed == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SpellData {

@JsonKey(fromJson: _spellLevel) int get level; SpellSchool get school;/// Temps d'incantation, tel que dans le SRD (« action », « 1 minute »…).
 String get castingTime; bool get ritual;@JsonKey(fromJson: _spellRange) SpellRange get range; SpellComponents get components; int? get materialCostCp; bool get materialConsumed;/// Durée, telle que dans le SRD (« instantanée », « 1 heure »…).
 String get duration; bool get concentration;
/// Create a copy of SpellData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpellDataCopyWith<SpellData> get copyWith => _$SpellDataCopyWithImpl<SpellData>(this as SpellData, _$identity);

  /// Serializes this SpellData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SpellData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpellData&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.school, _this.school) || other.school == _this.school)&&(identical(other.castingTime, _this.castingTime) || other.castingTime == _this.castingTime)&&(identical(other.ritual, _this.ritual) || other.ritual == _this.ritual)&&(identical(other.range, _this.range) || other.range == _this.range)&&(identical(other.components, _this.components) || other.components == _this.components)&&(identical(other.materialCostCp, _this.materialCostCp) || other.materialCostCp == _this.materialCostCp)&&(identical(other.materialConsumed, _this.materialConsumed) || other.materialConsumed == _this.materialConsumed)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&(identical(other.concentration, _this.concentration) || other.concentration == _this.concentration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SpellData;
  return Object.hash(runtimeType,_this.level,_this.school,_this.castingTime,_this.ritual,_this.range,_this.components,_this.materialCostCp,_this.materialConsumed,_this.duration,_this.concentration);
}

@override
String toString() {
  final _this = this as SpellData;
  return 'SpellData(level: ${_this.level}, school: ${_this.school}, castingTime: ${_this.castingTime}, ritual: ${_this.ritual}, range: ${_this.range}, components: ${_this.components}, materialCostCp: ${_this.materialCostCp}, materialConsumed: ${_this.materialConsumed}, duration: ${_this.duration}, concentration: ${_this.concentration})';
}


}

/// @nodoc
abstract mixin class $SpellDataCopyWith<$Res>  {
  factory $SpellDataCopyWith(SpellData value, $Res Function(SpellData) _then) = _$SpellDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _spellLevel) int level, SpellSchool school, String castingTime, bool ritual,@JsonKey(fromJson: _spellRange) SpellRange range, SpellComponents components, int? materialCostCp, bool materialConsumed, String duration, bool concentration
});


$SpellRangeCopyWith<$Res> get range;$SpellComponentsCopyWith<$Res> get components;

}
/// @nodoc
class _$SpellDataCopyWithImpl<$Res>
    implements $SpellDataCopyWith<$Res> {
  _$SpellDataCopyWithImpl(this._self, this._then);

  final SpellData _self;
  final $Res Function(SpellData) _then;

/// Create a copy of SpellData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? school = null,Object? castingTime = null,Object? ritual = null,Object? range = null,Object? components = null,Object? materialCostCp = freezed,Object? materialConsumed = null,Object? duration = null,Object? concentration = null,}) {
  return _then(SpellData(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,school: null == school ? _self.school : school // ignore: cast_nullable_to_non_nullable
as SpellSchool,castingTime: null == castingTime ? _self.castingTime : castingTime // ignore: cast_nullable_to_non_nullable
as String,ritual: null == ritual ? _self.ritual : ritual // ignore: cast_nullable_to_non_nullable
as bool,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as SpellRange,components: null == components ? _self.components : components // ignore: cast_nullable_to_non_nullable
as SpellComponents,materialCostCp: freezed == materialCostCp ? _self.materialCostCp : materialCostCp // ignore: cast_nullable_to_non_nullable
as int?,materialConsumed: null == materialConsumed ? _self.materialConsumed : materialConsumed // ignore: cast_nullable_to_non_nullable
as bool,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,concentration: null == concentration ? _self.concentration : concentration // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of SpellData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpellRangeCopyWith<$Res> get range {
  
  return $SpellRangeCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}/// Create a copy of SpellData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpellComponentsCopyWith<$Res> get components {
  
  return $SpellComponentsCopyWith<$Res>(_self.components, (value) {
    return _then(_self.copyWith(components: value));
  });
}
}


/// Adds pattern-matching-related methods to [SpellData].
extension SpellDataPatterns on SpellData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpellData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpellData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpellData value)  $default,){
final _that = this;
switch (_that) {
case _SpellData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpellData value)?  $default,){
final _that = this;
switch (_that) {
case _SpellData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _spellLevel)  int level,  SpellSchool school,  String castingTime,  bool ritual, @JsonKey(fromJson: _spellRange)  SpellRange range,  SpellComponents components,  int? materialCostCp,  bool materialConsumed,  String duration,  bool concentration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpellData() when $default != null:
return $default(_that.level,_that.school,_that.castingTime,_that.ritual,_that.range,_that.components,_that.materialCostCp,_that.materialConsumed,_that.duration,_that.concentration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _spellLevel)  int level,  SpellSchool school,  String castingTime,  bool ritual, @JsonKey(fromJson: _spellRange)  SpellRange range,  SpellComponents components,  int? materialCostCp,  bool materialConsumed,  String duration,  bool concentration)  $default,) {final _that = this;
switch (_that) {
case _SpellData():
return $default(_that.level,_that.school,_that.castingTime,_that.ritual,_that.range,_that.components,_that.materialCostCp,_that.materialConsumed,_that.duration,_that.concentration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _spellLevel)  int level,  SpellSchool school,  String castingTime,  bool ritual, @JsonKey(fromJson: _spellRange)  SpellRange range,  SpellComponents components,  int? materialCostCp,  bool materialConsumed,  String duration,  bool concentration)?  $default,) {final _that = this;
switch (_that) {
case _SpellData() when $default != null:
return $default(_that.level,_that.school,_that.castingTime,_that.ritual,_that.range,_that.components,_that.materialCostCp,_that.materialConsumed,_that.duration,_that.concentration);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpellData implements SpellData {
  const _SpellData({@JsonKey(fromJson: _spellLevel) required this.level, required this.school, required this.castingTime, required this.ritual, @JsonKey(fromJson: _spellRange) required this.range, required this.components, this.materialCostCp, required this.materialConsumed, required this.duration, required this.concentration});
  factory _SpellData.fromJson(Map<String, dynamic> json) => _$SpellDataFromJson(json);

@override@JsonKey(fromJson: _spellLevel) final  int level;
@override final  SpellSchool school;
/// Temps d'incantation, tel que dans le SRD (« action », « 1 minute »…).
@override final  String castingTime;
@override final  bool ritual;
@override@JsonKey(fromJson: _spellRange) final  SpellRange range;
@override final  SpellComponents components;
@override final  int? materialCostCp;
@override final  bool materialConsumed;
/// Durée, telle que dans le SRD (« instantanée », « 1 heure »…).
@override final  String duration;
@override final  bool concentration;

/// Create a copy of SpellData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpellDataCopyWith<_SpellData> get copyWith => __$SpellDataCopyWithImpl<_SpellData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpellDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpellData&&(identical(other.level, level) || other.level == level)&&(identical(other.school, school) || other.school == school)&&(identical(other.castingTime, castingTime) || other.castingTime == castingTime)&&(identical(other.ritual, ritual) || other.ritual == ritual)&&(identical(other.range, range) || other.range == range)&&(identical(other.components, components) || other.components == components)&&(identical(other.materialCostCp, materialCostCp) || other.materialCostCp == materialCostCp)&&(identical(other.materialConsumed, materialConsumed) || other.materialConsumed == materialConsumed)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.concentration, concentration) || other.concentration == concentration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,level,school,castingTime,ritual,range,components,materialCostCp,materialConsumed,duration,concentration);
}

@override
String toString() {
    return 'SpellData(level: $level, school: $school, castingTime: $castingTime, ritual: $ritual, range: $range, components: $components, materialCostCp: $materialCostCp, materialConsumed: $materialConsumed, duration: $duration, concentration: $concentration)';
}


}

/// @nodoc
abstract mixin class _$SpellDataCopyWith<$Res> implements $SpellDataCopyWith<$Res> {
  factory _$SpellDataCopyWith(_SpellData value, $Res Function(_SpellData) _then) = __$SpellDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _spellLevel) int level, SpellSchool school, String castingTime, bool ritual,@JsonKey(fromJson: _spellRange) SpellRange range, SpellComponents components, int? materialCostCp, bool materialConsumed, String duration, bool concentration
});


@override $SpellRangeCopyWith<$Res> get range;@override $SpellComponentsCopyWith<$Res> get components;

}
/// @nodoc
class __$SpellDataCopyWithImpl<$Res>
    implements _$SpellDataCopyWith<$Res> {
  __$SpellDataCopyWithImpl(this._self, this._then);

  final _SpellData _self;
  final $Res Function(_SpellData) _then;

/// Create a copy of SpellData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? school = null,Object? castingTime = null,Object? ritual = null,Object? range = null,Object? components = null,Object? materialCostCp = freezed,Object? materialConsumed = null,Object? duration = null,Object? concentration = null,}) {
  return _then(_SpellData(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,school: null == school ? _self.school : school // ignore: cast_nullable_to_non_nullable
as SpellSchool,castingTime: null == castingTime ? _self.castingTime : castingTime // ignore: cast_nullable_to_non_nullable
as String,ritual: null == ritual ? _self.ritual : ritual // ignore: cast_nullable_to_non_nullable
as bool,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as SpellRange,components: null == components ? _self.components : components // ignore: cast_nullable_to_non_nullable
as SpellComponents,materialCostCp: freezed == materialCostCp ? _self.materialCostCp : materialCostCp // ignore: cast_nullable_to_non_nullable
as int?,materialConsumed: null == materialConsumed ? _self.materialConsumed : materialConsumed // ignore: cast_nullable_to_non_nullable
as bool,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,concentration: null == concentration ? _self.concentration : concentration // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SpellData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpellRangeCopyWith<$Res> get range {
  
  return $SpellRangeCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}/// Create a copy of SpellData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpellComponentsCopyWith<$Res> get components {
  
  return $SpellComponentsCopyWith<$Res>(_self.components, (value) {
    return _then(_self.copyWith(components: value));
  });
}
}


/// @nodoc
mixin _$MonsterSpeed {

 int? get walk; int? get swim; int? get fly; int? get climb; int? get burrow;
/// Create a copy of MonsterSpeed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonsterSpeedCopyWith<MonsterSpeed> get copyWith => _$MonsterSpeedCopyWithImpl<MonsterSpeed>(this as MonsterSpeed, _$identity);

  /// Serializes this MonsterSpeed to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MonsterSpeed;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonsterSpeed&&(identical(other.walk, _this.walk) || other.walk == _this.walk)&&(identical(other.swim, _this.swim) || other.swim == _this.swim)&&(identical(other.fly, _this.fly) || other.fly == _this.fly)&&(identical(other.climb, _this.climb) || other.climb == _this.climb)&&(identical(other.burrow, _this.burrow) || other.burrow == _this.burrow));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MonsterSpeed;
  return Object.hash(runtimeType,_this.walk,_this.swim,_this.fly,_this.climb,_this.burrow);
}

@override
String toString() {
  final _this = this as MonsterSpeed;
  return 'MonsterSpeed(walk: ${_this.walk}, swim: ${_this.swim}, fly: ${_this.fly}, climb: ${_this.climb}, burrow: ${_this.burrow})';
}


}

/// @nodoc
abstract mixin class $MonsterSpeedCopyWith<$Res>  {
  factory $MonsterSpeedCopyWith(MonsterSpeed value, $Res Function(MonsterSpeed) _then) = _$MonsterSpeedCopyWithImpl;
@useResult
$Res call({
 int? walk, int? swim, int? fly, int? climb, int? burrow
});




}
/// @nodoc
class _$MonsterSpeedCopyWithImpl<$Res>
    implements $MonsterSpeedCopyWith<$Res> {
  _$MonsterSpeedCopyWithImpl(this._self, this._then);

  final MonsterSpeed _self;
  final $Res Function(MonsterSpeed) _then;

/// Create a copy of MonsterSpeed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? walk = freezed,Object? swim = freezed,Object? fly = freezed,Object? climb = freezed,Object? burrow = freezed,}) {
  return _then(MonsterSpeed(
walk: freezed == walk ? _self.walk : walk // ignore: cast_nullable_to_non_nullable
as int?,swim: freezed == swim ? _self.swim : swim // ignore: cast_nullable_to_non_nullable
as int?,fly: freezed == fly ? _self.fly : fly // ignore: cast_nullable_to_non_nullable
as int?,climb: freezed == climb ? _self.climb : climb // ignore: cast_nullable_to_non_nullable
as int?,burrow: freezed == burrow ? _self.burrow : burrow // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MonsterSpeed].
extension MonsterSpeedPatterns on MonsterSpeed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonsterSpeed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonsterSpeed() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonsterSpeed value)  $default,){
final _that = this;
switch (_that) {
case _MonsterSpeed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonsterSpeed value)?  $default,){
final _that = this;
switch (_that) {
case _MonsterSpeed() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? walk,  int? swim,  int? fly,  int? climb,  int? burrow)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonsterSpeed() when $default != null:
return $default(_that.walk,_that.swim,_that.fly,_that.climb,_that.burrow);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? walk,  int? swim,  int? fly,  int? climb,  int? burrow)  $default,) {final _that = this;
switch (_that) {
case _MonsterSpeed():
return $default(_that.walk,_that.swim,_that.fly,_that.climb,_that.burrow);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? walk,  int? swim,  int? fly,  int? climb,  int? burrow)?  $default,) {final _that = this;
switch (_that) {
case _MonsterSpeed() when $default != null:
return $default(_that.walk,_that.swim,_that.fly,_that.climb,_that.burrow);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonsterSpeed implements MonsterSpeed {
  const _MonsterSpeed({this.walk, this.swim, this.fly, this.climb, this.burrow});
  factory _MonsterSpeed.fromJson(Map<String, dynamic> json) => _$MonsterSpeedFromJson(json);

@override final  int? walk;
@override final  int? swim;
@override final  int? fly;
@override final  int? climb;
@override final  int? burrow;

/// Create a copy of MonsterSpeed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonsterSpeedCopyWith<_MonsterSpeed> get copyWith => __$MonsterSpeedCopyWithImpl<_MonsterSpeed>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonsterSpeedToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonsterSpeed&&(identical(other.walk, walk) || other.walk == walk)&&(identical(other.swim, swim) || other.swim == swim)&&(identical(other.fly, fly) || other.fly == fly)&&(identical(other.climb, climb) || other.climb == climb)&&(identical(other.burrow, burrow) || other.burrow == burrow));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,walk,swim,fly,climb,burrow);
}

@override
String toString() {
    return 'MonsterSpeed(walk: $walk, swim: $swim, fly: $fly, climb: $climb, burrow: $burrow)';
}


}

/// @nodoc
abstract mixin class _$MonsterSpeedCopyWith<$Res> implements $MonsterSpeedCopyWith<$Res> {
  factory _$MonsterSpeedCopyWith(_MonsterSpeed value, $Res Function(_MonsterSpeed) _then) = __$MonsterSpeedCopyWithImpl;
@override @useResult
$Res call({
 int? walk, int? swim, int? fly, int? climb, int? burrow
});




}
/// @nodoc
class __$MonsterSpeedCopyWithImpl<$Res>
    implements _$MonsterSpeedCopyWith<$Res> {
  __$MonsterSpeedCopyWithImpl(this._self, this._then);

  final _MonsterSpeed _self;
  final $Res Function(_MonsterSpeed) _then;

/// Create a copy of MonsterSpeed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? walk = freezed,Object? swim = freezed,Object? fly = freezed,Object? climb = freezed,Object? burrow = freezed,}) {
  return _then(_MonsterSpeed(
walk: freezed == walk ? _self.walk : walk // ignore: cast_nullable_to_non_nullable
as int?,swim: freezed == swim ? _self.swim : swim // ignore: cast_nullable_to_non_nullable
as int?,fly: freezed == fly ? _self.fly : fly // ignore: cast_nullable_to_non_nullable
as int?,climb: freezed == climb ? _self.climb : climb // ignore: cast_nullable_to_non_nullable
as int?,burrow: freezed == burrow ? _self.burrow : burrow // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$MonsterSenses {

 int? get darkvision; int? get blindsight;/// `true` pour « (aveugle au-delà) » après la Vision aveugle.
 bool? get blindBeyond; int? get tremorsense; int? get truesight;
/// Create a copy of MonsterSenses
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonsterSensesCopyWith<MonsterSenses> get copyWith => _$MonsterSensesCopyWithImpl<MonsterSenses>(this as MonsterSenses, _$identity);

  /// Serializes this MonsterSenses to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MonsterSenses;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonsterSenses&&(identical(other.darkvision, _this.darkvision) || other.darkvision == _this.darkvision)&&(identical(other.blindsight, _this.blindsight) || other.blindsight == _this.blindsight)&&(identical(other.blindBeyond, _this.blindBeyond) || other.blindBeyond == _this.blindBeyond)&&(identical(other.tremorsense, _this.tremorsense) || other.tremorsense == _this.tremorsense)&&(identical(other.truesight, _this.truesight) || other.truesight == _this.truesight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MonsterSenses;
  return Object.hash(runtimeType,_this.darkvision,_this.blindsight,_this.blindBeyond,_this.tremorsense,_this.truesight);
}

@override
String toString() {
  final _this = this as MonsterSenses;
  return 'MonsterSenses(darkvision: ${_this.darkvision}, blindsight: ${_this.blindsight}, blindBeyond: ${_this.blindBeyond}, tremorsense: ${_this.tremorsense}, truesight: ${_this.truesight})';
}


}

/// @nodoc
abstract mixin class $MonsterSensesCopyWith<$Res>  {
  factory $MonsterSensesCopyWith(MonsterSenses value, $Res Function(MonsterSenses) _then) = _$MonsterSensesCopyWithImpl;
@useResult
$Res call({
 int? darkvision, int? blindsight, bool? blindBeyond, int? tremorsense, int? truesight
});




}
/// @nodoc
class _$MonsterSensesCopyWithImpl<$Res>
    implements $MonsterSensesCopyWith<$Res> {
  _$MonsterSensesCopyWithImpl(this._self, this._then);

  final MonsterSenses _self;
  final $Res Function(MonsterSenses) _then;

/// Create a copy of MonsterSenses
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? darkvision = freezed,Object? blindsight = freezed,Object? blindBeyond = freezed,Object? tremorsense = freezed,Object? truesight = freezed,}) {
  return _then(MonsterSenses(
darkvision: freezed == darkvision ? _self.darkvision : darkvision // ignore: cast_nullable_to_non_nullable
as int?,blindsight: freezed == blindsight ? _self.blindsight : blindsight // ignore: cast_nullable_to_non_nullable
as int?,blindBeyond: freezed == blindBeyond ? _self.blindBeyond : blindBeyond // ignore: cast_nullable_to_non_nullable
as bool?,tremorsense: freezed == tremorsense ? _self.tremorsense : tremorsense // ignore: cast_nullable_to_non_nullable
as int?,truesight: freezed == truesight ? _self.truesight : truesight // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MonsterSenses].
extension MonsterSensesPatterns on MonsterSenses {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonsterSenses value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonsterSenses() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonsterSenses value)  $default,){
final _that = this;
switch (_that) {
case _MonsterSenses():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonsterSenses value)?  $default,){
final _that = this;
switch (_that) {
case _MonsterSenses() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? darkvision,  int? blindsight,  bool? blindBeyond,  int? tremorsense,  int? truesight)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonsterSenses() when $default != null:
return $default(_that.darkvision,_that.blindsight,_that.blindBeyond,_that.tremorsense,_that.truesight);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? darkvision,  int? blindsight,  bool? blindBeyond,  int? tremorsense,  int? truesight)  $default,) {final _that = this;
switch (_that) {
case _MonsterSenses():
return $default(_that.darkvision,_that.blindsight,_that.blindBeyond,_that.tremorsense,_that.truesight);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? darkvision,  int? blindsight,  bool? blindBeyond,  int? tremorsense,  int? truesight)?  $default,) {final _that = this;
switch (_that) {
case _MonsterSenses() when $default != null:
return $default(_that.darkvision,_that.blindsight,_that.blindBeyond,_that.tremorsense,_that.truesight);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonsterSenses implements MonsterSenses {
  const _MonsterSenses({this.darkvision, this.blindsight, this.blindBeyond, this.tremorsense, this.truesight});
  factory _MonsterSenses.fromJson(Map<String, dynamic> json) => _$MonsterSensesFromJson(json);

@override final  int? darkvision;
@override final  int? blindsight;
/// `true` pour « (aveugle au-delà) » après la Vision aveugle.
@override final  bool? blindBeyond;
@override final  int? tremorsense;
@override final  int? truesight;

/// Create a copy of MonsterSenses
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonsterSensesCopyWith<_MonsterSenses> get copyWith => __$MonsterSensesCopyWithImpl<_MonsterSenses>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonsterSensesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonsterSenses&&(identical(other.darkvision, darkvision) || other.darkvision == darkvision)&&(identical(other.blindsight, blindsight) || other.blindsight == blindsight)&&(identical(other.blindBeyond, blindBeyond) || other.blindBeyond == blindBeyond)&&(identical(other.tremorsense, tremorsense) || other.tremorsense == tremorsense)&&(identical(other.truesight, truesight) || other.truesight == truesight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,darkvision,blindsight,blindBeyond,tremorsense,truesight);
}

@override
String toString() {
    return 'MonsterSenses(darkvision: $darkvision, blindsight: $blindsight, blindBeyond: $blindBeyond, tremorsense: $tremorsense, truesight: $truesight)';
}


}

/// @nodoc
abstract mixin class _$MonsterSensesCopyWith<$Res> implements $MonsterSensesCopyWith<$Res> {
  factory _$MonsterSensesCopyWith(_MonsterSenses value, $Res Function(_MonsterSenses) _then) = __$MonsterSensesCopyWithImpl;
@override @useResult
$Res call({
 int? darkvision, int? blindsight, bool? blindBeyond, int? tremorsense, int? truesight
});




}
/// @nodoc
class __$MonsterSensesCopyWithImpl<$Res>
    implements _$MonsterSensesCopyWith<$Res> {
  __$MonsterSensesCopyWithImpl(this._self, this._then);

  final _MonsterSenses _self;
  final $Res Function(_MonsterSenses) _then;

/// Create a copy of MonsterSenses
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? darkvision = freezed,Object? blindsight = freezed,Object? blindBeyond = freezed,Object? tremorsense = freezed,Object? truesight = freezed,}) {
  return _then(_MonsterSenses(
darkvision: freezed == darkvision ? _self.darkvision : darkvision // ignore: cast_nullable_to_non_nullable
as int?,blindsight: freezed == blindsight ? _self.blindsight : blindsight // ignore: cast_nullable_to_non_nullable
as int?,blindBeyond: freezed == blindBeyond ? _self.blindBeyond : blindBeyond // ignore: cast_nullable_to_non_nullable
as bool?,tremorsense: freezed == tremorsense ? _self.tremorsense : tremorsense // ignore: cast_nullable_to_non_nullable
as int?,truesight: freezed == truesight ? _self.truesight : truesight // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$MonsterUses {

 int? get perDay; int? get perDayLair; String? get recharge;/// `short_or_long` ou `long`.
 String? get rest;
/// Create a copy of MonsterUses
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonsterUsesCopyWith<MonsterUses> get copyWith => _$MonsterUsesCopyWithImpl<MonsterUses>(this as MonsterUses, _$identity);

  /// Serializes this MonsterUses to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MonsterUses;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonsterUses&&(identical(other.perDay, _this.perDay) || other.perDay == _this.perDay)&&(identical(other.perDayLair, _this.perDayLair) || other.perDayLair == _this.perDayLair)&&(identical(other.recharge, _this.recharge) || other.recharge == _this.recharge)&&(identical(other.rest, _this.rest) || other.rest == _this.rest));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MonsterUses;
  return Object.hash(runtimeType,_this.perDay,_this.perDayLair,_this.recharge,_this.rest);
}

@override
String toString() {
  final _this = this as MonsterUses;
  return 'MonsterUses(perDay: ${_this.perDay}, perDayLair: ${_this.perDayLair}, recharge: ${_this.recharge}, rest: ${_this.rest})';
}


}

/// @nodoc
abstract mixin class $MonsterUsesCopyWith<$Res>  {
  factory $MonsterUsesCopyWith(MonsterUses value, $Res Function(MonsterUses) _then) = _$MonsterUsesCopyWithImpl;
@useResult
$Res call({
 int? perDay, int? perDayLair, String? recharge, String? rest
});




}
/// @nodoc
class _$MonsterUsesCopyWithImpl<$Res>
    implements $MonsterUsesCopyWith<$Res> {
  _$MonsterUsesCopyWithImpl(this._self, this._then);

  final MonsterUses _self;
  final $Res Function(MonsterUses) _then;

/// Create a copy of MonsterUses
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? perDay = freezed,Object? perDayLair = freezed,Object? recharge = freezed,Object? rest = freezed,}) {
  return _then(MonsterUses(
perDay: freezed == perDay ? _self.perDay : perDay // ignore: cast_nullable_to_non_nullable
as int?,perDayLair: freezed == perDayLair ? _self.perDayLair : perDayLair // ignore: cast_nullable_to_non_nullable
as int?,recharge: freezed == recharge ? _self.recharge : recharge // ignore: cast_nullable_to_non_nullable
as String?,rest: freezed == rest ? _self.rest : rest // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MonsterUses].
extension MonsterUsesPatterns on MonsterUses {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonsterUses value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonsterUses() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonsterUses value)  $default,){
final _that = this;
switch (_that) {
case _MonsterUses():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonsterUses value)?  $default,){
final _that = this;
switch (_that) {
case _MonsterUses() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? perDay,  int? perDayLair,  String? recharge,  String? rest)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonsterUses() when $default != null:
return $default(_that.perDay,_that.perDayLair,_that.recharge,_that.rest);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? perDay,  int? perDayLair,  String? recharge,  String? rest)  $default,) {final _that = this;
switch (_that) {
case _MonsterUses():
return $default(_that.perDay,_that.perDayLair,_that.recharge,_that.rest);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? perDay,  int? perDayLair,  String? recharge,  String? rest)?  $default,) {final _that = this;
switch (_that) {
case _MonsterUses() when $default != null:
return $default(_that.perDay,_that.perDayLair,_that.recharge,_that.rest);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonsterUses extends MonsterUses {
  const _MonsterUses({this.perDay, this.perDayLair, this.recharge, this.rest}): super._();
  factory _MonsterUses.fromJson(Map<String, dynamic> json) => _$MonsterUsesFromJson(json);

@override final  int? perDay;
@override final  int? perDayLair;
@override final  String? recharge;
/// `short_or_long` ou `long`.
@override final  String? rest;

/// Create a copy of MonsterUses
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonsterUsesCopyWith<_MonsterUses> get copyWith => __$MonsterUsesCopyWithImpl<_MonsterUses>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonsterUsesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonsterUses&&(identical(other.perDay, perDay) || other.perDay == perDay)&&(identical(other.perDayLair, perDayLair) || other.perDayLair == perDayLair)&&(identical(other.recharge, recharge) || other.recharge == recharge)&&(identical(other.rest, rest) || other.rest == rest));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,perDay,perDayLair,recharge,rest);
}

@override
String toString() {
    return 'MonsterUses(perDay: $perDay, perDayLair: $perDayLair, recharge: $recharge, rest: $rest)';
}


}

/// @nodoc
abstract mixin class _$MonsterUsesCopyWith<$Res> implements $MonsterUsesCopyWith<$Res> {
  factory _$MonsterUsesCopyWith(_MonsterUses value, $Res Function(_MonsterUses) _then) = __$MonsterUsesCopyWithImpl;
@override @useResult
$Res call({
 int? perDay, int? perDayLair, String? recharge, String? rest
});




}
/// @nodoc
class __$MonsterUsesCopyWithImpl<$Res>
    implements _$MonsterUsesCopyWith<$Res> {
  __$MonsterUsesCopyWithImpl(this._self, this._then);

  final _MonsterUses _self;
  final $Res Function(_MonsterUses) _then;

/// Create a copy of MonsterUses
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? perDay = freezed,Object? perDayLair = freezed,Object? recharge = freezed,Object? rest = freezed,}) {
  return _then(_MonsterUses(
perDay: freezed == perDay ? _self.perDay : perDay // ignore: cast_nullable_to_non_nullable
as int?,perDayLair: freezed == perDayLair ? _self.perDayLair : perDayLair // ignore: cast_nullable_to_non_nullable
as int?,recharge: freezed == recharge ? _self.recharge : recharge // ignore: cast_nullable_to_non_nullable
as String?,rest: freezed == rest ? _self.rest : rest // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MonsterDamage {

 int get average;/// Absent pour des dégâts fixes (« Touché : 1 dégât perforant »).
 String? get dice;@ContentIdConverter() ContentId get type;
/// Create a copy of MonsterDamage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonsterDamageCopyWith<MonsterDamage> get copyWith => _$MonsterDamageCopyWithImpl<MonsterDamage>(this as MonsterDamage, _$identity);

  /// Serializes this MonsterDamage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MonsterDamage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonsterDamage&&(identical(other.average, _this.average) || other.average == _this.average)&&(identical(other.dice, _this.dice) || other.dice == _this.dice)&&(identical(other.type, _this.type) || other.type == _this.type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MonsterDamage;
  return Object.hash(runtimeType,_this.average,_this.dice,_this.type);
}

@override
String toString() {
  final _this = this as MonsterDamage;
  return 'MonsterDamage(average: ${_this.average}, dice: ${_this.dice}, type: ${_this.type})';
}


}

/// @nodoc
abstract mixin class $MonsterDamageCopyWith<$Res>  {
  factory $MonsterDamageCopyWith(MonsterDamage value, $Res Function(MonsterDamage) _then) = _$MonsterDamageCopyWithImpl;
@useResult
$Res call({
 int average, String? dice,@ContentIdConverter() ContentId type
});




}
/// @nodoc
class _$MonsterDamageCopyWithImpl<$Res>
    implements $MonsterDamageCopyWith<$Res> {
  _$MonsterDamageCopyWithImpl(this._self, this._then);

  final MonsterDamage _self;
  final $Res Function(MonsterDamage) _then;

/// Create a copy of MonsterDamage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? average = null,Object? dice = freezed,Object? type = null,}) {
  return _then(MonsterDamage(
average: null == average ? _self.average : average // ignore: cast_nullable_to_non_nullable
as int,dice: freezed == dice ? _self.dice : dice // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ContentId,
  ));
}

}


/// Adds pattern-matching-related methods to [MonsterDamage].
extension MonsterDamagePatterns on MonsterDamage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonsterDamage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonsterDamage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonsterDamage value)  $default,){
final _that = this;
switch (_that) {
case _MonsterDamage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonsterDamage value)?  $default,){
final _that = this;
switch (_that) {
case _MonsterDamage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int average,  String? dice, @ContentIdConverter()  ContentId type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonsterDamage() when $default != null:
return $default(_that.average,_that.dice,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int average,  String? dice, @ContentIdConverter()  ContentId type)  $default,) {final _that = this;
switch (_that) {
case _MonsterDamage():
return $default(_that.average,_that.dice,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int average,  String? dice, @ContentIdConverter()  ContentId type)?  $default,) {final _that = this;
switch (_that) {
case _MonsterDamage() when $default != null:
return $default(_that.average,_that.dice,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonsterDamage implements MonsterDamage {
  const _MonsterDamage({required this.average, this.dice, @ContentIdConverter() required this.type});
  factory _MonsterDamage.fromJson(Map<String, dynamic> json) => _$MonsterDamageFromJson(json);

@override final  int average;
/// Absent pour des dégâts fixes (« Touché : 1 dégât perforant »).
@override final  String? dice;
@override@ContentIdConverter() final  ContentId type;

/// Create a copy of MonsterDamage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonsterDamageCopyWith<_MonsterDamage> get copyWith => __$MonsterDamageCopyWithImpl<_MonsterDamage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonsterDamageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonsterDamage&&(identical(other.average, average) || other.average == average)&&(identical(other.dice, dice) || other.dice == dice)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,average,dice,type);
}

@override
String toString() {
    return 'MonsterDamage(average: $average, dice: $dice, type: $type)';
}


}

/// @nodoc
abstract mixin class _$MonsterDamageCopyWith<$Res> implements $MonsterDamageCopyWith<$Res> {
  factory _$MonsterDamageCopyWith(_MonsterDamage value, $Res Function(_MonsterDamage) _then) = __$MonsterDamageCopyWithImpl;
@override @useResult
$Res call({
 int average, String? dice,@ContentIdConverter() ContentId type
});




}
/// @nodoc
class __$MonsterDamageCopyWithImpl<$Res>
    implements _$MonsterDamageCopyWith<$Res> {
  __$MonsterDamageCopyWithImpl(this._self, this._then);

  final _MonsterDamage _self;
  final $Res Function(_MonsterDamage) _then;

/// Create a copy of MonsterDamage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? average = null,Object? dice = freezed,Object? type = null,}) {
  return _then(_MonsterDamage(
average: null == average ? _self.average : average // ignore: cast_nullable_to_non_nullable
as int,dice: freezed == dice ? _self.dice : dice // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ContentId,
  ));
}


}


/// @nodoc
mixin _$MonsterAttack {

 MonsterAttackKind get kind; int get bonus; int? get reach; List<int>? get range; List<MonsterDamage> get damage;
/// Create a copy of MonsterAttack
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonsterAttackCopyWith<MonsterAttack> get copyWith => _$MonsterAttackCopyWithImpl<MonsterAttack>(this as MonsterAttack, _$identity);

  /// Serializes this MonsterAttack to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MonsterAttack;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonsterAttack&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.bonus, _this.bonus) || other.bonus == _this.bonus)&&(identical(other.reach, _this.reach) || other.reach == _this.reach)&&const DeepCollectionEquality().equals(other.range, _this.range)&&const DeepCollectionEquality().equals(other.damage, _this.damage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MonsterAttack;
  return Object.hash(runtimeType,_this.kind,_this.bonus,_this.reach,const DeepCollectionEquality().hash(_this.range),const DeepCollectionEquality().hash(_this.damage));
}

@override
String toString() {
  final _this = this as MonsterAttack;
  return 'MonsterAttack(kind: ${_this.kind}, bonus: ${_this.bonus}, reach: ${_this.reach}, range: ${_this.range}, damage: ${_this.damage})';
}


}

/// @nodoc
abstract mixin class $MonsterAttackCopyWith<$Res>  {
  factory $MonsterAttackCopyWith(MonsterAttack value, $Res Function(MonsterAttack) _then) = _$MonsterAttackCopyWithImpl;
@useResult
$Res call({
 MonsterAttackKind kind, int bonus, int? reach, List<int>? range, List<MonsterDamage> damage
});




}
/// @nodoc
class _$MonsterAttackCopyWithImpl<$Res>
    implements $MonsterAttackCopyWith<$Res> {
  _$MonsterAttackCopyWithImpl(this._self, this._then);

  final MonsterAttack _self;
  final $Res Function(MonsterAttack) _then;

/// Create a copy of MonsterAttack
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? bonus = null,Object? reach = freezed,Object? range = freezed,Object? damage = null,}) {
  return _then(MonsterAttack(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MonsterAttackKind,bonus: null == bonus ? _self.bonus : bonus // ignore: cast_nullable_to_non_nullable
as int,reach: freezed == reach ? _self.reach : reach // ignore: cast_nullable_to_non_nullable
as int?,range: freezed == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as List<int>?,damage: null == damage ? _self.damage : damage // ignore: cast_nullable_to_non_nullable
as List<MonsterDamage>,
  ));
}

}


/// Adds pattern-matching-related methods to [MonsterAttack].
extension MonsterAttackPatterns on MonsterAttack {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonsterAttack value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonsterAttack() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonsterAttack value)  $default,){
final _that = this;
switch (_that) {
case _MonsterAttack():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonsterAttack value)?  $default,){
final _that = this;
switch (_that) {
case _MonsterAttack() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MonsterAttackKind kind,  int bonus,  int? reach,  List<int>? range,  List<MonsterDamage> damage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonsterAttack() when $default != null:
return $default(_that.kind,_that.bonus,_that.reach,_that.range,_that.damage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MonsterAttackKind kind,  int bonus,  int? reach,  List<int>? range,  List<MonsterDamage> damage)  $default,) {final _that = this;
switch (_that) {
case _MonsterAttack():
return $default(_that.kind,_that.bonus,_that.reach,_that.range,_that.damage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MonsterAttackKind kind,  int bonus,  int? reach,  List<int>? range,  List<MonsterDamage> damage)?  $default,) {final _that = this;
switch (_that) {
case _MonsterAttack() when $default != null:
return $default(_that.kind,_that.bonus,_that.reach,_that.range,_that.damage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonsterAttack implements MonsterAttack {
  const _MonsterAttack({required this.kind, required this.bonus, this.reach,  List<int>? range,  List<MonsterDamage> damage = const <MonsterDamage>[]}): _range = range,_damage = damage;
  factory _MonsterAttack.fromJson(Map<String, dynamic> json) => _$MonsterAttackFromJson(json);

@override final  MonsterAttackKind kind;
@override final  int bonus;
@override final  int? reach;
 final  List<int>? _range;
@override List<int>? get range {
  final value = _range;
  if (value == null) return null;
  if (_range is EqualUnmodifiableListView) return _range;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<MonsterDamage> _damage;
@override@JsonKey() List<MonsterDamage> get damage {
  if (_damage is EqualUnmodifiableListView) return _damage;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_damage);
}


/// Create a copy of MonsterAttack
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonsterAttackCopyWith<_MonsterAttack> get copyWith => __$MonsterAttackCopyWithImpl<_MonsterAttack>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonsterAttackToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonsterAttack&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.bonus, bonus) || other.bonus == bonus)&&(identical(other.reach, reach) || other.reach == reach)&&const DeepCollectionEquality().equals(other.range, _range)&&const DeepCollectionEquality().equals(other.damage, _damage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,bonus,reach,const DeepCollectionEquality().hash(_range),const DeepCollectionEquality().hash(_damage));
}

@override
String toString() {
    return 'MonsterAttack(kind: $kind, bonus: $bonus, reach: $reach, range: $range, damage: $damage)';
}


}

/// @nodoc
abstract mixin class _$MonsterAttackCopyWith<$Res> implements $MonsterAttackCopyWith<$Res> {
  factory _$MonsterAttackCopyWith(_MonsterAttack value, $Res Function(_MonsterAttack) _then) = __$MonsterAttackCopyWithImpl;
@override @useResult
$Res call({
 MonsterAttackKind kind, int bonus, int? reach, List<int>? range, List<MonsterDamage> damage
});




}
/// @nodoc
class __$MonsterAttackCopyWithImpl<$Res>
    implements _$MonsterAttackCopyWith<$Res> {
  __$MonsterAttackCopyWithImpl(this._self, this._then);

  final _MonsterAttack _self;
  final $Res Function(_MonsterAttack) _then;

/// Create a copy of MonsterAttack
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? bonus = null,Object? reach = freezed,Object? range = freezed,Object? damage = null,}) {
  return _then(_MonsterAttack(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MonsterAttackKind,bonus: null == bonus ? _self.bonus : bonus // ignore: cast_nullable_to_non_nullable
as int,reach: freezed == reach ? _self.reach : reach // ignore: cast_nullable_to_non_nullable
as int?,range: freezed == range ? _self._range : range // ignore: cast_nullable_to_non_nullable
as List<int>?,damage: null == damage ? _self._damage : damage // ignore: cast_nullable_to_non_nullable
as List<MonsterDamage>,
  ));
}


}


/// @nodoc
mixin _$MonsterSave {

 String get ability; int get dc;
/// Create a copy of MonsterSave
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonsterSaveCopyWith<MonsterSave> get copyWith => _$MonsterSaveCopyWithImpl<MonsterSave>(this as MonsterSave, _$identity);

  /// Serializes this MonsterSave to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MonsterSave;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonsterSave&&(identical(other.ability, _this.ability) || other.ability == _this.ability)&&(identical(other.dc, _this.dc) || other.dc == _this.dc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MonsterSave;
  return Object.hash(runtimeType,_this.ability,_this.dc);
}

@override
String toString() {
  final _this = this as MonsterSave;
  return 'MonsterSave(ability: ${_this.ability}, dc: ${_this.dc})';
}


}

/// @nodoc
abstract mixin class $MonsterSaveCopyWith<$Res>  {
  factory $MonsterSaveCopyWith(MonsterSave value, $Res Function(MonsterSave) _then) = _$MonsterSaveCopyWithImpl;
@useResult
$Res call({
 String ability, int dc
});




}
/// @nodoc
class _$MonsterSaveCopyWithImpl<$Res>
    implements $MonsterSaveCopyWith<$Res> {
  _$MonsterSaveCopyWithImpl(this._self, this._then);

  final MonsterSave _self;
  final $Res Function(MonsterSave) _then;

/// Create a copy of MonsterSave
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ability = null,Object? dc = null,}) {
  return _then(MonsterSave(
ability: null == ability ? _self.ability : ability // ignore: cast_nullable_to_non_nullable
as String,dc: null == dc ? _self.dc : dc // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MonsterSave].
extension MonsterSavePatterns on MonsterSave {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonsterSave value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonsterSave() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonsterSave value)  $default,){
final _that = this;
switch (_that) {
case _MonsterSave():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonsterSave value)?  $default,){
final _that = this;
switch (_that) {
case _MonsterSave() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ability,  int dc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonsterSave() when $default != null:
return $default(_that.ability,_that.dc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ability,  int dc)  $default,) {final _that = this;
switch (_that) {
case _MonsterSave():
return $default(_that.ability,_that.dc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ability,  int dc)?  $default,) {final _that = this;
switch (_that) {
case _MonsterSave() when $default != null:
return $default(_that.ability,_that.dc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonsterSave implements MonsterSave {
  const _MonsterSave({required this.ability, required this.dc});
  factory _MonsterSave.fromJson(Map<String, dynamic> json) => _$MonsterSaveFromJson(json);

@override final  String ability;
@override final  int dc;

/// Create a copy of MonsterSave
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonsterSaveCopyWith<_MonsterSave> get copyWith => __$MonsterSaveCopyWithImpl<_MonsterSave>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonsterSaveToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonsterSave&&(identical(other.ability, ability) || other.ability == ability)&&(identical(other.dc, dc) || other.dc == dc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,ability,dc);
}

@override
String toString() {
    return 'MonsterSave(ability: $ability, dc: $dc)';
}


}

/// @nodoc
abstract mixin class _$MonsterSaveCopyWith<$Res> implements $MonsterSaveCopyWith<$Res> {
  factory _$MonsterSaveCopyWith(_MonsterSave value, $Res Function(_MonsterSave) _then) = __$MonsterSaveCopyWithImpl;
@override @useResult
$Res call({
 String ability, int dc
});




}
/// @nodoc
class __$MonsterSaveCopyWithImpl<$Res>
    implements _$MonsterSaveCopyWith<$Res> {
  __$MonsterSaveCopyWithImpl(this._self, this._then);

  final _MonsterSave _self;
  final $Res Function(_MonsterSave) _then;

/// Create a copy of MonsterSave
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ability = null,Object? dc = null,}) {
  return _then(_MonsterSave(
ability: null == ability ? _self.ability : ability // ignore: cast_nullable_to_non_nullable
as String,dc: null == dc ? _self.dc : dc // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MonsterAction {

 MonsterActionKind get kind; String get name; MonsterUses? get uses; MonsterAttack? get attack; MonsterSave? get save; String get text;
/// Create a copy of MonsterAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonsterActionCopyWith<MonsterAction> get copyWith => _$MonsterActionCopyWithImpl<MonsterAction>(this as MonsterAction, _$identity);

  /// Serializes this MonsterAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MonsterAction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonsterAction&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.uses, _this.uses) || other.uses == _this.uses)&&(identical(other.attack, _this.attack) || other.attack == _this.attack)&&(identical(other.save, _this.save) || other.save == _this.save)&&(identical(other.text, _this.text) || other.text == _this.text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MonsterAction;
  return Object.hash(runtimeType,_this.kind,_this.name,_this.uses,_this.attack,_this.save,_this.text);
}

@override
String toString() {
  final _this = this as MonsterAction;
  return 'MonsterAction(kind: ${_this.kind}, name: ${_this.name}, uses: ${_this.uses}, attack: ${_this.attack}, save: ${_this.save}, text: ${_this.text})';
}


}

/// @nodoc
abstract mixin class $MonsterActionCopyWith<$Res>  {
  factory $MonsterActionCopyWith(MonsterAction value, $Res Function(MonsterAction) _then) = _$MonsterActionCopyWithImpl;
@useResult
$Res call({
 MonsterActionKind kind, String name, MonsterUses? uses, MonsterAttack? attack, MonsterSave? save, String text
});


$MonsterUsesCopyWith<$Res>? get uses;$MonsterAttackCopyWith<$Res>? get attack;$MonsterSaveCopyWith<$Res>? get save;

}
/// @nodoc
class _$MonsterActionCopyWithImpl<$Res>
    implements $MonsterActionCopyWith<$Res> {
  _$MonsterActionCopyWithImpl(this._self, this._then);

  final MonsterAction _self;
  final $Res Function(MonsterAction) _then;

/// Create a copy of MonsterAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? name = null,Object? uses = freezed,Object? attack = freezed,Object? save = freezed,Object? text = null,}) {
  return _then(MonsterAction(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MonsterActionKind,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,uses: freezed == uses ? _self.uses : uses // ignore: cast_nullable_to_non_nullable
as MonsterUses?,attack: freezed == attack ? _self.attack : attack // ignore: cast_nullable_to_non_nullable
as MonsterAttack?,save: freezed == save ? _self.save : save // ignore: cast_nullable_to_non_nullable
as MonsterSave?,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of MonsterAction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonsterUsesCopyWith<$Res>? get uses {
    if (_self.uses == null) {
    return null;
  }

  return $MonsterUsesCopyWith<$Res>(_self.uses!, (value) {
    return _then(_self.copyWith(uses: value));
  });
}/// Create a copy of MonsterAction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonsterAttackCopyWith<$Res>? get attack {
    if (_self.attack == null) {
    return null;
  }

  return $MonsterAttackCopyWith<$Res>(_self.attack!, (value) {
    return _then(_self.copyWith(attack: value));
  });
}/// Create a copy of MonsterAction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonsterSaveCopyWith<$Res>? get save {
    if (_self.save == null) {
    return null;
  }

  return $MonsterSaveCopyWith<$Res>(_self.save!, (value) {
    return _then(_self.copyWith(save: value));
  });
}
}


/// Adds pattern-matching-related methods to [MonsterAction].
extension MonsterActionPatterns on MonsterAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonsterAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonsterAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonsterAction value)  $default,){
final _that = this;
switch (_that) {
case _MonsterAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonsterAction value)?  $default,){
final _that = this;
switch (_that) {
case _MonsterAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MonsterActionKind kind,  String name,  MonsterUses? uses,  MonsterAttack? attack,  MonsterSave? save,  String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonsterAction() when $default != null:
return $default(_that.kind,_that.name,_that.uses,_that.attack,_that.save,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MonsterActionKind kind,  String name,  MonsterUses? uses,  MonsterAttack? attack,  MonsterSave? save,  String text)  $default,) {final _that = this;
switch (_that) {
case _MonsterAction():
return $default(_that.kind,_that.name,_that.uses,_that.attack,_that.save,_that.text);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MonsterActionKind kind,  String name,  MonsterUses? uses,  MonsterAttack? attack,  MonsterSave? save,  String text)?  $default,) {final _that = this;
switch (_that) {
case _MonsterAction() when $default != null:
return $default(_that.kind,_that.name,_that.uses,_that.attack,_that.save,_that.text);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonsterAction implements MonsterAction {
  const _MonsterAction({required this.kind, required this.name, this.uses, this.attack, this.save, required this.text});
  factory _MonsterAction.fromJson(Map<String, dynamic> json) => _$MonsterActionFromJson(json);

@override final  MonsterActionKind kind;
@override final  String name;
@override final  MonsterUses? uses;
@override final  MonsterAttack? attack;
@override final  MonsterSave? save;
@override final  String text;

/// Create a copy of MonsterAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonsterActionCopyWith<_MonsterAction> get copyWith => __$MonsterActionCopyWithImpl<_MonsterAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonsterActionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonsterAction&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.name, name) || other.name == name)&&(identical(other.uses, uses) || other.uses == uses)&&(identical(other.attack, attack) || other.attack == attack)&&(identical(other.save, save) || other.save == save)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,name,uses,attack,save,text);
}

@override
String toString() {
    return 'MonsterAction(kind: $kind, name: $name, uses: $uses, attack: $attack, save: $save, text: $text)';
}


}

/// @nodoc
abstract mixin class _$MonsterActionCopyWith<$Res> implements $MonsterActionCopyWith<$Res> {
  factory _$MonsterActionCopyWith(_MonsterAction value, $Res Function(_MonsterAction) _then) = __$MonsterActionCopyWithImpl;
@override @useResult
$Res call({
 MonsterActionKind kind, String name, MonsterUses? uses, MonsterAttack? attack, MonsterSave? save, String text
});


@override $MonsterUsesCopyWith<$Res>? get uses;@override $MonsterAttackCopyWith<$Res>? get attack;@override $MonsterSaveCopyWith<$Res>? get save;

}
/// @nodoc
class __$MonsterActionCopyWithImpl<$Res>
    implements _$MonsterActionCopyWith<$Res> {
  __$MonsterActionCopyWithImpl(this._self, this._then);

  final _MonsterAction _self;
  final $Res Function(_MonsterAction) _then;

/// Create a copy of MonsterAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? name = null,Object? uses = freezed,Object? attack = freezed,Object? save = freezed,Object? text = null,}) {
  return _then(_MonsterAction(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MonsterActionKind,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,uses: freezed == uses ? _self.uses : uses // ignore: cast_nullable_to_non_nullable
as MonsterUses?,attack: freezed == attack ? _self.attack : attack // ignore: cast_nullable_to_non_nullable
as MonsterAttack?,save: freezed == save ? _self.save : save // ignore: cast_nullable_to_non_nullable
as MonsterSave?,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of MonsterAction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonsterUsesCopyWith<$Res>? get uses {
    if (_self.uses == null) {
    return null;
  }

  return $MonsterUsesCopyWith<$Res>(_self.uses!, (value) {
    return _then(_self.copyWith(uses: value));
  });
}/// Create a copy of MonsterAction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonsterAttackCopyWith<$Res>? get attack {
    if (_self.attack == null) {
    return null;
  }

  return $MonsterAttackCopyWith<$Res>(_self.attack!, (value) {
    return _then(_self.copyWith(attack: value));
  });
}/// Create a copy of MonsterAction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonsterSaveCopyWith<$Res>? get save {
    if (_self.save == null) {
    return null;
  }

  return $MonsterSaveCopyWith<$Res>(_self.save!, (value) {
    return _then(_self.copyWith(save: value));
  });
}
}


/// @nodoc
mixin _$MonsterData {

 List<MonsterSize> get sizes; CreatureType get creatureType;/// Taille des créatures d'une nuée ; [sizes] est celle de la nuée.
 MonsterSize? get swarmSize;/// Texte entre parenthèses après le type (« Démon »).
 List<String> get typeTags; String get alignment; int get ac;/// Texte qui suit la CA.
 String? get acNote; int get initiative; int get hp; String get hitDice; MonsterSpeed get speed;/// Partie imprimée de la ligne Vitesse que [speed] ne porte pas.
 String? get speedNote; bool get hover;@JsonKey(fromJson: _sixAbilities) Map<String, int> get abilities;@JsonKey(fromJson: _sixAbilities) Map<String, int> get savingThrows;/// Bonus par identifiant de compétence.
 Map<String, int> get skills;@ContentIdConverter() List<ContentId> get vulnerabilities;@ContentIdConverter() List<ContentId> get resistances;@ContentIdConverter() List<ContentId> get immunities;@ContentIdConverter() List<ContentId> get conditionImmunities;/// Ligne « Équipement », un objet par entrée.
 List<String> get gear; MonsterSenses get senses;/// Précision imprimée d'un sens, que [senses] ne porte pas.
 String? get sensesNote; int get passivePerception;/// Ligne « Langues », telle qu'imprimée.
 String get languages; String get cr; int get xp; int? get xpLair; int get proficiencyBonus; int? get legendaryUses; int? get legendaryUsesLair; List<MonsterAction> get actions;
/// Create a copy of MonsterData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonsterDataCopyWith<MonsterData> get copyWith => _$MonsterDataCopyWithImpl<MonsterData>(this as MonsterData, _$identity);

  /// Serializes this MonsterData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MonsterData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonsterData&&const DeepCollectionEquality().equals(other.sizes, _this.sizes)&&(identical(other.creatureType, _this.creatureType) || other.creatureType == _this.creatureType)&&(identical(other.swarmSize, _this.swarmSize) || other.swarmSize == _this.swarmSize)&&const DeepCollectionEquality().equals(other.typeTags, _this.typeTags)&&(identical(other.alignment, _this.alignment) || other.alignment == _this.alignment)&&(identical(other.ac, _this.ac) || other.ac == _this.ac)&&(identical(other.acNote, _this.acNote) || other.acNote == _this.acNote)&&(identical(other.initiative, _this.initiative) || other.initiative == _this.initiative)&&(identical(other.hp, _this.hp) || other.hp == _this.hp)&&(identical(other.hitDice, _this.hitDice) || other.hitDice == _this.hitDice)&&(identical(other.speed, _this.speed) || other.speed == _this.speed)&&(identical(other.speedNote, _this.speedNote) || other.speedNote == _this.speedNote)&&(identical(other.hover, _this.hover) || other.hover == _this.hover)&&const DeepCollectionEquality().equals(other.abilities, _this.abilities)&&const DeepCollectionEquality().equals(other.savingThrows, _this.savingThrows)&&const DeepCollectionEquality().equals(other.skills, _this.skills)&&const DeepCollectionEquality().equals(other.vulnerabilities, _this.vulnerabilities)&&const DeepCollectionEquality().equals(other.resistances, _this.resistances)&&const DeepCollectionEquality().equals(other.immunities, _this.immunities)&&const DeepCollectionEquality().equals(other.conditionImmunities, _this.conditionImmunities)&&const DeepCollectionEquality().equals(other.gear, _this.gear)&&(identical(other.senses, _this.senses) || other.senses == _this.senses)&&(identical(other.sensesNote, _this.sensesNote) || other.sensesNote == _this.sensesNote)&&(identical(other.passivePerception, _this.passivePerception) || other.passivePerception == _this.passivePerception)&&(identical(other.languages, _this.languages) || other.languages == _this.languages)&&(identical(other.cr, _this.cr) || other.cr == _this.cr)&&(identical(other.xp, _this.xp) || other.xp == _this.xp)&&(identical(other.xpLair, _this.xpLair) || other.xpLair == _this.xpLair)&&(identical(other.proficiencyBonus, _this.proficiencyBonus) || other.proficiencyBonus == _this.proficiencyBonus)&&(identical(other.legendaryUses, _this.legendaryUses) || other.legendaryUses == _this.legendaryUses)&&(identical(other.legendaryUsesLair, _this.legendaryUsesLair) || other.legendaryUsesLair == _this.legendaryUsesLair)&&const DeepCollectionEquality().equals(other.actions, _this.actions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MonsterData;
  return Object.hashAll([runtimeType,const DeepCollectionEquality().hash(_this.sizes),_this.creatureType,_this.swarmSize,const DeepCollectionEquality().hash(_this.typeTags),_this.alignment,_this.ac,_this.acNote,_this.initiative,_this.hp,_this.hitDice,_this.speed,_this.speedNote,_this.hover,const DeepCollectionEquality().hash(_this.abilities),const DeepCollectionEquality().hash(_this.savingThrows),const DeepCollectionEquality().hash(_this.skills),const DeepCollectionEquality().hash(_this.vulnerabilities),const DeepCollectionEquality().hash(_this.resistances),const DeepCollectionEquality().hash(_this.immunities),const DeepCollectionEquality().hash(_this.conditionImmunities),const DeepCollectionEquality().hash(_this.gear),_this.senses,_this.sensesNote,_this.passivePerception,_this.languages,_this.cr,_this.xp,_this.xpLair,_this.proficiencyBonus,_this.legendaryUses,_this.legendaryUsesLair,const DeepCollectionEquality().hash(_this.actions)]);
}

@override
String toString() {
  final _this = this as MonsterData;
  return 'MonsterData(sizes: ${_this.sizes}, creatureType: ${_this.creatureType}, swarmSize: ${_this.swarmSize}, typeTags: ${_this.typeTags}, alignment: ${_this.alignment}, ac: ${_this.ac}, acNote: ${_this.acNote}, initiative: ${_this.initiative}, hp: ${_this.hp}, hitDice: ${_this.hitDice}, speed: ${_this.speed}, speedNote: ${_this.speedNote}, hover: ${_this.hover}, abilities: ${_this.abilities}, savingThrows: ${_this.savingThrows}, skills: ${_this.skills}, vulnerabilities: ${_this.vulnerabilities}, resistances: ${_this.resistances}, immunities: ${_this.immunities}, conditionImmunities: ${_this.conditionImmunities}, gear: ${_this.gear}, senses: ${_this.senses}, sensesNote: ${_this.sensesNote}, passivePerception: ${_this.passivePerception}, languages: ${_this.languages}, cr: ${_this.cr}, xp: ${_this.xp}, xpLair: ${_this.xpLair}, proficiencyBonus: ${_this.proficiencyBonus}, legendaryUses: ${_this.legendaryUses}, legendaryUsesLair: ${_this.legendaryUsesLair}, actions: ${_this.actions})';
}


}

/// @nodoc
abstract mixin class $MonsterDataCopyWith<$Res>  {
  factory $MonsterDataCopyWith(MonsterData value, $Res Function(MonsterData) _then) = _$MonsterDataCopyWithImpl;
@useResult
$Res call({
 List<MonsterSize> sizes, CreatureType creatureType, MonsterSize? swarmSize, List<String> typeTags, String alignment, int ac, String? acNote, int initiative, int hp, String hitDice, MonsterSpeed speed, String? speedNote, bool hover,@JsonKey(fromJson: _sixAbilities) Map<String, int> abilities,@JsonKey(fromJson: _sixAbilities) Map<String, int> savingThrows, Map<String, int> skills,@ContentIdConverter() List<ContentId> vulnerabilities,@ContentIdConverter() List<ContentId> resistances,@ContentIdConverter() List<ContentId> immunities,@ContentIdConverter() List<ContentId> conditionImmunities, List<String> gear, MonsterSenses senses, String? sensesNote, int passivePerception, String languages, String cr, int xp, int? xpLair, int proficiencyBonus, int? legendaryUses, int? legendaryUsesLair, List<MonsterAction> actions
});


$MonsterSpeedCopyWith<$Res> get speed;$MonsterSensesCopyWith<$Res> get senses;

}
/// @nodoc
class _$MonsterDataCopyWithImpl<$Res>
    implements $MonsterDataCopyWith<$Res> {
  _$MonsterDataCopyWithImpl(this._self, this._then);

  final MonsterData _self;
  final $Res Function(MonsterData) _then;

/// Create a copy of MonsterData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sizes = null,Object? creatureType = null,Object? swarmSize = freezed,Object? typeTags = null,Object? alignment = null,Object? ac = null,Object? acNote = freezed,Object? initiative = null,Object? hp = null,Object? hitDice = null,Object? speed = null,Object? speedNote = freezed,Object? hover = null,Object? abilities = null,Object? savingThrows = null,Object? skills = null,Object? vulnerabilities = null,Object? resistances = null,Object? immunities = null,Object? conditionImmunities = null,Object? gear = null,Object? senses = null,Object? sensesNote = freezed,Object? passivePerception = null,Object? languages = null,Object? cr = null,Object? xp = null,Object? xpLair = freezed,Object? proficiencyBonus = null,Object? legendaryUses = freezed,Object? legendaryUsesLair = freezed,Object? actions = null,}) {
  return _then(MonsterData(
sizes: null == sizes ? _self.sizes : sizes // ignore: cast_nullable_to_non_nullable
as List<MonsterSize>,creatureType: null == creatureType ? _self.creatureType : creatureType // ignore: cast_nullable_to_non_nullable
as CreatureType,swarmSize: freezed == swarmSize ? _self.swarmSize : swarmSize // ignore: cast_nullable_to_non_nullable
as MonsterSize?,typeTags: null == typeTags ? _self.typeTags : typeTags // ignore: cast_nullable_to_non_nullable
as List<String>,alignment: null == alignment ? _self.alignment : alignment // ignore: cast_nullable_to_non_nullable
as String,ac: null == ac ? _self.ac : ac // ignore: cast_nullable_to_non_nullable
as int,acNote: freezed == acNote ? _self.acNote : acNote // ignore: cast_nullable_to_non_nullable
as String?,initiative: null == initiative ? _self.initiative : initiative // ignore: cast_nullable_to_non_nullable
as int,hp: null == hp ? _self.hp : hp // ignore: cast_nullable_to_non_nullable
as int,hitDice: null == hitDice ? _self.hitDice : hitDice // ignore: cast_nullable_to_non_nullable
as String,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as MonsterSpeed,speedNote: freezed == speedNote ? _self.speedNote : speedNote // ignore: cast_nullable_to_non_nullable
as String?,hover: null == hover ? _self.hover : hover // ignore: cast_nullable_to_non_nullable
as bool,abilities: null == abilities ? _self.abilities : abilities // ignore: cast_nullable_to_non_nullable
as Map<String, int>,savingThrows: null == savingThrows ? _self.savingThrows : savingThrows // ignore: cast_nullable_to_non_nullable
as Map<String, int>,skills: null == skills ? _self.skills : skills // ignore: cast_nullable_to_non_nullable
as Map<String, int>,vulnerabilities: null == vulnerabilities ? _self.vulnerabilities : vulnerabilities // ignore: cast_nullable_to_non_nullable
as List<ContentId>,resistances: null == resistances ? _self.resistances : resistances // ignore: cast_nullable_to_non_nullable
as List<ContentId>,immunities: null == immunities ? _self.immunities : immunities // ignore: cast_nullable_to_non_nullable
as List<ContentId>,conditionImmunities: null == conditionImmunities ? _self.conditionImmunities : conditionImmunities // ignore: cast_nullable_to_non_nullable
as List<ContentId>,gear: null == gear ? _self.gear : gear // ignore: cast_nullable_to_non_nullable
as List<String>,senses: null == senses ? _self.senses : senses // ignore: cast_nullable_to_non_nullable
as MonsterSenses,sensesNote: freezed == sensesNote ? _self.sensesNote : sensesNote // ignore: cast_nullable_to_non_nullable
as String?,passivePerception: null == passivePerception ? _self.passivePerception : passivePerception // ignore: cast_nullable_to_non_nullable
as int,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as String,cr: null == cr ? _self.cr : cr // ignore: cast_nullable_to_non_nullable
as String,xp: null == xp ? _self.xp : xp // ignore: cast_nullable_to_non_nullable
as int,xpLair: freezed == xpLair ? _self.xpLair : xpLair // ignore: cast_nullable_to_non_nullable
as int?,proficiencyBonus: null == proficiencyBonus ? _self.proficiencyBonus : proficiencyBonus // ignore: cast_nullable_to_non_nullable
as int,legendaryUses: freezed == legendaryUses ? _self.legendaryUses : legendaryUses // ignore: cast_nullable_to_non_nullable
as int?,legendaryUsesLair: freezed == legendaryUsesLair ? _self.legendaryUsesLair : legendaryUsesLair // ignore: cast_nullable_to_non_nullable
as int?,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<MonsterAction>,
  ));
}
/// Create a copy of MonsterData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonsterSpeedCopyWith<$Res> get speed {
  
  return $MonsterSpeedCopyWith<$Res>(_self.speed, (value) {
    return _then(_self.copyWith(speed: value));
  });
}/// Create a copy of MonsterData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonsterSensesCopyWith<$Res> get senses {
  
  return $MonsterSensesCopyWith<$Res>(_self.senses, (value) {
    return _then(_self.copyWith(senses: value));
  });
}
}


/// Adds pattern-matching-related methods to [MonsterData].
extension MonsterDataPatterns on MonsterData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonsterData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonsterData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonsterData value)  $default,){
final _that = this;
switch (_that) {
case _MonsterData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonsterData value)?  $default,){
final _that = this;
switch (_that) {
case _MonsterData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MonsterSize> sizes,  CreatureType creatureType,  MonsterSize? swarmSize,  List<String> typeTags,  String alignment,  int ac,  String? acNote,  int initiative,  int hp,  String hitDice,  MonsterSpeed speed,  String? speedNote,  bool hover, @JsonKey(fromJson: _sixAbilities)  Map<String, int> abilities, @JsonKey(fromJson: _sixAbilities)  Map<String, int> savingThrows,  Map<String, int> skills, @ContentIdConverter()  List<ContentId> vulnerabilities, @ContentIdConverter()  List<ContentId> resistances, @ContentIdConverter()  List<ContentId> immunities, @ContentIdConverter()  List<ContentId> conditionImmunities,  List<String> gear,  MonsterSenses senses,  String? sensesNote,  int passivePerception,  String languages,  String cr,  int xp,  int? xpLair,  int proficiencyBonus,  int? legendaryUses,  int? legendaryUsesLair,  List<MonsterAction> actions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonsterData() when $default != null:
return $default(_that.sizes,_that.creatureType,_that.swarmSize,_that.typeTags,_that.alignment,_that.ac,_that.acNote,_that.initiative,_that.hp,_that.hitDice,_that.speed,_that.speedNote,_that.hover,_that.abilities,_that.savingThrows,_that.skills,_that.vulnerabilities,_that.resistances,_that.immunities,_that.conditionImmunities,_that.gear,_that.senses,_that.sensesNote,_that.passivePerception,_that.languages,_that.cr,_that.xp,_that.xpLair,_that.proficiencyBonus,_that.legendaryUses,_that.legendaryUsesLair,_that.actions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MonsterSize> sizes,  CreatureType creatureType,  MonsterSize? swarmSize,  List<String> typeTags,  String alignment,  int ac,  String? acNote,  int initiative,  int hp,  String hitDice,  MonsterSpeed speed,  String? speedNote,  bool hover, @JsonKey(fromJson: _sixAbilities)  Map<String, int> abilities, @JsonKey(fromJson: _sixAbilities)  Map<String, int> savingThrows,  Map<String, int> skills, @ContentIdConverter()  List<ContentId> vulnerabilities, @ContentIdConverter()  List<ContentId> resistances, @ContentIdConverter()  List<ContentId> immunities, @ContentIdConverter()  List<ContentId> conditionImmunities,  List<String> gear,  MonsterSenses senses,  String? sensesNote,  int passivePerception,  String languages,  String cr,  int xp,  int? xpLair,  int proficiencyBonus,  int? legendaryUses,  int? legendaryUsesLair,  List<MonsterAction> actions)  $default,) {final _that = this;
switch (_that) {
case _MonsterData():
return $default(_that.sizes,_that.creatureType,_that.swarmSize,_that.typeTags,_that.alignment,_that.ac,_that.acNote,_that.initiative,_that.hp,_that.hitDice,_that.speed,_that.speedNote,_that.hover,_that.abilities,_that.savingThrows,_that.skills,_that.vulnerabilities,_that.resistances,_that.immunities,_that.conditionImmunities,_that.gear,_that.senses,_that.sensesNote,_that.passivePerception,_that.languages,_that.cr,_that.xp,_that.xpLair,_that.proficiencyBonus,_that.legendaryUses,_that.legendaryUsesLair,_that.actions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MonsterSize> sizes,  CreatureType creatureType,  MonsterSize? swarmSize,  List<String> typeTags,  String alignment,  int ac,  String? acNote,  int initiative,  int hp,  String hitDice,  MonsterSpeed speed,  String? speedNote,  bool hover, @JsonKey(fromJson: _sixAbilities)  Map<String, int> abilities, @JsonKey(fromJson: _sixAbilities)  Map<String, int> savingThrows,  Map<String, int> skills, @ContentIdConverter()  List<ContentId> vulnerabilities, @ContentIdConverter()  List<ContentId> resistances, @ContentIdConverter()  List<ContentId> immunities, @ContentIdConverter()  List<ContentId> conditionImmunities,  List<String> gear,  MonsterSenses senses,  String? sensesNote,  int passivePerception,  String languages,  String cr,  int xp,  int? xpLair,  int proficiencyBonus,  int? legendaryUses,  int? legendaryUsesLair,  List<MonsterAction> actions)?  $default,) {final _that = this;
switch (_that) {
case _MonsterData() when $default != null:
return $default(_that.sizes,_that.creatureType,_that.swarmSize,_that.typeTags,_that.alignment,_that.ac,_that.acNote,_that.initiative,_that.hp,_that.hitDice,_that.speed,_that.speedNote,_that.hover,_that.abilities,_that.savingThrows,_that.skills,_that.vulnerabilities,_that.resistances,_that.immunities,_that.conditionImmunities,_that.gear,_that.senses,_that.sensesNote,_that.passivePerception,_that.languages,_that.cr,_that.xp,_that.xpLair,_that.proficiencyBonus,_that.legendaryUses,_that.legendaryUsesLair,_that.actions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonsterData implements MonsterData {
  const _MonsterData({required  List<MonsterSize> sizes, required this.creatureType, this.swarmSize,  List<String> typeTags = const <String>[], required this.alignment, required this.ac, this.acNote, required this.initiative, required this.hp, required this.hitDice, required this.speed, this.speedNote, this.hover = false, @JsonKey(fromJson: _sixAbilities) required  Map<String, int> abilities, @JsonKey(fromJson: _sixAbilities) required  Map<String, int> savingThrows,  Map<String, int> skills = const <String, int>{}, @ContentIdConverter()  List<ContentId> vulnerabilities = const <ContentId>[], @ContentIdConverter()  List<ContentId> resistances = const <ContentId>[], @ContentIdConverter()  List<ContentId> immunities = const <ContentId>[], @ContentIdConverter()  List<ContentId> conditionImmunities = const <ContentId>[],  List<String> gear = const <String>[], this.senses = const MonsterSenses(), this.sensesNote, required this.passivePerception, required this.languages, required this.cr, required this.xp, this.xpLair, required this.proficiencyBonus, this.legendaryUses, this.legendaryUsesLair,  List<MonsterAction> actions = const <MonsterAction>[]}): _sizes = sizes,_typeTags = typeTags,_abilities = abilities,_savingThrows = savingThrows,_skills = skills,_vulnerabilities = vulnerabilities,_resistances = resistances,_immunities = immunities,_conditionImmunities = conditionImmunities,_gear = gear,_actions = actions;
  factory _MonsterData.fromJson(Map<String, dynamic> json) => _$MonsterDataFromJson(json);

 final  List<MonsterSize> _sizes;
@override List<MonsterSize> get sizes {
  if (_sizes is EqualUnmodifiableListView) return _sizes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sizes);
}

@override final  CreatureType creatureType;
/// Taille des créatures d'une nuée ; [sizes] est celle de la nuée.
@override final  MonsterSize? swarmSize;
/// Texte entre parenthèses après le type (« Démon »).
 final  List<String> _typeTags;
/// Texte entre parenthèses après le type (« Démon »).
@override@JsonKey() List<String> get typeTags {
  if (_typeTags is EqualUnmodifiableListView) return _typeTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_typeTags);
}

@override final  String alignment;
@override final  int ac;
/// Texte qui suit la CA.
@override final  String? acNote;
@override final  int initiative;
@override final  int hp;
@override final  String hitDice;
@override final  MonsterSpeed speed;
/// Partie imprimée de la ligne Vitesse que [speed] ne porte pas.
@override final  String? speedNote;
@override@JsonKey() final  bool hover;
 final  Map<String, int> _abilities;
@override@JsonKey(fromJson: _sixAbilities) Map<String, int> get abilities {
  if (_abilities is EqualUnmodifiableMapView) return _abilities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_abilities);
}

 final  Map<String, int> _savingThrows;
@override@JsonKey(fromJson: _sixAbilities) Map<String, int> get savingThrows {
  if (_savingThrows is EqualUnmodifiableMapView) return _savingThrows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_savingThrows);
}

/// Bonus par identifiant de compétence.
 final  Map<String, int> _skills;
/// Bonus par identifiant de compétence.
@override@JsonKey() Map<String, int> get skills {
  if (_skills is EqualUnmodifiableMapView) return _skills;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_skills);
}

 final  List<ContentId> _vulnerabilities;
@override@JsonKey()@ContentIdConverter() List<ContentId> get vulnerabilities {
  if (_vulnerabilities is EqualUnmodifiableListView) return _vulnerabilities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_vulnerabilities);
}

 final  List<ContentId> _resistances;
@override@JsonKey()@ContentIdConverter() List<ContentId> get resistances {
  if (_resistances is EqualUnmodifiableListView) return _resistances;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_resistances);
}

 final  List<ContentId> _immunities;
@override@JsonKey()@ContentIdConverter() List<ContentId> get immunities {
  if (_immunities is EqualUnmodifiableListView) return _immunities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_immunities);
}

 final  List<ContentId> _conditionImmunities;
@override@JsonKey()@ContentIdConverter() List<ContentId> get conditionImmunities {
  if (_conditionImmunities is EqualUnmodifiableListView) return _conditionImmunities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conditionImmunities);
}

/// Ligne « Équipement », un objet par entrée.
 final  List<String> _gear;
/// Ligne « Équipement », un objet par entrée.
@override@JsonKey() List<String> get gear {
  if (_gear is EqualUnmodifiableListView) return _gear;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_gear);
}

@override@JsonKey() final  MonsterSenses senses;
/// Précision imprimée d'un sens, que [senses] ne porte pas.
@override final  String? sensesNote;
@override final  int passivePerception;
/// Ligne « Langues », telle qu'imprimée.
@override final  String languages;
@override final  String cr;
@override final  int xp;
@override final  int? xpLair;
@override final  int proficiencyBonus;
@override final  int? legendaryUses;
@override final  int? legendaryUsesLair;
 final  List<MonsterAction> _actions;
@override@JsonKey() List<MonsterAction> get actions {
  if (_actions is EqualUnmodifiableListView) return _actions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actions);
}


/// Create a copy of MonsterData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonsterDataCopyWith<_MonsterData> get copyWith => __$MonsterDataCopyWithImpl<_MonsterData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonsterDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonsterData&&const DeepCollectionEquality().equals(other.sizes, _sizes)&&(identical(other.creatureType, creatureType) || other.creatureType == creatureType)&&(identical(other.swarmSize, swarmSize) || other.swarmSize == swarmSize)&&const DeepCollectionEquality().equals(other.typeTags, _typeTags)&&(identical(other.alignment, alignment) || other.alignment == alignment)&&(identical(other.ac, ac) || other.ac == ac)&&(identical(other.acNote, acNote) || other.acNote == acNote)&&(identical(other.initiative, initiative) || other.initiative == initiative)&&(identical(other.hp, hp) || other.hp == hp)&&(identical(other.hitDice, hitDice) || other.hitDice == hitDice)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.speedNote, speedNote) || other.speedNote == speedNote)&&(identical(other.hover, hover) || other.hover == hover)&&const DeepCollectionEquality().equals(other.abilities, _abilities)&&const DeepCollectionEquality().equals(other.savingThrows, _savingThrows)&&const DeepCollectionEquality().equals(other.skills, _skills)&&const DeepCollectionEquality().equals(other.vulnerabilities, _vulnerabilities)&&const DeepCollectionEquality().equals(other.resistances, _resistances)&&const DeepCollectionEquality().equals(other.immunities, _immunities)&&const DeepCollectionEquality().equals(other.conditionImmunities, _conditionImmunities)&&const DeepCollectionEquality().equals(other.gear, _gear)&&(identical(other.senses, senses) || other.senses == senses)&&(identical(other.sensesNote, sensesNote) || other.sensesNote == sensesNote)&&(identical(other.passivePerception, passivePerception) || other.passivePerception == passivePerception)&&(identical(other.languages, languages) || other.languages == languages)&&(identical(other.cr, cr) || other.cr == cr)&&(identical(other.xp, xp) || other.xp == xp)&&(identical(other.xpLair, xpLair) || other.xpLair == xpLair)&&(identical(other.proficiencyBonus, proficiencyBonus) || other.proficiencyBonus == proficiencyBonus)&&(identical(other.legendaryUses, legendaryUses) || other.legendaryUses == legendaryUses)&&(identical(other.legendaryUsesLair, legendaryUsesLair) || other.legendaryUsesLair == legendaryUsesLair)&&const DeepCollectionEquality().equals(other.actions, _actions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,const DeepCollectionEquality().hash(_sizes),creatureType,swarmSize,const DeepCollectionEquality().hash(_typeTags),alignment,ac,acNote,initiative,hp,hitDice,speed,speedNote,hover,const DeepCollectionEquality().hash(_abilities),const DeepCollectionEquality().hash(_savingThrows),const DeepCollectionEquality().hash(_skills),const DeepCollectionEquality().hash(_vulnerabilities),const DeepCollectionEquality().hash(_resistances),const DeepCollectionEquality().hash(_immunities),const DeepCollectionEquality().hash(_conditionImmunities),const DeepCollectionEquality().hash(_gear),senses,sensesNote,passivePerception,languages,cr,xp,xpLair,proficiencyBonus,legendaryUses,legendaryUsesLair,const DeepCollectionEquality().hash(_actions)]);
}

@override
String toString() {
    return 'MonsterData(sizes: $sizes, creatureType: $creatureType, swarmSize: $swarmSize, typeTags: $typeTags, alignment: $alignment, ac: $ac, acNote: $acNote, initiative: $initiative, hp: $hp, hitDice: $hitDice, speed: $speed, speedNote: $speedNote, hover: $hover, abilities: $abilities, savingThrows: $savingThrows, skills: $skills, vulnerabilities: $vulnerabilities, resistances: $resistances, immunities: $immunities, conditionImmunities: $conditionImmunities, gear: $gear, senses: $senses, sensesNote: $sensesNote, passivePerception: $passivePerception, languages: $languages, cr: $cr, xp: $xp, xpLair: $xpLair, proficiencyBonus: $proficiencyBonus, legendaryUses: $legendaryUses, legendaryUsesLair: $legendaryUsesLair, actions: $actions)';
}


}

/// @nodoc
abstract mixin class _$MonsterDataCopyWith<$Res> implements $MonsterDataCopyWith<$Res> {
  factory _$MonsterDataCopyWith(_MonsterData value, $Res Function(_MonsterData) _then) = __$MonsterDataCopyWithImpl;
@override @useResult
$Res call({
 List<MonsterSize> sizes, CreatureType creatureType, MonsterSize? swarmSize, List<String> typeTags, String alignment, int ac, String? acNote, int initiative, int hp, String hitDice, MonsterSpeed speed, String? speedNote, bool hover,@JsonKey(fromJson: _sixAbilities) Map<String, int> abilities,@JsonKey(fromJson: _sixAbilities) Map<String, int> savingThrows, Map<String, int> skills,@ContentIdConverter() List<ContentId> vulnerabilities,@ContentIdConverter() List<ContentId> resistances,@ContentIdConverter() List<ContentId> immunities,@ContentIdConverter() List<ContentId> conditionImmunities, List<String> gear, MonsterSenses senses, String? sensesNote, int passivePerception, String languages, String cr, int xp, int? xpLair, int proficiencyBonus, int? legendaryUses, int? legendaryUsesLair, List<MonsterAction> actions
});


@override $MonsterSpeedCopyWith<$Res> get speed;@override $MonsterSensesCopyWith<$Res> get senses;

}
/// @nodoc
class __$MonsterDataCopyWithImpl<$Res>
    implements _$MonsterDataCopyWith<$Res> {
  __$MonsterDataCopyWithImpl(this._self, this._then);

  final _MonsterData _self;
  final $Res Function(_MonsterData) _then;

/// Create a copy of MonsterData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sizes = null,Object? creatureType = null,Object? swarmSize = freezed,Object? typeTags = null,Object? alignment = null,Object? ac = null,Object? acNote = freezed,Object? initiative = null,Object? hp = null,Object? hitDice = null,Object? speed = null,Object? speedNote = freezed,Object? hover = null,Object? abilities = null,Object? savingThrows = null,Object? skills = null,Object? vulnerabilities = null,Object? resistances = null,Object? immunities = null,Object? conditionImmunities = null,Object? gear = null,Object? senses = null,Object? sensesNote = freezed,Object? passivePerception = null,Object? languages = null,Object? cr = null,Object? xp = null,Object? xpLair = freezed,Object? proficiencyBonus = null,Object? legendaryUses = freezed,Object? legendaryUsesLair = freezed,Object? actions = null,}) {
  return _then(_MonsterData(
sizes: null == sizes ? _self._sizes : sizes // ignore: cast_nullable_to_non_nullable
as List<MonsterSize>,creatureType: null == creatureType ? _self.creatureType : creatureType // ignore: cast_nullable_to_non_nullable
as CreatureType,swarmSize: freezed == swarmSize ? _self.swarmSize : swarmSize // ignore: cast_nullable_to_non_nullable
as MonsterSize?,typeTags: null == typeTags ? _self._typeTags : typeTags // ignore: cast_nullable_to_non_nullable
as List<String>,alignment: null == alignment ? _self.alignment : alignment // ignore: cast_nullable_to_non_nullable
as String,ac: null == ac ? _self.ac : ac // ignore: cast_nullable_to_non_nullable
as int,acNote: freezed == acNote ? _self.acNote : acNote // ignore: cast_nullable_to_non_nullable
as String?,initiative: null == initiative ? _self.initiative : initiative // ignore: cast_nullable_to_non_nullable
as int,hp: null == hp ? _self.hp : hp // ignore: cast_nullable_to_non_nullable
as int,hitDice: null == hitDice ? _self.hitDice : hitDice // ignore: cast_nullable_to_non_nullable
as String,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as MonsterSpeed,speedNote: freezed == speedNote ? _self.speedNote : speedNote // ignore: cast_nullable_to_non_nullable
as String?,hover: null == hover ? _self.hover : hover // ignore: cast_nullable_to_non_nullable
as bool,abilities: null == abilities ? _self._abilities : abilities // ignore: cast_nullable_to_non_nullable
as Map<String, int>,savingThrows: null == savingThrows ? _self._savingThrows : savingThrows // ignore: cast_nullable_to_non_nullable
as Map<String, int>,skills: null == skills ? _self._skills : skills // ignore: cast_nullable_to_non_nullable
as Map<String, int>,vulnerabilities: null == vulnerabilities ? _self._vulnerabilities : vulnerabilities // ignore: cast_nullable_to_non_nullable
as List<ContentId>,resistances: null == resistances ? _self._resistances : resistances // ignore: cast_nullable_to_non_nullable
as List<ContentId>,immunities: null == immunities ? _self._immunities : immunities // ignore: cast_nullable_to_non_nullable
as List<ContentId>,conditionImmunities: null == conditionImmunities ? _self._conditionImmunities : conditionImmunities // ignore: cast_nullable_to_non_nullable
as List<ContentId>,gear: null == gear ? _self._gear : gear // ignore: cast_nullable_to_non_nullable
as List<String>,senses: null == senses ? _self.senses : senses // ignore: cast_nullable_to_non_nullable
as MonsterSenses,sensesNote: freezed == sensesNote ? _self.sensesNote : sensesNote // ignore: cast_nullable_to_non_nullable
as String?,passivePerception: null == passivePerception ? _self.passivePerception : passivePerception // ignore: cast_nullable_to_non_nullable
as int,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as String,cr: null == cr ? _self.cr : cr // ignore: cast_nullable_to_non_nullable
as String,xp: null == xp ? _self.xp : xp // ignore: cast_nullable_to_non_nullable
as int,xpLair: freezed == xpLair ? _self.xpLair : xpLair // ignore: cast_nullable_to_non_nullable
as int?,proficiencyBonus: null == proficiencyBonus ? _self.proficiencyBonus : proficiencyBonus // ignore: cast_nullable_to_non_nullable
as int,legendaryUses: freezed == legendaryUses ? _self.legendaryUses : legendaryUses // ignore: cast_nullable_to_non_nullable
as int?,legendaryUsesLair: freezed == legendaryUsesLair ? _self.legendaryUsesLair : legendaryUsesLair // ignore: cast_nullable_to_non_nullable
as int?,actions: null == actions ? _self._actions : actions // ignore: cast_nullable_to_non_nullable
as List<MonsterAction>,
  ));
}

/// Create a copy of MonsterData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonsterSpeedCopyWith<$Res> get speed {
  
  return $MonsterSpeedCopyWith<$Res>(_self.speed, (value) {
    return _then(_self.copyWith(speed: value));
  });
}/// Create a copy of MonsterData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonsterSensesCopyWith<$Res> get senses {
  
  return $MonsterSensesCopyWith<$Res>(_self.senses, (value) {
    return _then(_self.copyWith(senses: value));
  });
}
}

// dart format on
