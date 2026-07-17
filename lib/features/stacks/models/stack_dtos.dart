import 'package:dockge_dashboard/app/services/models/wire_value.dart';
import 'package:dockge_dashboard/features/stacks/models/operation_result.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_models.dart';

final class StackCatalogDto {
  const StackCatalogDto(this.catalog);

  final StackCatalog catalog;

  static StackCatalogDto? tryParseAgentEvent(Object? event) {
    if (event is! List<Object?>) return null;
    for (final value in event) {
      final response = WireObject.tryParse(value);
      if (response == null || !response.contains('stackList')) continue;
      return StackCatalogDto(_parseCatalog(response));
    }
    return null;
  }

  static StackCatalog _parseCatalog(WireObject response) {
    final stackList = response.requireObject('stackList');
    final stacks = <StackSummary>[];
    for (final (name, value) in stackList.objectEntries) {
      stacks.add(
        StackSummary(
          name: value.stringOr('name', name),
          status: StackStatus.fromWireValue(value.value('status')),
          isManagedByDockge: value.value('isManagedByDockge') == true,
          composeFileName: value.stringOr('composeFileName', 'compose.yaml'),
          endpoint: switch (value.value('endpoint')) {
            final String endpoint => endpoint,
            _ => null,
          },
        ),
      );
    }
    stacks.sort((left, right) => left.name.compareTo(right.name));
    return StackCatalog(
      isSuccessful: response.value('ok') == true,
      stacks: stacks,
    );
  }
}

final class StackDocumentDto {
  const StackDocumentDto({
    required this.composeFileName,
    required this.composeYaml,
    required this.composeEnv,
  });

  factory StackDocumentDto.fromResponse(Object? rawResponse) {
    final response = WireObject.parse(
      rawResponse,
      context: 'getStack response',
    );
    if (response.value('ok') != true) {
      throw const WireFormatException('getStack request was not successful');
    }
    final stack = response.requireObject('stack');
    return StackDocumentDto(
      composeFileName: stack.stringOr('composeFileName', 'compose.yaml'),
      composeYaml: stack.requireString('composeYAML'),
      composeEnv: stack.stringOr('composeENV', ''),
    );
  }

  final String composeFileName;
  final String composeYaml;
  final String composeEnv;
}

final class ServiceStatusesDto {
  ServiceStatusesDto._(this._statuses);

  factory ServiceStatusesDto.fromResponse(Object? rawResponse) {
    final response = WireObject.parse(
      rawResponse,
      context: 'serviceStatusList response',
    );
    if (response.value('ok') != true) {
      throw const WireFormatException(
        'serviceStatusList request was not successful',
      );
    }
    final statusObject = response.requireObject('serviceStatusList');
    return ServiceStatusesDto._([
      for (final (name, value) in statusObject.entries)
        (name: name, status: value?.toString() ?? 'unknown'),
    ]);
  }

  final List<({String name, String status})> _statuses;

  String statusFor(String serviceName) {
    for (final entry in _statuses) {
      if (entry.name == serviceName) return entry.status;
    }
    return 'unknown';
  }
}

final class OperationResultDto {
  const OperationResultDto(this.result);

  factory OperationResultDto.fromResponse(Object? rawResponse) {
    final response = WireObject.parse(
      rawResponse,
      context: 'operation response',
    );
    return OperationResultDto(
      OperationResult(
        isSuccessful: response.value('ok') == true,
        message: switch (response.value('msg')) {
          final String message => message,
          _ => null,
        },
      ),
    );
  }

  final OperationResult result;
}

final class TerminalWriteDto {
  const TerminalWriteDto({required this.terminalName, required this.text});

  static TerminalWriteDto? tryParseAgentEvent(Object? event) {
    if (event is! List<Object?> || event.length < 3) return null;
    if (event[0] != 'terminalWrite') return null;
    final terminalName = event[1];
    final text = event[2];
    if (terminalName is! String || text is! String) return null;
    return TerminalWriteDto(terminalName: terminalName, text: text);
  }

  final String terminalName;
  final String text;
}

final class TerminalJoinResultDto {
  const TerminalJoinResultDto({
    required this.isSuccessful,
    required this.buffer,
  });

  factory TerminalJoinResultDto.fromResponse(Object? rawResponse) {
    final response = WireObject.parse(
      rawResponse,
      context: 'terminalJoin response',
    );
    return TerminalJoinResultDto(
      isSuccessful: response.value('ok') == true,
      buffer: response.stringOr('buffer', ''),
    );
  }

  final bool isSuccessful;
  final String buffer;
}
