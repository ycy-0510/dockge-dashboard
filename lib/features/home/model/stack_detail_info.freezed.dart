// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stack_detail_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StackDetailInfo {

 String get name; List<ServiceInfo> get services;
/// Create a copy of StackDetailInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StackDetailInfoCopyWith<StackDetailInfo> get copyWith => _$StackDetailInfoCopyWithImpl<StackDetailInfo>(this as StackDetailInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StackDetailInfo&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.services, services));
}


@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(services));

@override
String toString() {
  return 'StackDetailInfo(name: $name, services: $services)';
}


}

/// @nodoc
abstract mixin class $StackDetailInfoCopyWith<$Res>  {
  factory $StackDetailInfoCopyWith(StackDetailInfo value, $Res Function(StackDetailInfo) _then) = _$StackDetailInfoCopyWithImpl;
@useResult
$Res call({
 String name, List<ServiceInfo> services
});




}
/// @nodoc
class _$StackDetailInfoCopyWithImpl<$Res>
    implements $StackDetailInfoCopyWith<$Res> {
  _$StackDetailInfoCopyWithImpl(this._self, this._then);

  final StackDetailInfo _self;
  final $Res Function(StackDetailInfo) _then;

/// Create a copy of StackDetailInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? services = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,services: null == services ? _self.services : services // ignore: cast_nullable_to_non_nullable
as List<ServiceInfo>,
  ));
}

}


/// Adds pattern-matching-related methods to [StackDetailInfo].
extension StackDetailInfoPatterns on StackDetailInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StackDetailInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StackDetailInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StackDetailInfo value)  $default,){
final _that = this;
switch (_that) {
case _StackDetailInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StackDetailInfo value)?  $default,){
final _that = this;
switch (_that) {
case _StackDetailInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  List<ServiceInfo> services)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StackDetailInfo() when $default != null:
return $default(_that.name,_that.services);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  List<ServiceInfo> services)  $default,) {final _that = this;
switch (_that) {
case _StackDetailInfo():
return $default(_that.name,_that.services);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  List<ServiceInfo> services)?  $default,) {final _that = this;
switch (_that) {
case _StackDetailInfo() when $default != null:
return $default(_that.name,_that.services);case _:
  return null;

}
}

}

/// @nodoc


class _StackDetailInfo implements StackDetailInfo {
  const _StackDetailInfo({required this.name, required final  List<ServiceInfo> services}): _services = services;
  

@override final  String name;
 final  List<ServiceInfo> _services;
@override List<ServiceInfo> get services {
  if (_services is EqualUnmodifiableListView) return _services;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_services);
}


/// Create a copy of StackDetailInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StackDetailInfoCopyWith<_StackDetailInfo> get copyWith => __$StackDetailInfoCopyWithImpl<_StackDetailInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StackDetailInfo&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._services, _services));
}


@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(_services));

@override
String toString() {
  return 'StackDetailInfo(name: $name, services: $services)';
}


}

/// @nodoc
abstract mixin class _$StackDetailInfoCopyWith<$Res> implements $StackDetailInfoCopyWith<$Res> {
  factory _$StackDetailInfoCopyWith(_StackDetailInfo value, $Res Function(_StackDetailInfo) _then) = __$StackDetailInfoCopyWithImpl;
@override @useResult
$Res call({
 String name, List<ServiceInfo> services
});




}
/// @nodoc
class __$StackDetailInfoCopyWithImpl<$Res>
    implements _$StackDetailInfoCopyWith<$Res> {
  __$StackDetailInfoCopyWithImpl(this._self, this._then);

  final _StackDetailInfo _self;
  final $Res Function(_StackDetailInfo) _then;

/// Create a copy of StackDetailInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? services = null,}) {
  return _then(_StackDetailInfo(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,services: null == services ? _self._services : services // ignore: cast_nullable_to_non_nullable
as List<ServiceInfo>,
  ));
}


}

/// @nodoc
mixin _$ServiceInfo {

 String get name; String get imageName; String get status; List<PortMapping> get ports;
/// Create a copy of ServiceInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceInfoCopyWith<ServiceInfo> get copyWith => _$ServiceInfoCopyWithImpl<ServiceInfo>(this as ServiceInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.imageName, imageName) || other.imageName == imageName)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.ports, ports));
}


