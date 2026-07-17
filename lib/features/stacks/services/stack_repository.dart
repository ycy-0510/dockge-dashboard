import 'package:dockge_dashboard/features/stacks/models/operation_result.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_details.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_models.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_network_snapshot.dart';

abstract interface class StackRepository {
  Stream<StackCatalog> watchCatalog();

  Future<StackDetails> fetchDetails(String stackName);

  Future<StackNetworkSnapshot> fetchNetwork(String stackName);

  Future<OperationResult> performAction({
    required StackAction action,
    required String stackName,
  });

  Future<OperationResult> saveStack({
    required String stackName,
    required String composeYaml,
    required String composeEnv,
    required bool isNew,
    required bool deploy,
  });
}

enum StackAction { update, restart, start, stop, takeDown, delete }
