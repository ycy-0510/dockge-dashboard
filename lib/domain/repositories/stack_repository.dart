import 'package:dockge_dashboard/domain/models/operation_result.dart';
import 'package:dockge_dashboard/domain/models/network_topology.dart';
import 'package:dockge_dashboard/domain/models/stack_details.dart';
import 'package:dockge_dashboard/domain/models/stack_models.dart';

abstract interface class StackRepository {
  Stream<StackCatalog> watchCatalog();

  Future<StackDetails> fetchDetails(String stackName);

  Future<StackNetworkSnapshot> fetchNetwork(String stackName);

  Future<String> convertDockerRunCommand(String command);

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
