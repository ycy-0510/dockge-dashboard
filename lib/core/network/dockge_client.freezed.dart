// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dockge_client.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DockgeClientState {

 io.Socket? get socket; String? get error; String? get endpoint; SocketStatus get status;
/// Create a copy of DockgeClientState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DockgeClientStateCopyWith<DockgeClientState> get copyWith => _$DockgeClientStateCopyWithImpl<DockgeClientState>(this as DockgeClientState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DockgeClientState&&(identical(other.socket, socket) || other.socket == socket)&&(identical(other.error, error) || other.error == error)&&(identical(other.endpoint, endpoint) || other.endpoint == endpoint)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,socket,error,endpoint,status);

@override
String toString() {
  return 'DockgeClientState(socket: $socket, error: $error, endpoint: $endpoint, status: $status)';
}


}

/// @nodoc
abstract mixin class $DockgeClientStateCopyWith<$Res>  {
  factory $DockgeClientStateCopyWith(DockgeClientState value, $Res Function(DockgeClientState) _then) = _$DockgeClientStateCopyWithImpl;
@useResult
$Res call({
 io.Socket? socket, String? error, String? endpoint, SocketStatus status
});




}
/// @nodoc
class _$DockgeClientStateCopyWithImpl<$Res>
    implements $DockgeClientStateCopyWith<$Res> {
  _$DockgeClientStateCopyWithImpl(this._self, this._then);

  final DockgeClientState _self;
  final $Res Function(DockgeClientState) _then;

/// Create a copy of DockgeClientState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? socket = freezed,Object? error = freezed,Object? endpoint = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
socket: freezed == socket ? _self.socket : socket // ignore: cast_nullable_to_non_nullable
as io.Socket?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,endpoint: freezed == endpoint ? _self.endpoint : endpoint // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SocketStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [DockgeClientState].
extension DockgeClientStatePatterns on DockgeClientState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DockgeClientState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DockgeClientState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DockgeClientState value)  $default,){
final _that = this;
switch (_that) {
case _DockgeClientState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DockgeClientState value)?  $default,){
final _that = this;
switch (_that) {
case _DockgeClientState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( io.Socket? socket,  String? error,  String? endpoint,  SocketStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DockgeClientState() when $default != null:
return $default(_that.socket,_that.error,_that.endpoint,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( io.Socket? socket,  String? error,  String? endpoint,  SocketStatus status)  $default,) {final _that = this;
switch (_that) {
case _DockgeClientState():
return $default(_that.socket,_that.error,_that.endpoint,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( io.Socket? socket,  String? error,  String? endpoint,  SocketStatus status)?  $default,) {final _that = this;
switch (_that) {
case _DockgeClientState() when $default != null:
return $default(_that.socket,_that.error,_that.endpoint,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _DockgeClientState extends DockgeClientState {
  const _DockgeClientState({this.socket, this.error, required this.endpoint, required this.status}): super._();
  

@override final  io.Socket? socket;
@override final  String? error;
@override final  String? endpoint;
@override final  SocketStatus status;

/// Create a copy of DockgeClientState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DockgeClientStateCopyWith<_DockgeClientState> get copyWith => __$DockgeClientStateCopyWithImpl<_DockgeClientState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DockgeClientState&&(identical(other.socket, socket) || other.socket == socket)&&(identical(other.error, error) || other.error == error)&&(identical(other.endpoint, endpoint) || other.endpoint == endpoint)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,socket,error,endpoint,status);

@override
String toString() {
  return 'DockgeClientState(socket: $socket, error: $error, endpoint: $endpoint, status: $status)';
}


}

/// @nodoc
abstract mixin class _$DockgeClientStateCopyWith<$Res> implements $DockgeClientStateCopyWith<$Res> {
  factory _$DockgeClientStateCopyWith(_DockgeClientState value, $Res Function(_DockgeClientState) _then) = __$DockgeClientStateCopyWithImpl;
@override @useResult
$Res call({
 io.Socket? socket, String? error, String? endpoint, SocketStatus status
});




}
/// @nodoc
class __$DockgeClientStateCopyWithImpl<$Res>
    implements _$DockgeClientStateCopyWith<$Res> {
  __$DockgeClientStateCopyWithImpl(this._self, this._then);

  final _DockgeClientState _self;
  final $Res Function(_DockgeClientState) _then;

/// Create a copy of DockgeClientState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? socket = freezed,Object? error = freezed,Object? endpoint = freezed,Object? status = null,}) {
  return _then(_DockgeClientState(
socket: freezed == socket ? _self.socket : socket // ignore: cast_nullable_to_non_nullable
as io.Socket?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,endpoint: freezed == endpoint ? _self.endpoint : endpoint // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SocketStatus,
  ));
}


}

// dart format on
