// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stack_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StackItem {

 String get name; StackStatus get status; bool get isManagedByDockge; String get composeFileName; String? get endpoint;
/// Create a copy of StackItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StackItemCopyWith<StackItem> get copyWith => _$StackItemCopyWithImpl<StackItem>(this as StackItem, _$identity);

  /// Serializes this StackItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StackItem&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.isManagedByDockge, isManagedByDockge) || other.isManagedByDockge == isManagedByDockge)&&(identical(other.composeFileName, composeFileName) || other.composeFileName == composeFileName)&&(identical(other.endpoint, endpoint) || other.endpoint == endpoint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,status,isManagedByDockge,composeFileName,endpoint);

@override
String toString() {
  return 'StackItem(name: $name, status: $status, isManagedByDockge: $isManagedByDockge, composeFileName: $composeFileName, endpoint: $endpoint)';
}


}

/// @nodoc
abstract mixin class $StackItemCopyWith<$Res>  {
  factory $StackItemCopyWith(StackItem value, $Res Function(StackItem) _then) = _$StackItemCopyWithImpl;
@useResult
$Res call({
 String name, StackStatus status, bool isManagedByDockge, String composeFileName, String? endpoint
});




}
/// @nodoc
class _$StackItemCopyWithImpl<$Res>
    implements $StackItemCopyWith<$Res> {
  _$StackItemCopyWithImpl(this._self, this._then);

  final StackItem _self;
  final $Res Function(StackItem) _then;

/// Create a copy of StackItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? status = null,Object? isManagedByDockge = null,Object? composeFileName = null,Object? endpoint = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StackStatus,isManagedByDockge: null == isManagedByDockge ? _self.isManagedByDockge : isManagedByDockge // ignore: cast_nullable_to_non_nullable
as bool,composeFileName: null == composeFileName ? _self.composeFileName : composeFileName // ignore: cast_nullable_to_non_nullable
as String,endpoint: freezed == endpoint ? _self.endpoint : endpoint // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StackItem].
extension StackItemPatterns on StackItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StackItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StackItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StackItem value)  $default,){
final _that = this;
switch (_that) {
case _StackItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StackItem value)?  $default,){
final _that = this;
switch (_that) {
case _StackItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  StackStatus status,  bool isManagedByDockge,  String composeFileName,  String? endpoint)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StackItem() when $default != null:
return $default(_that.name,_that.status,_that.isManagedByDockge,_that.composeFileName,_that.endpoint);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  StackStatus status,  bool isManagedByDockge,  String composeFileName,  String? endpoint)  $default,) {final _that = this;
switch (_that) {
case _StackItem():
return $default(_that.name,_that.status,_that.isManagedByDockge,_that.composeFileName,_that.endpoint);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  StackStatus status,  bool isManagedByDockge,  String composeFileName,  String? endpoint)?  $default,) {final _that = this;
switch (_that) {
case _StackItem() when $default != null:
return $default(_that.name,_that.status,_that.isManagedByDockge,_that.composeFileName,_that.endpoint);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StackItem implements StackItem {
  const _StackItem({required this.name, required this.status, required this.isManagedByDockge, required this.composeFileName, this.endpoint});
  factory _StackItem.fromJson(Map<String, dynamic> json) => _$StackItemFromJson(json);

@override final  String name;
@override final  StackStatus status;
@override final  bool isManagedByDockge;
@override final  String composeFileName;
@override final  String? endpoint;

/// Create a copy of StackItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StackItemCopyWith<_StackItem> get copyWith => __$StackItemCopyWithImpl<_StackItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StackItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StackItem&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.isManagedByDockge, isManagedByDockge) || other.isManagedByDockge == isManagedByDockge)&&(identical(other.composeFileName, composeFileName) || other.composeFileName == composeFileName)&&(identical(other.endpoint, endpoint) || other.endpoint == endpoint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,status,isManagedByDockge,composeFileName,endpoint);

@override
String toString() {
  return 'StackItem(name: $name, status: $status, isManagedByDockge: $isManagedByDockge, composeFileName: $composeFileName, endpoint: $endpoint)';
}


}

/// @nodoc
abstract mixin class _$StackItemCopyWith<$Res> implements $StackItemCopyWith<$Res> {
  factory _$StackItemCopyWith(_StackItem value, $Res Function(_StackItem) _then) = __$StackItemCopyWithImpl;
@override @useResult
$Res call({
 String name, StackStatus status, bool isManagedByDockge, String composeFileName, String? endpoint
});




}
/// @nodoc
class __$StackItemCopyWithImpl<$Res>
    implements _$StackItemCopyWith<$Res> {
  __$StackItemCopyWithImpl(this._self, this._then);

  final _StackItem _self;
  final $Res Function(_StackItem) _then;

/// Create a copy of StackItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? status = null,Object? isManagedByDockge = null,Object? composeFileName = null,Object? endpoint = freezed,}) {
  return _then(_StackItem(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StackStatus,isManagedByDockge: null == isManagedByDockge ? _self.isManagedByDockge : isManagedByDockge // ignore: cast_nullable_to_non_nullable
as bool,composeFileName: null == composeFileName ? _self.composeFileName : composeFileName // ignore: cast_nullable_to_non_nullable
as String,endpoint: freezed == endpoint ? _self.endpoint : endpoint // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StackInfo {

 bool get ok; Map<String, StackItem> get stackList;
/// Create a copy of StackInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StackInfoCopyWith<StackInfo> get copyWith => _$StackInfoCopyWithImpl<StackInfo>(this as StackInfo, _$identity);

  /// Serializes this StackInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StackInfo&&(identical(other.ok, ok) || other.ok == ok)&&const DeepCollectionEquality().equals(other.stackList, stackList));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,const DeepCollectionEquality().hash(stackList));

@override
String toString() {
  return 'StackInfo(ok: $ok, stackList: $stackList)';
}


}

/// @nodoc
abstract mixin class $StackInfoCopyWith<$Res>  {
  factory $StackInfoCopyWith(StackInfo value, $Res Function(StackInfo) _then) = _$StackInfoCopyWithImpl;
@useResult
$Res call({
 bool ok, Map<String, StackItem> stackList
});




}
/// @nodoc
class _$StackInfoCopyWithImpl<$Res>
    implements $StackInfoCopyWith<$Res> {
  _$StackInfoCopyWithImpl(this._self, this._then);

  final StackInfo _self;
  final $Res Function(StackInfo) _then;

/// Create a copy of StackInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? stackList = null,}) {
  return _then(_self.copyWith(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,stackList: null == stackList ? _self.stackList : stackList // ignore: cast_nullable_to_non_nullable
as Map<String, StackItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [StackInfo].
extension StackInfoPatterns on StackInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StackInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StackInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StackInfo value)  $default,){
final _that = this;
switch (_that) {
case _StackInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StackInfo value)?  $default,){
final _that = this;
switch (_that) {
case _StackInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  Map<String, StackItem> stackList)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StackInfo() when $default != null:
return $default(_that.ok,_that.stackList);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  Map<String, StackItem> stackList)  $default,) {final _that = this;
switch (_that) {
case _StackInfo():
return $default(_that.ok,_that.stackList);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  Map<String, StackItem> stackList)?  $default,) {final _that = this;
switch (_that) {
case _StackInfo() when $default != null:
return $default(_that.ok,_that.stackList);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StackInfo implements StackInfo {
  const _StackInfo({required this.ok, required final  Map<String, StackItem> stackList}): _stackList = stackList;
  factory _StackInfo.fromJson(Map<String, dynamic> json) => _$StackInfoFromJson(json);

@override final  bool ok;
 final  Map<String, StackItem> _stackList;
@override Map<String, StackItem> get stackList {
  if (_stackList is EqualUnmodifiableMapView) return _stackList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_stackList);
}


/// Create a copy of StackInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StackInfoCopyWith<_StackInfo> get copyWith => __$StackInfoCopyWithImpl<_StackInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StackInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StackInfo&&(identical(other.ok, ok) || other.ok == ok)&&const DeepCollectionEquality().equals(other._stackList, _stackList));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ok,const DeepCollectionEquality().hash(_stackList));

@override
String toString() {
  return 'StackInfo(ok: $ok, stackList: $stackList)';
}


}

/// @nodoc
abstract mixin class _$StackInfoCopyWith<$Res> implements $StackInfoCopyWith<$Res> {
  factory _$StackInfoCopyWith(_StackInfo value, $Res Function(_StackInfo) _then) = __$StackInfoCopyWithImpl;
@override @useResult
$Res call({
 bool ok, Map<String, StackItem> stackList
});




}
/// @nodoc
class __$StackInfoCopyWithImpl<$Res>
    implements _$StackInfoCopyWith<$Res> {
  __$StackInfoCopyWithImpl(this._self, this._then);

  final _StackInfo _self;
  final $Res Function(_StackInfo) _then;

/// Create a copy of StackInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? stackList = null,}) {
  return _then(_StackInfo(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,stackList: null == stackList ? _self._stackList : stackList // ignore: cast_nullable_to_non_nullable
as Map<String, StackItem>,
  ));
}


}

// dart format on
