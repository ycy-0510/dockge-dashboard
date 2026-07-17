import 'package:dockge_dashboard/app/services/models/wire_value.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_dtos.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StackCatalogDto', () {
    test('converts an agent event to a typed catalog', () {
      final dto = StackCatalogDto.tryParseAgentEvent(<Object?>[
        'stackList',
        <String, Object?>{
          'ok': true,
          'stackList': <String, Object?>{
            'proxy': <String, Object?>{
              'name': 'proxy',
              'status': 3,
              'isManagedByDockge': true,
              'composeFileName': 'compose.yaml',
            },
          },
        },
      ]);

      expect(dto, isNotNull);
      expect(dto!.catalog.isSuccessful, isTrue);
      expect(dto.catalog.stacks, hasLength(1));
      expect(dto.catalog.stacks.single.name, 'proxy');
      expect(dto.catalog.stacks.single.status, StackStatus.active);
    });

    test('ignores unrelated and malformed events', () {
      expect(StackCatalogDto.tryParseAgentEvent('stackList'), isNull);
      expect(
        StackCatalogDto.tryParseAgentEvent(<Object?>['terminalWrite', 'name', 'text']),
        isNull,
      );
    });
  });

  group('StackDocumentDto', () {
    test('rejects a response without a stack object', () {
      expect(
        () => StackDocumentDto.fromResponse(<String, Object?>{'ok': true}),
        throwsA(isA<WireFormatException>()),
      );
    });
  });

  group('TerminalWriteDto', () {
    test('validates event length and value types', () {
      expect(
        TerminalWriteDto.tryParseAgentEvent(<Object?>['terminalWrite']),
        isNull,
      );
      expect(
        TerminalWriteDto.tryParseAgentEvent(<Object?>[
          'terminalWrite',
          'combined--demo',
          'hello',
        ]),
        isNotNull,
      );
    });
  });
}
