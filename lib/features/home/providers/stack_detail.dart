import 'dart:convert';
import 'dart:developer';

import 'package:dockge_dashboard/core/network/dockge_client.dart';
import 'package:dockge_dashboard/core/providers/error_notifier.dart';
import 'package:dockge_dashboard/core/extensions/socket_io_ext.dart';
import 'package:dockge_dashboard/features/home/model/stack_detail_info.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaml/yaml.dart';

part 'stack_detail.g.dart';

@riverpod
class StackDetail extends _$StackDetail {
  @override
  StackDetailInfo? build() {
    return null;
  }

  Future<void> fetch(String stackName) async {
    try {
      final socket = ref.read(dockgeClientProvider).socket;
      if (socket == null) {
        ref.read(errorProvider.notifier).show('Not connected to server');
        state = null;
        return;
      }

      final statusRes = await socket.emitAgentAsync("", "serviceStatusList", [stackName]);
      if (!ref.mounted) return;
      if (statusRes['ok'] != true) {
        ref.read(errorProvider.notifier).show('Failed to get service status');
        state = null;
        return;
      }
      final statuses = Map<String, String>.from(statusRes['serviceStatusList']);

      final stackRes = await socket.emitAgentAsync("", "getStack", [stackName]);
      if (!ref.mounted) return;
      if (stackRes['ok'] != true) {
        ref.read(errorProvider.notifier).show('Failed to get stack info');
        state = null;
        return;
      }

      List<ServiceInfo> services = [];
      YamlMap yamlData = loadYaml(stackRes['stack']['composeYAML']);
      log(jsonEncode(yamlData['services']), name: 'debug');
      log((yamlData['services']).runtimeType.toString(), name: 'debug');
      YamlMap servicesRaw = yamlData['services'];
      for (final entries in servicesRaw.entries) {
        log(entries.value['ports'].runtimeType.toString(), name: 'debug');
        services.add(
          ServiceInfo(
            name: entries.key,
            imageName: entries.value['image'],
            status: statuses[entries.key].toString(),
            ports: entries.value['ports'] == null
                ? []
                : List<String>.from(
                    entries.value['ports'],
                  ).map((portRaw) => PortMapping.parsePortSpec(portRaw)).toList(),
          ),
        );
      }
      state = StackDetailInfo(name: stackName, services: services);
    } catch (error) {
      log(error.toString(), name: 'StackDetail');
      if (!ref.mounted) return;
      ref.read(errorProvider.notifier).show('Failed to load stack details');
      state = null;
    }
  }
}
