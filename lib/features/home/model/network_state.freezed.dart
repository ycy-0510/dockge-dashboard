// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'network_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PortState {

 int? get port; String get stackName; String get serviceName;
/// Create a copy of PortState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PortStateCopyWith<PortState> get copyWith => _$PortStateCopyWithImpl<PortState>(this as PortState, _$identity);

  /// Serializes this PortState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PortState&&(identical(other.port, port) || other.port == port)&&(identical(other.stackName, stackName) || other.stackName == stackName)&&(identical(other.serviceName, serviceName) || other.serviceName == serviceName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,port,stackName,serviceName);

@override
String toString() {
  return 'PortState(port: $port, stackName: $stackName, serviceName: $serviceName)';
}


}

/// @nodoc
abstract mixin class $PortStateCopyWith<$Res>  {
  factory $PortStateCopyWith(PortState value, $Res Function(PortState) _then) = _$PortStateCopyWithImpl;
@useResult
$Res call({
 int? port, String stackName, String serviceName
});




}
/// @nodoc
class _$PortStateCopyWithImpl<$Res>
    implements $PortStateCopyWith<$Res> {
  _$PortStateCopyWithImpl(this._self, this._then);

  final PortState _self;
  final $Res Function(PortState) _then;

/// Create a copy of PortState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? port = freezed,Object? stackName = null,Object? serviceName = null,}) {
  return _then(_self.copyWith(
port: freezed == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int?,stackName: null == stackName ? _self.stackName : stackName // ignore: cast_nullable_to_non_nullable
as String,serviceName: null == serviceName ? _self.serviceName : serviceName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PortState].
extension PortStatePatterns on PortState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PortState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PortState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PortState value)  $default,){
final _that = this;
switch (_that) {
case _PortState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PortState value)?  $default,){
final _that = this;
switch (_that) {
case _PortState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? port,  String stackName,  String serviceName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PortState() when $default != null:
return $default(_that.port,_that.stackName,_that.serviceName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? port,  String stackName,  String serviceName)  $default,) {final _that = this;
switch (_that) {
case _PortState():
return $default(_that.port,_that.stackName,_that.serviceName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? port,  String stackName,  String serviceName)?  $default,) {final _that = this;
switch (_that) {
case _PortState() when $default != null:
return $default(_that.port,_that.stackName,_that.serviceName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PortState implements PortState {
  const _PortState({this.port, required this.stackName, required this.serviceName});
  factory _PortState.fromJson(Map<String, dynamic> json) => _$PortStateFromJson(json);

@override final  int? port;
@override final  String stackName;
@override final  String serviceName;

/// Create a copy of PortState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PortStateCopyWith<_PortState> get copyWith => __$PortStateCopyWithImpl<_PortState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PortStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PortState&&(identical(other.port, port) || other.port == port)&&(identical(other.stackName, stackName) || other.stackName == stackName)&&(identical(other.serviceName, serviceName) || other.serviceName == serviceName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,port,stackName,serviceName);

@override
String toString() {
  return 'PortState(port: $port, stackName: $stackName, serviceName: $serviceName)';
}


}

/// @nodoc
abstract mixin class _$PortStateCopyWith<$Res> implements $PortStateCopyWith<$Res> {
  factory _$PortStateCopyWith(_PortState value, $Res Function(_PortState) _then) = __$PortStateCopyWithImpl;
@override @useResult
$Res call({
 int? port, String stackName, String serviceName
});




}
/// @nodoc
class __$PortStateCopyWithImpl<$Res>
    implements _$PortStateCopyWith<$Res> {
  __$PortStateCopyWithImpl(this._self, this._then);

  final _PortState _self;
  final $Res Function(_PortState) _then;

/// Create a copy of PortState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? port = freezed,Object? stackName = null,Object? serviceName = null,}) {
  return _then(_PortState(
port: freezed == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int?,stackName: null == stackName ? _self.stackName : stackName // ignore: cast_nullable_to_non_nullable
as String,serviceName: null == serviceName ? _self.serviceName : serviceName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GlobalNetworkState {

 String get network; List<String> get stackNames;
/// Create a copy of GlobalNetworkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GlobalNetworkStateCopyWith<GlobalNetworkState> get copyWith => _$GlobalNetworkStateCopyWithImpl<GlobalNetworkState>(this as GlobalNetworkState, _$identity);

  /// Serializes this GlobalNetworkState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlobalNetworkState&&(identical(other.network, network) || other.network == network)&&const DeepCollectionEquality().equals(other.stackNames, stackNames));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,network,const DeepCollectionEquality().hash(stackNames));

@override
String toString() {
  return 'GlobalNetworkState(network: $network, stackNames: $stackNames)';
}


}

/// @nodoc
abstract mixin class $GlobalNetworkStateCopyWith<$Res>  {
  factory $GlobalNetworkStateCopyWith(GlobalNetworkState value, $Res Function(GlobalNetworkState) _then) = _$GlobalNetworkStateCopyWithImpl;
@useResult
$Res call({
 String network, List<String> stackNames
});




}
/// @nodoc
class _$GlobalNetworkStateCopyWithImpl<$Res>
    implements $GlobalNetworkStateCopyWith<$Res> {
  _$GlobalNetworkStateCopyWithImpl(this._self, this._then);

  final GlobalNetworkState _self;
  final $Res Function(GlobalNetworkState) _then;

/// Create a copy of GlobalNetworkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? network = null,Object? stackNames = null,}) {
  return _then(_self.copyWith(
network: null == network ? _self.network : network // ignore: cast_nullable_to_non_nullable
as String,stackNames: null == stackNames ? _self.stackNames : stackNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [GlobalNetworkState].
extension GlobalNetworkStatePatterns on GlobalNetworkState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GlobalNetworkState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GlobalNetworkState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GlobalNetworkState value)  $default,){
final _that = this;
switch (_that) {
case _GlobalNetworkState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GlobalNetworkState value)?  $default,){
final _that = this;
switch (_that) {
case _GlobalNetworkState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String network,  List<String> stackNames)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GlobalNetworkState() when $default != null:
return $default(_that.network,_that.stackNames);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String network,  List<String> stackNames)  $default,) {final _that = this;
switch (_that) {
case _GlobalNetworkState():
return $default(_that.network,_that.stackNames);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String network,  List<String> stackNames)?  $default,) {final _that = this;
switch (_that) {
case _GlobalNetworkState() when $default != null:
return $default(_that.network,_that.stackNames);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GlobalNetworkState implements GlobalNetworkState {
  const _GlobalNetworkState({required this.network, required final  List<String> stackNames}): _stackNames = stackNames;
  factory _GlobalNetworkState.fromJson(Map<String, dynamic> json) => _$GlobalNetworkStateFromJson(json);

@override final  String network;
 final  List<String> _stackNames;
@override List<String> get stackNames {
  if (_stackNames is EqualUnmodifiableListView) return _stackNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stackNames);
}


/// Create a copy of GlobalNetworkState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GlobalNetworkStateCopyWith<_GlobalNetworkState> get copyWith => __$GlobalNetworkStateCopyWithImpl<_GlobalNetworkState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GlobalNetworkStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GlobalNetworkState&&(identical(other.network, network) || other.network == network)&&const DeepCollectionEquality().equals(other._stackNames, _stackNames));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,network,const DeepCollectionEquality().hash(_stackNames));

@override
String toString() {
  return 'GlobalNetworkState(network: $network, stackNames: $stackNames)';
}


}

/// @nodoc
abstract mixin class _$GlobalNetworkStateCopyWith<$Res> implements $GlobalNetworkStateCopyWith<$Res> {
  factory _$GlobalNetworkStateCopyWith(_GlobalNetworkState value, $Res Function(_GlobalNetworkState) _then) = __$GlobalNetworkStateCopyWithImpl;
@override @useResult
$Res call({
 String network, List<String> stackNames
});




}
/// @nodoc
class __$GlobalNetworkStateCopyWithImpl<$Res>
    implements _$GlobalNetworkStateCopyWith<$Res> {
  __$GlobalNetworkStateCopyWithImpl(this._self, this._then);

  final _GlobalNetworkState _self;
  final $Res Function(_GlobalNetworkState) _then;

/// Create a copy of GlobalNetworkState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? network = null,Object? stackNames = null,}) {
  return _then(_GlobalNetworkState(
network: null == network ? _self.network : network // ignore: cast_nullable_to_non_nullable
as String,stackNames: null == stackNames ? _self._stackNames : stackNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$NetworkState {

 List<PortState> get ports; List<GlobalNetworkState> get globalNetworks; int get serviceCount;
/// Create a copy of NetworkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkStateCopyWith<NetworkState> get copyWith => _$NetworkStateCopyWithImpl<NetworkState>(this as NetworkState, _$identity);

  /// Serializes this NetworkState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkState&&const DeepCollectionEquality().equals(other.ports, ports)&&const DeepCollectionEquality().equals(other.globalNetworks, globalNetworks)&&(identical(other.serviceCount, serviceCount) || other.serviceCount == serviceCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(ports),const DeepCollectionEquality().hash(globalNetworks),serviceCount);

@override
String toString() {
  return 'NetworkState(ports: $ports, globalNetworks: $globalNetworks, serviceCount: $serviceCount)';
}


}

/// @nodoc
abstract mixin class $NetworkStateCopyWith<$Res>  {
  factory $NetworkStateCopyWith(NetworkState value, $Res Function(NetworkState) _then) = _$NetworkStateCopyWithImpl;
@useResult
$Res call({
 List<PortState> ports, List<GlobalNetworkState> globalNetworks, int serviceCount
});




}
/// @nodoc
class _$NetworkStateCopyWithImpl<$Res>
    implements $NetworkStateCopyWith<$Res> {
  _$NetworkStateCopyWithImpl(this._self, this._then);

  final NetworkState _self;
  final $Res Function(NetworkState) _then;

/// Create a copy of NetworkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ports = null,Object? globalNetworks = null,Object? serviceCount = null,}) {
  return _then(_self.copyWith(
ports: null == ports ? _self.ports : ports // ignore: cast_nullable_to_non_nullable
as List<PortState>,globalNetworks: null == globalNetworks ? _self.globalNetworks : globalNetworks // ignore: cast_nullable_to_non_nullable
as List<GlobalNetworkState>,serviceCount: null == serviceCount ? _self.serviceCount : serviceCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NetworkState].
extension NetworkStatePatterns on NetworkState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NetworkState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NetworkState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NetworkState value)  $default,){
final _that = this;
switch (_that) {
case _NetworkState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NetworkState value)?  $default,){
final _that = this;
switch (_that) {
case _NetworkState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PortState> ports,  List<GlobalNetworkState> globalNetworks,  int serviceCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NetworkState() when $default != null:
return $default(_that.ports,_that.globalNetworks,_that.serviceCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PortState> ports,  List<GlobalNetworkState> globalNetworks,  int serviceCount)  $default,) {final _that = this;
switch (_that) {
case _NetworkState():
return $default(_that.ports,_that.globalNetworks,_that.serviceCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PortState> ports,  List<GlobalNetworkState> globalNetworks,  int serviceCount)?  $default,) {final _that = this;
switch (_that) {
case _NetworkState() when $default != null:
return $default(_that.ports,_that.globalNetworks,_that.serviceCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NetworkState implements NetworkState {
  const _NetworkState({required final  List<PortState> ports, required final  List<GlobalNetworkState> globalNetworks, required this.serviceCount}): _ports = ports,_globalNetworks = globalNetworks;
  factory _NetworkState.fromJson(Map<String, dynamic> json) => _$NetworkStateFromJson(json);

 final  List<PortState> _ports;
@override List<PortState> get ports {
  if (_ports is EqualUnmodifiableListView) return _ports;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ports);
}

 final  List<GlobalNetworkState> _globalNetworks;
@override List<GlobalNetworkState> get globalNetworks {
  if (_globalNetworks is EqualUnmodifiableListView) return _globalNetworks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_globalNetworks);
}

@override final  int serviceCount;

/// Create a copy of NetworkState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NetworkStateCopyWith<_NetworkState> get copyWith => __$NetworkStateCopyWithImpl<_NetworkState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NetworkStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NetworkState&&const DeepCollectionEquality().equals(other._ports, _ports)&&const DeepCollectionEquality().equals(other._globalNetworks, _globalNetworks)&&(identical(other.serviceCount, serviceCount) || other.serviceCount == serviceCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_ports),const DeepCollectionEquality().hash(_globalNetworks),serviceCount);

@override
String toString() {
  return 'NetworkState(ports: $ports, globalNetworks: $globalNetworks, serviceCount: $serviceCount)';
}


}

/// @nodoc
abstract mixin class _$NetworkStateCopyWith<$Res> implements $NetworkStateCopyWith<$Res> {
  factory _$NetworkStateCopyWith(_NetworkState value, $Res Function(_NetworkState) _then) = __$NetworkStateCopyWithImpl;
@override @useResult
$Res call({
 List<PortState> ports, List<GlobalNetworkState> globalNetworks, int serviceCount
});




}
/// @nodoc
class __$NetworkStateCopyWithImpl<$Res>
    implements _$NetworkStateCopyWith<$Res> {
  __$NetworkStateCopyWithImpl(this._self, this._then);

  final _NetworkState _self;
  final $Res Function(_NetworkState) _then;

/// Create a copy of NetworkState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ports = null,Object? globalNetworks = null,Object? serviceCount = null,}) {
  return _then(_NetworkState(
ports: null == ports ? _self._ports : ports // ignore: cast_nullable_to_non_nullable
as List<PortState>,globalNetworks: null == globalNetworks ? _self._globalNetworks : globalNetworks // ignore: cast_nullable_to_non_nullable
as List<GlobalNetworkState>,serviceCount: null == serviceCount ? _self.serviceCount : serviceCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
