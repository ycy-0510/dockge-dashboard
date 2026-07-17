import 'package:dockge_dashboard/features/stacks/services/compose_document_parser.dart';
import 'package:dockge_dashboard/app/services/dockge_api_service.dart';
import 'package:dockge_dashboard/features/stacks/models/operation_result.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_dtos.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_details.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_models.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_network_snapshot.dart';
import 'package:dockge_dashboard/features/stacks/services/stack_repository.dart';
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
    final statusesFuture = _api
        .requestAgent('serviceStatusList', <Object?>[stackName])
        .then(ServiceStatusesDto.fromResponse);
    final documentFuture = _fetchStackDocument(stackName);
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
    final document = await _fetchStackDocument(stackName);
    return ComposeDocumentParser.parseNetwork(
      stackName: stackName,
      composeYaml: document.composeYaml,
    );
  }

  @override
  Future<OperationResult> performAction({
    required StackAction action,
    required String stackName,
  }) async => OperationResultDto.fromResponse(
    await _api.requestAgent(
      switch (action) {
        .update => 'updateStack',
        .restart => 'restartStack',
        .start => 'startStack',
        .stop => 'stopStack',
        .takeDown => 'downStack',
        .delete => 'deleteStack',
      },
      <Object?>[stackName],
      timeout: const Duration(minutes: 10),
    ),
  ).result;

  @override
  Future<OperationResult> saveStack({
    required String stackName,
    required String composeYaml,
    required String composeEnv,
    required bool isNew,
    required bool deploy,
  }) async => OperationResultDto.fromResponse(
    await _api.requestAgent(
      deploy ? 'deployStack' : 'saveStack',
      <Object?>[stackName, composeYaml, composeEnv, isNew],
      timeout: const Duration(minutes: 10),
    ),
  ).result;

  Future<StackDocumentDto> _fetchStackDocument(String stackName) async =>
      StackDocumentDto.fromResponse(
        await _api.requestAgent('getStack', <Object?>[stackName]),
      );
}

@riverpod
StackRepository stackRepository(Ref ref) =>
    DockgeStackRepository(ref.watch(dockgeApiServiceProvider));
