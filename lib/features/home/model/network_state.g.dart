// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PortState _$PortStateFromJson(Map<String, dynamic> json) => _PortState(
  port: (json['port'] as num?)?.toInt(),
  stackName: json['stackName'] as String,
  serviceName: json['serviceName'] as String,
);

Map<String, dynamic> _$PortStateToJson(_PortState instance) =>
    <String, dynamic>{
      'port': instance.port,
      'stackName': instance.stackName,
      'serviceName': instance.serviceName,
    };

_GlobalNetworkState _$GlobalNetworkStateFromJson(Map<String, dynamic> json) =>
    _GlobalNetworkState(
      network: json['network'] as String,
      stackNames: (json['stackNames'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$GlobalNetworkStateToJson(_GlobalNetworkState instance) =>
    <String, dynamic>{
      'network': instance.network,
      'stackNames': instance.stackNames,
    };

_NetworkState _$NetworkStateFromJson(Map<String, dynamic> json) =>
    _NetworkState(
      ports: (json['ports'] as List<dynamic>)
          .map((e) => PortState.fromJson(e as Map<String, dynamic>))
          .toList(),
      globalNetworks: (json['globalNetworks'] as List<dynamic>)
          .map((e) => GlobalNetworkState.fromJson(e as Map<String, dynamic>))
          .toList(),
      serviceCount: (json['serviceCount'] as num).toInt(),
    );

Map<String, dynamic> _$NetworkStateToJson(_NetworkState instance) =>
    <String, dynamic>{
      'ports': instance.ports,
      'globalNetworks': instance.globalNetworks,
      'serviceCount': instance.serviceCount,
    };
