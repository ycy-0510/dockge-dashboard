import 'package:freezed_annotation/freezed_annotation.dart';

part 'stack_info.freezed.dart';
part 'stack_info.g.dart';

enum StackStatus {
  @JsonValue(0)
  unknown,
  @JsonValue(1)
  inactive,
  @JsonValue(2)
  paused,
  @JsonValue(3)
  active,
  @JsonValue(4)
  exited;

  String get label => switch (this) {
    .unknown => 'Unknown',
    .inactive => 'Inactive',
    .paused => 'Paused',
    .active => 'Active',
    .exited => 'Exited',
  };
}

@freezed
abstract class StackItem with _$StackItem {
  const factory StackItem({
    required String name,
    required StackStatus status,
    required bool isManagedByDockge,
    required String composeFileName,
    String? endpoint,
  }) = _StackItem;

  factory StackItem.fromJson(Map<String, dynamic> json) => _$StackItemFromJson(json);
}

@freezed
abstract class StackInfo with _$StackInfo {
  const factory StackInfo({required bool ok, required Map<String, StackItem> stackList}) =
      _StackInfo;

  factory StackInfo.fromJson(Map<String, dynamic> json) => _$StackInfoFromJson(json);
}
