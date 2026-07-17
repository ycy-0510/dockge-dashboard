import 'package:dockge_dashboard/features/stacks/models/stack_dtos.dart';
import 'package:dockge_dashboard/features/stacks/services/compose_document_parser.dart';
import 'package:flutter_test/flutter_test.dart';

const _composeYaml = '''
services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
      - target: 443
        published: 8443
        protocol: tcp
    networks:
      - shared
  metrics:
    image: prom/prometheus
    network_mode: host
networks:
  shared:
    external: true
    name: public-edge
''';

void main() {
  final statuses = ServiceStatusesDto.fromResponse(<String, Object?>{
    'ok': true,
    'serviceStatusList': <String, Object?>{
      'web': 'running',
      'metrics': 'exited',
    },
  });

  group('ComposeDocumentParser.parseServices', () {
    test('creates typed services from short and long port syntax', () {
      final services = ComposeDocumentParser.parseServices(_composeYaml, statuses);

      expect(services, hasLength(2));
      final web = services.firstWhere((service) => service.name == 'web');
      expect(web.imageName, 'nginx:latest');
      expect(web.status, 'running');
      expect(web.ports, hasLength(2));
      expect(web.ports[0].hostPort, '8080');
      expect(web.ports[1].hostPort, '8443');
    });
  });

  group('ComposeDocumentParser.parseNetwork', () {
    test('extracts published ports and external network membership', () {
      final network = ComposeDocumentParser.parseNetwork(
        stackName: 'demo',
        composeYaml: _composeYaml,
      );

      expect(network.serviceCount, 2);
      expect(network.ports.map((port) => port.port), containsAll(<int>[8080, 8443]));
      expect(network.externalNetworkNames, <String>['public-edge']);
      expect(network.hostNetworkServices, <String>['metrics']);
    });

    test('rejects a document without services', () {
      expect(
        () => ComposeDocumentParser.parseNetwork(
          stackName: 'demo',
          composeYaml: 'name: demo',
        ),
        returnsNormally,
      );
    });
  });
}
