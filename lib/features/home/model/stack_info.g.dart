// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stack_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StackItem _$StackItemFromJson(Map<String, dynamic> json) => _StackItem(
  name: json['name'] as String,
  status: $enumDecode(_$StackStatusEnumMap, json['status']),
  isManagedByDockge: json['isManagedByDockge'] as bool,
  composeFileName: json['composeFileName'] as String,
  endpoint: json['endpoint'] as String?,
);

Map<String, dynamic> _$StackItemToJson(_StackItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'status': _$StackStatusEnumMap[instance.status]!,
      'isManagedByDockge': instance.isManagedByDockge,
      'composeFileName': instance.composeFileName,
      'endpoint': instance.endpoint,
    };

const _$StackStatusEnumMap = {
  StackStatus.unknown: 0,
  StackStatus.inactive: 1,
  StackStatus.paused: 2,
  StackStatus.active: 3,
  StackStatus.exited: 4,
};

_StackInfo _$StackInfoFromJson(Map<String, dynamic> json) => _StackInfo(
  ok: json['ok'] as bool,
  stackList: (json['stackList'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, StackItem.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$StackInfoToJson(_StackInfo instance) =>
    <String, dynamic>{'ok': instance.ok, 'stackList': instance.stackList};
