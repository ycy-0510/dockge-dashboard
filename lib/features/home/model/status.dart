import 'package:freezed_annotation/freezed_annotation.dart';

enum StackStatus {
  @JsonValue(0)
  unknown,
  @JsonValue(1)
  inactive,
  @JsonValue(2)
  deploying,
  @JsonValue(3)
  active,
  @JsonValue(4)
  exited;

  String get label => switch (this) {
    .unknown => 'Unknown',
    .inactive => 'Inactive',
    .deploying => 'Deploying',
    .active => 'Active',
    .exited => 'Exited',
  };
}
