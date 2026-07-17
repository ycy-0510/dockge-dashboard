enum StackStatus {
  unknown,
  inactive,
  deploying,
  active,
  exited;

  factory StackStatus.fromWireValue(Object? value) => switch (value) {
    1 => StackStatus.inactive,
    2 => StackStatus.deploying,
    3 => StackStatus.active,
    4 => StackStatus.exited,
    _ => StackStatus.unknown,
  };

  String get label => switch (this) {
    .unknown => 'Unknown',
    .inactive => 'Inactive',
    .deploying => 'Deploying',
    .active => 'Active',
    .exited => 'Exited',
  };
}

class StackSummary {
  const StackSummary({
    required this.name,
    required this.status,
    required this.isManagedByDockge,
    required this.composeFileName,
    this.endpoint,
  });

  final String name;
  final StackStatus status;
  final bool isManagedByDockge;
  final String composeFileName;
  final String? endpoint;
}

class StackCatalog {
  StackCatalog({required this.isSuccessful, required List<StackSummary> stacks})
    : stacks = List.unmodifiable(stacks);

  final bool isSuccessful;
  final List<StackSummary> stacks;

  StackSummary? findByName(String name) {
    for (final stack in stacks) {
      if (stack.name == name) return stack;
    }
    return null;
  }
}
