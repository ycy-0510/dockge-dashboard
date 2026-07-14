import 'package:dockge_dashboard/data/models/dockge_dtos.dart';
import 'package:dockge_dashboard/data/parsers/compose_document_parser.dart';
import 'package:dockge_dashboard/data/services/dockge_api_service.dart';
import 'package:dockge_dashboard/domain/models/network_topology.dart';
import 'package:dockge_dashboard/domain/models/operation_result.dart';
import 'package:dockge_dashboard/domain/models/stack_details.dart';
import 'package:dockge_dashboard/domain/models/stack_models.dart';
import 'package:dockge_dashboard/domain/repositories/stack_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dockge_stack_repository.g.dart';

final class DockgeStackRepository implements StackRepository {
  const DockgeStackRepository(this._api);

  final DockgeApiService _api;

  @override
  Stream<StackCatalog> watchCatalog() => _api.agentEvents
      .map(StackCatalogDto.tryParseAgentEvent)
      .where((dto) => dto != null)
      .cast<StackCatalogDto>()
      .map((dto) => dto.catalog);

  @override
  Future<StackDetails> fetchDetails(String stackName) async {
    final statusesFuture = _api.fetchServiceStatuses(stackName);
    final documentFuture = _api.fetchStackDocument(stackName);
    final statuses = await statusesFuture;
    final document = await documentFuture;
    return StackDetails(
      name: stackName,
      services: ComposeDocumentParser.parseServices(
        document.composeYaml,
        statuses,
      ),
      composeFileName: document.composeFileName,
      composeYaml: document.composeYaml,
      composeEnv: document.composeEnv,
    );
  }

  @override
  Future<StackNetworkSnapshot> fetchNetwork(String stackName) async {
    final document = await _api.fetchStackDocument(stackName);
    return ComposeDocumentParser.parseNetwork(
      stackName: stackName,
      composeYaml: document.composeYaml,
    );
  }

  @override
  Future<String> convertDockerRunCommand(String command) async {
    final result = await _api.composerize(command);
    if (!result.isSuccessful) {
      throw StateError(result.message ?? 'Failed to convert command');
    }
    final template = result.composeTemplate;
    if (template == null || template.trim().isEmpty) {
      throw StateError('Server returned an empty compose template');
    }
    return template;
  }

  @override
  Future<OperationResult> performAction({
    required StackAction action,
    required String stackName,
  }) async => (await _api.runStackAction(
    event: switch (action) {
      .update => 'updateStack',
      .restart => 'restartStack',
      .start => 'startStack',
      .stop => 'stopStack',
      .takeDown => 'downStack',
      .delete => 'deleteStack',
    },
    stackName: stackName,
    options: const [],
    timeout: const Duration(minutes: 10),
  )).result;

  @override
  Future<OperationResult> saveStack({
    required String stackName,
    required String composeYaml,
    required String composeEnv,
    required bool isNew,
    required bool deploy,
  }) async => (await _api.runStackAction(
    event: deploy ? 'deployStack' : 'saveStack',
    stackName: stackName,
    options: <Object?>[composeYaml, composeEnv, isNew],
    timeout: const Duration(minutes: 10),
  )).result;
}

@riverpod
StackRepository stackRepository(Ref ref) =>
    DockgeStackRepository(ref.watch(dockgeApiServiceProvider));