@override
int get hashCode => Object.hash(runtimeType,name,imageName,status,const DeepCollectionEquality().hash(ports));

@override
String toString() {
  return 'ServiceInfo(name: $name, imageName: $imageName, status: $status, ports: $ports)';
}


}

/// @nodoc
abstract mixin class $ServiceInfoCopyWith<$Res>  {
  factory $ServiceInfoCopyWith(ServiceInfo value, $Res Function(ServiceInfo) _then) = _$ServiceInfoCopyWithImpl;
@useResult
$Res call({
 String name, String imageName, String status, List<PortMapping> ports
});




}
/// @nodoc
class _$ServiceInfoCopyWithImpl<$Res>
    implements $ServiceInfoCopyWith<$Res> {
  _$ServiceInfoCopyWithImpl(this._self, this._then);

  final ServiceInfo _self;
  final $Res Function(ServiceInfo) _then;

/// Create a copy of ServiceInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? imageName = null,Object? status = null,Object? ports = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageName: null == imageName ? _self.imageName : imageName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,ports: null == ports ? _self.ports : ports // ignore: cast_nullable_to_non_nullable
as List<PortMapping>,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceInfo].
extension ServiceInfoPatterns on ServiceInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceInfo value)  $default,){
final _that = this;
switch (_that) {
case _ServiceInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String imageName,  String status,  List<PortMapping> ports)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceInfo() when $default != null:
return $default(_that.name,_that.imageName,_that.status,_that.ports);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String imageName,  String status,  List<PortMapping> ports)  $default,) {final _that = this;
switch (_that) {
case _ServiceInfo():
return $default(_that.name,_that.imageName,_that.status,_that.ports);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String imageName,  String status,  List<PortMapping> ports)?  $default,) {final _that = this;
switch (_that) {
case _ServiceInfo() when $default != null:
return $default(_that.name,_that.imageName,_that.status,_that.ports);case _:
  return null;

}
}

}

/// @nodoc


class _ServiceInfo implements ServiceInfo {
  const _ServiceInfo({required this.name, required this.imageName, required this.status, required final  List<PortMapping> ports}): _ports = ports;
  

@override final  String name;
@override final  String imageName;
@override final  String status;
 final  List<PortMapping> _ports;
@override List<PortMapping> get ports {
  if (_ports is EqualUnmodifiableListView) return _ports;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ports);
}


/// Create a copy of ServiceInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceInfoCopyWith<_ServiceInfo> get copyWith => __$ServiceInfoCopyWithImpl<_ServiceInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.imageName, imageName) || other.imageName == imageName)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._ports, _ports));
}


@override
int get hashCode => Object.hash(runtimeType,name,imageName,status,const DeepCollectionEquality().hash(_ports));

@override
String toString() {
  return 'ServiceInfo(name: $name, imageName: $imageName, status: $status, ports: $ports)';
}


}

/// @nodoc
abstract mixin class _$ServiceInfoCopyWith<$Res> implements $ServiceInfoCopyWith<$Res> {
  factory _$ServiceInfoCopyWith(_ServiceInfo value, $Res Function(_ServiceInfo) _then) = __$ServiceInfoCopyWithImpl;
@override @useResult
$Res call({
 String name, String imageName, String status, List<PortMapping> ports
});




}
/// @nodoc
class __$ServiceInfoCopyWithImpl<$Res>
    implements _$ServiceInfoCopyWith<$Res> {
  __$ServiceInfoCopyWithImpl(this._self, this._then);

  final _ServiceInfo _self;
  final $Res Function(_ServiceInfo) _then;

/// Create a copy of ServiceInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? imageName = null,Object? status = null,Object? ports = null,}) {
  return _then(_ServiceInfo(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageName: null == imageName ? _self.imageName : imageName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,ports: null == ports ? _self._ports : ports // ignore: cast_nullable_to_non_nullable
as List<PortMapping>,
  ));
}


}

// dart format on
