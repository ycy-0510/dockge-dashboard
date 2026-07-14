import 'package:dockge_dashboard/domain/use_cases/docker_port_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DockerPortParser', () {
    test('parses a host and container port', () {
      final mapping = DockerPortParser.parse('8080:80');

      expect(mapping.hostIp, isNull);
      expect(mapping.hostPort, '8080');
      expect(mapping.containerPort, '80');
      expect(mapping.protocol, 'tcp');
    });

    test('parses an IPv6 host and protocol', () {
      final mapping = DockerPortParser.parse('[::1]:5353:53/udp');

      expect(mapping.hostIp, '::1');
      expect(mapping.hostPort, '5353');
      expect(mapping.containerPort, '53');
      expect(mapping.protocol, 'udp');
      expect(mapping.toString(), '[::1]:5353:53/udp');
    });

    test('parses a dynamic published port', () {
      final mapping = DockerPortParser.parse('3000');

      expect(mapping.hostPort, isNull);
      expect(mapping.containerPort, '3000');
    });
  });
}
