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

 WeaponCategory get category; WeaponKind get kind; String get damage;@ContentIdConverter() ContentId get damageType; List<String> get properties; String? get versatileDamage; List<int>? get rangeFeet;@ContentIdConverter() ContentId get mastery; double get weightKg; int get costCp;
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
 WeaponCategory category, WeaponKind kind, String damage,@ContentIdConverter() ContentId damageType, List<String> properties, String? versatileDamage, List<int>? rangeFeet,@ContentIdConverter() ContentId mastery, double weightKg, int costCp
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
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? kind = null,Object? damage = null,Object? damageType = null,Object? properties = null,Object? versatileDamage = freezed,Object? rangeFeet = freezed,Object? mastery = null,Object? weightKg = null,Object? costCp = null,}) {
  return _then(WeaponData(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as WeaponCategory,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as WeaponKind,damage: null == damage ? _self.damage : damage // ignore: cast_nullable_to_non_nullable
as String,damageType: null == damageType ? _self.damageType : damageType // ignore: cast_nullable_to_non_nullable
as ContentId,properties: null == properties ? _self.properties : properties // ignore: cast_nullable_to_non_nullable
as List<String>,versatileDamage: freezed == versatileDamage ? _self.versatileDamage : versatileDamage // ignore: cast_nullable_to_non_nullable
as String?,rangeFeet: freezed == rangeFeet ? _self.rangeFeet : rangeFeet // ignore: cast_nullable_to_non_nullable
as List<int>?,mastery: null == mastery ? _self.mastery : mastery // ignore: cast_nullable_to_non_nullable
as ContentId,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,costCp: null == costCp ? _self.costCp : costCp // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WeaponCategory category,  WeaponKind kind,  String damage, @ContentIdConverter()  ContentId damageType,  List<String> properties,  String? versatileDamage,  List<int>? rangeFeet, @ContentIdConverter()  ContentId mastery,  double weightKg,  int costCp)?  $default,{required TResult orElse(),}) {final _that = this;
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WeaponCategory category,  WeaponKind kind,  String damage, @ContentIdConverter()  ContentId damageType,  List<String> properties,  String? versatileDamage,  List<int>? rangeFeet, @ContentIdConverter()  ContentId mastery,  double weightKg,  int costCp)  $default,) {final _that = this;
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WeaponCategory category,  WeaponKind kind,  String damage, @ContentIdConverter()  ContentId damageType,  List<String> properties,  String? versatileDamage,  List<int>? rangeFeet, @ContentIdConverter()  ContentId mastery,  double weightKg,  int costCp)?  $default,) {final _that = this;
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
  const _WeaponData({required this.category, required this.kind, required this.damage, @ContentIdConverter() required this.damageType,  List<String> properties = const <String>[], this.versatileDamage,  List<int>? rangeFeet, @ContentIdConverter() required this.mastery, required this.weightKg, required this.costCp}): _properties = properties,_rangeFeet = rangeFeet;
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
@override final  double weightKg;
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
 WeaponCategory category, WeaponKind kind, String damage,@ContentIdConverter() ContentId damageType, List<String> properties, String? versatileDamage, List<int>? rangeFeet,@ContentIdConverter() ContentId mastery, double weightKg, int costCp
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
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? kind = null,Object? damage = null,Object? damageType = null,Object? properties = null,Object? versatileDamage = freezed,Object? rangeFeet = freezed,Object? mastery = null,Object? weightKg = null,Object? costCp = null,}) {
  return _then(_WeaponData(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as WeaponCategory,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as WeaponKind,damage: null == damage ? _self.damage : damage // ignore: cast_nullable_to_non_nullable
as String,damageType: null == damageType ? _self.damageType : damageType // ignore: cast_nullable_to_non_nullable
as ContentId,properties: null == properties ? _self._properties : properties // ignore: cast_nullable_to_non_nullable
as List<String>,versatileDamage: freezed == versatileDamage ? _self.versatileDamage : versatileDamage // ignore: cast_nullable_to_non_nullable
as String?,rangeFeet: freezed == rangeFeet ? _self._rangeFeet : rangeFeet // ignore: cast_nullable_to_non_nullable
as List<int>?,mastery: null == mastery ? _self.mastery : mastery // ignore: cast_nullable_to_non_nullable
as ContentId,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,costCp: null == costCp ? _self.costCp : costCp // ignore: cast_nullable_to_non_nullable
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
mixin _$GearData {

 double? get weightKg; int? get costCp;
/// Create a copy of GearData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GearDataCopyWith<GearData> get copyWith => _$GearDataCopyWithImpl<GearData>(this as GearData, _$identity);

  /// Serializes this GearData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GearData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GearData&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg)&&(identical(other.costCp, _this.costCp) || other.costCp == _this.costCp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GearData;
  return Object.hash(runtimeType,_this.weightKg,_this.costCp);
}

@override
String toString() {
  final _this = this as GearData;
  return 'GearData(weightKg: ${_this.weightKg}, costCp: ${_this.costCp})';
}


}

/// @nodoc
abstract mixin class $GearDataCopyWith<$Res>  {
  factory $GearDataCopyWith(GearData value, $Res Function(GearData) _then) = _$GearDataCopyWithImpl;
@useResult
$Res call({
 double? weightKg, int? costCp
});




}
/// @nodoc
class _$GearDataCopyWithImpl<$Res>
    implements $GearDataCopyWith<$Res> {
  _$GearDataCopyWithImpl(this._self, this._then);

  final GearData _self;
  final $Res Function(GearData) _then;

/// Create a copy of GearData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weightKg = freezed,Object? costCp = freezed,}) {
  return _then(GearData(
weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,costCp: freezed == costCp ? _self.costCp : costCp // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [GearData].
extension GearDataPatterns on GearData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GearData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GearData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GearData value)  $default,){
final _that = this;
switch (_that) {
case _GearData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GearData value)?  $default,){
final _that = this;
switch (_that) {
case _GearData() when $default != null:
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
case _GearData() when $default != null:
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
case _GearData():
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
case _GearData() when $default != null:
return $default(_that.weightKg,_that.costCp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GearData implements GearData {
  const _GearData({this.weightKg, this.costCp});
  factory _GearData.fromJson(Map<String, dynamic> json) => _$GearDataFromJson(json);

@override final  double? weightKg;
@override final  int? costCp;

/// Create a copy of GearData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GearDataCopyWith<_GearData> get copyWith => __$GearDataCopyWithImpl<_GearData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GearDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GearData&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.costCp, costCp) || other.costCp == costCp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,weightKg,costCp);
}

@override
String toString() {
    return 'GearData(weightKg: $weightKg, costCp: $costCp)';
}


}

/// @nodoc
abstract mixin class _$GearDataCopyWith<$Res> implements $GearDataCopyWith<$Res> {
  factory _$GearDataCopyWith(_GearData value, $Res Function(_GearData) _then) = __$GearDataCopyWithImpl;
@override @useResult
$Res call({
 double? weightKg, int? costCp
});




}
/// @nodoc
class __$GearDataCopyWithImpl<$Res>
    implements _$GearDataCopyWith<$Res> {
  __$GearDataCopyWithImpl(this._self, this._then);

  final _GearData _self;
  final $Res Function(_GearData) _then;

/// Create a copy of GearData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weightKg = freezed,Object? costCp = freezed,}) {
  return _then(_GearData(
weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,costCp: freezed == costCp ? _self.costCp : costCp // ignore: cast_nullable_to_non_nullable
as int?,
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
mixin _$ClassData {

@ContentIdConverter() List<ContentId> get primaryAbilities; int get hitDie;@ContentIdConverter() List<ContentId> get savingThrows; int get skillChoiceCount;@ContentIdConverter() List<ContentId> get skillChoices; List<String> get weaponProficiencies; List<String> get armorTraining; int get subclassLevel; List<ClassLevelData> get levels;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassData&&const DeepCollectionEquality().equals(other.primaryAbilities, _this.primaryAbilities)&&(identical(other.hitDie, _this.hitDie) || other.hitDie == _this.hitDie)&&const DeepCollectionEquality().equals(other.savingThrows, _this.savingThrows)&&(identical(other.skillChoiceCount, _this.skillChoiceCount) || other.skillChoiceCount == _this.skillChoiceCount)&&const DeepCollectionEquality().equals(other.skillChoices, _this.skillChoices)&&const DeepCollectionEquality().equals(other.weaponProficiencies, _this.weaponProficiencies)&&const DeepCollectionEquality().equals(other.armorTraining, _this.armorTraining)&&(identical(other.subclassLevel, _this.subclassLevel) || other.subclassLevel == _this.subclassLevel)&&const DeepCollectionEquality().equals(other.levels, _this.levels));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ClassData;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.primaryAbilities),_this.hitDie,const DeepCollectionEquality().hash(_this.savingThrows),_this.skillChoiceCount,const DeepCollectionEquality().hash(_this.skillChoices),const DeepCollectionEquality().hash(_this.weaponProficiencies),const DeepCollectionEquality().hash(_this.armorTraining),_this.subclassLevel,const DeepCollectionEquality().hash(_this.levels));
}

@override
String toString() {
  final _this = this as ClassData;
  return 'ClassData(primaryAbilities: ${_this.primaryAbilities}, hitDie: ${_this.hitDie}, savingThrows: ${_this.savingThrows}, skillChoiceCount: ${_this.skillChoiceCount}, skillChoices: ${_this.skillChoices}, weaponProficiencies: ${_this.weaponProficiencies}, armorTraining: ${_this.armorTraining}, subclassLevel: ${_this.subclassLevel}, levels: ${_this.levels})';
}


}

/// @nodoc
abstract mixin class $ClassDataCopyWith<$Res>  {
  factory $ClassDataCopyWith(ClassData value, $Res Function(ClassData) _then) = _$ClassDataCopyWithImpl;
@useResult
$Res call({
@ContentIdConverter() List<ContentId> primaryAbilities, int hitDie,@ContentIdConverter() List<ContentId> savingThrows, int skillChoiceCount,@ContentIdConverter() List<ContentId> skillChoices, List<String> weaponProficiencies, List<String> armorTraining, int subclassLevel, List<ClassLevelData> levels
});




}
/// @nodoc
class _$ClassDataCopyWithImpl<$Res>
    implements $ClassDataCopyWith<$Res> {
  _$ClassDataCopyWithImpl(this._self, this._then);

  final ClassData _self;
  final $Res Function(ClassData) _then;

/// Create a copy of ClassData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? primaryAbilities = null,Object? hitDie = null,Object? savingThrows = null,Object? skillChoiceCount = null,Object? skillChoices = null,Object? weaponProficiencies = null,Object? armorTraining = null,Object? subclassLevel = null,Object? levels = null,}) {
  return _then(ClassData(
primaryAbilities: null == primaryAbilities ? _self.primaryAbilities : primaryAbilities // ignore: cast_nullable_to_non_nullable
as List<ContentId>,hitDie: null == hitDie ? _self.hitDie : hitDie // ignore: cast_nullable_to_non_nullable
as int,savingThrows: null == savingThrows ? _self.savingThrows : savingThrows // ignore: cast_nullable_to_non_nullable
as List<ContentId>,skillChoiceCount: null == skillChoiceCount ? _self.skillChoiceCount : skillChoiceCount // ignore: cast_nullable_to_non_nullable
as int,skillChoices: null == skillChoices ? _self.skillChoices : skillChoices // ignore: cast_nullable_to_non_nullable
as List<ContentId>,weaponProficiencies: null == weaponProficiencies ? _self.weaponProficiencies : weaponProficiencies // ignore: cast_nullable_to_non_nullable
as List<String>,armorTraining: null == armorTraining ? _self.armorTraining : armorTraining // ignore: cast_nullable_to_non_nullable
as List<String>,subclassLevel: null == subclassLevel ? _self.subclassLevel : subclassLevel // ignore: cast_nullable_to_non_nullable
as int,levels: null == levels ? _self.levels : levels // ignore: cast_nullable_to_non_nullable
as List<ClassLevelData>,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@ContentIdConverter()  List<ContentId> primaryAbilities,  int hitDie, @ContentIdConverter()  List<ContentId> savingThrows,  int skillChoiceCount, @ContentIdConverter()  List<ContentId> skillChoices,  List<String> weaponProficiencies,  List<String> armorTraining,  int subclassLevel,  List<ClassLevelData> levels)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClassData() when $default != null:
return $default(_that.primaryAbilities,_that.hitDie,_that.savingThrows,_that.skillChoiceCount,_that.skillChoices,_that.weaponProficiencies,_that.armorTraining,_that.subclassLevel,_that.levels);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@ContentIdConverter()  List<ContentId> primaryAbilities,  int hitDie, @ContentIdConverter()  List<ContentId> savingThrows,  int skillChoiceCount, @ContentIdConverter()  List<ContentId> skillChoices,  List<String> weaponProficiencies,  List<String> armorTraining,  int subclassLevel,  List<ClassLevelData> levels)  $default,) {final _that = this;
switch (_that) {
case _ClassData():
return $default(_that.primaryAbilities,_that.hitDie,_that.savingThrows,_that.skillChoiceCount,_that.skillChoices,_that.weaponProficiencies,_that.armorTraining,_that.subclassLevel,_that.levels);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@ContentIdConverter()  List<ContentId> primaryAbilities,  int hitDie, @ContentIdConverter()  List<ContentId> savingThrows,  int skillChoiceCount, @ContentIdConverter()  List<ContentId> skillChoices,  List<String> weaponProficiencies,  List<String> armorTraining,  int subclassLevel,  List<ClassLevelData> levels)?  $default,) {final _that = this;
switch (_that) {
case _ClassData() when $default != null:
return $default(_that.primaryAbilities,_that.hitDie,_that.savingThrows,_that.skillChoiceCount,_that.skillChoices,_that.weaponProficiencies,_that.armorTraining,_that.subclassLevel,_that.levels);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClassData implements ClassData {
  const _ClassData({@ContentIdConverter() required  List<ContentId> primaryAbilities, required this.hitDie, @ContentIdConverter() required  List<ContentId> savingThrows, required this.skillChoiceCount, @ContentIdConverter() required  List<ContentId> skillChoices, required  List<String> weaponProficiencies, required  List<String> armorTraining, required this.subclassLevel, required  List<ClassLevelData> levels}): _primaryAbilities = primaryAbilities,_savingThrows = savingThrows,_skillChoices = skillChoices,_weaponProficiencies = weaponProficiencies,_armorTraining = armorTraining,_levels = levels;
  factory _ClassData.fromJson(Map<String, dynamic> json) => _$ClassDataFromJson(json);

 final  List<ContentId> _primaryAbilities;
@override@ContentIdConverter() List<ContentId> get primaryAbilities {
  if (_primaryAbilities is EqualUnmodifiableListView) return _primaryAbilities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_primaryAbilities);
}

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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassData&&const DeepCollectionEquality().equals(other.primaryAbilities, _primaryAbilities)&&(identical(other.hitDie, hitDie) || other.hitDie == hitDie)&&const DeepCollectionEquality().equals(other.savingThrows, _savingThrows)&&(identical(other.skillChoiceCount, skillChoiceCount) || other.skillChoiceCount == skillChoiceCount)&&const DeepCollectionEquality().equals(other.skillChoices, _skillChoices)&&const DeepCollectionEquality().equals(other.weaponProficiencies, _weaponProficiencies)&&const DeepCollectionEquality().equals(other.armorTraining, _armorTraining)&&(identical(other.subclassLevel, subclassLevel) || other.subclassLevel == subclassLevel)&&const DeepCollectionEquality().equals(other.levels, _levels));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_primaryAbilities),hitDie,const DeepCollectionEquality().hash(_savingThrows),skillChoiceCount,const DeepCollectionEquality().hash(_skillChoices),const DeepCollectionEquality().hash(_weaponProficiencies),const DeepCollectionEquality().hash(_armorTraining),subclassLevel,const DeepCollectionEquality().hash(_levels));
}

@override
String toString() {
    return 'ClassData(primaryAbilities: $primaryAbilities, hitDie: $hitDie, savingThrows: $savingThrows, skillChoiceCount: $skillChoiceCount, skillChoices: $skillChoices, weaponProficiencies: $weaponProficiencies, armorTraining: $armorTraining, subclassLevel: $subclassLevel, levels: $levels)';
}


}

/// @nodoc
abstract mixin class _$ClassDataCopyWith<$Res> implements $ClassDataCopyWith<$Res> {
  factory _$ClassDataCopyWith(_ClassData value, $Res Function(_ClassData) _then) = __$ClassDataCopyWithImpl;
@override @useResult
$Res call({
@ContentIdConverter() List<ContentId> primaryAbilities, int hitDie,@ContentIdConverter() List<ContentId> savingThrows, int skillChoiceCount,@ContentIdConverter() List<ContentId> skillChoices, List<String> weaponProficiencies, List<String> armorTraining, int subclassLevel, List<ClassLevelData> levels
});




}
/// @nodoc
class __$ClassDataCopyWithImpl<$Res>
    implements _$ClassDataCopyWith<$Res> {
  __$ClassDataCopyWithImpl(this._self, this._then);

  final _ClassData _self;
  final $Res Function(_ClassData) _then;

/// Create a copy of ClassData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? primaryAbilities = null,Object? hitDie = null,Object? savingThrows = null,Object? skillChoiceCount = null,Object? skillChoices = null,Object? weaponProficiencies = null,Object? armorTraining = null,Object? subclassLevel = null,Object? levels = null,}) {
  return _then(_ClassData(
primaryAbilities: null == primaryAbilities ? _self._primaryAbilities : primaryAbilities // ignore: cast_nullable_to_non_nullable
as List<ContentId>,hitDie: null == hitDie ? _self.hitDie : hitDie // ignore: cast_nullable_to_non_nullable
as int,savingThrows: null == savingThrows ? _self._savingThrows : savingThrows // ignore: cast_nullable_to_non_nullable
as List<ContentId>,skillChoiceCount: null == skillChoiceCount ? _self.skillChoiceCount : skillChoiceCount // ignore: cast_nullable_to_non_nullable
as int,skillChoices: null == skillChoices ? _self._skillChoices : skillChoices // ignore: cast_nullable_to_non_nullable
as List<ContentId>,weaponProficiencies: null == weaponProficiencies ? _self._weaponProficiencies : weaponProficiencies // ignore: cast_nullable_to_non_nullable
as List<String>,armorTraining: null == armorTraining ? _self._armorTraining : armorTraining // ignore: cast_nullable_to_non_nullable
as List<String>,subclassLevel: null == subclassLevel ? _self.subclassLevel : subclassLevel // ignore: cast_nullable_to_non_nullable
as int,levels: null == levels ? _self._levels : levels // ignore: cast_nullable_to_non_nullable
as List<ClassLevelData>,
  ));
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

// dart format on
