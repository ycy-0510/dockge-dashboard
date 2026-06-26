import 'dart:convert';
import 'dart:developer';

import 'package:dockge_dashboard/core/network/dockge_client.dart';
import 'package:dockge_dashboard/core/providers/error_notifier.dart';
import 'package:dockge_dashboard/core/extensions/socket_io_ext.dart';
import 'package:dockge_dashboard/features/auth/providers/auth_controller.dart';
import 'package:dockge_dashboard/features/home/model/stack_detail_info.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xterm/xterm.dart';
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

      // Wait if authentication is in progress (e.g. reconnecting from background)
      while (ref.read(authControllerProvider).loginStatus == LoginStatus.loading) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      if (ref.read(authControllerProvider).loginStatus != LoginStatus.authenticated) {
        ref.read(errorProvider.notifier).show('Not authenticated');
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

@riverpod
class StackTerminal extends _$StackTerminal {
  String? stackName;
  @override
  Terminal build() {
    final socket = ref.read(dockgeClientProvider).socket;
    ref.onDispose(() {
      socket?.emitAgent('', 'leaveCombinedTerminal', [stackName]);
    });
    final terminal = Terminal(
      maxLines: 10000,
      onBell: () => HapticFeedback.mediumImpact(),
      onResize: (width, height, pixelWidth, pixelHeight) {
        socket?.emitAgent('', 'terminalResize', ['combined--$stackName', height, width]);
      },
    );
    return terminal;
  }

  void join(String stackName) async {
    this.stackName = stackName;
    try {
      final socket = ref.read(dockgeClientProvider).socket;
      state.write('Terminal connected: $stackName\r\n');
      socket
          ?.emitAgentAsync('', 'terminalJoin', ['compose--$stackName'])
          .then((scrollBackData) {
            log(jsonEncode(scrollBackData), name: 'StackTerminal');
            if (scrollBackData['ok'] == true) {
              state.write(scrollBackData['buffer']);
            }
          })
          .catchError((error) {
            log(error.toString(), name: 'StackTerminal');
            if (!ref.mounted) return;
            ref.read(errorProvider.notifier).show(error.toString());
          });
      socket
          ?.emitAgentAsync('', 'terminalJoin', ['combined--$stackName'])
          .then((scrollBackData) {
            log(jsonEncode(scrollBackData), name: 'StackTerminal');
            if (scrollBackData['ok'] == true) {
              state.write(scrollBackData['buffer']);
            }
          })
          .catchError((error) {
            log(error.toString(), name: 'StackTerminal');
            if (!ref.mounted) return;
            ref.read(errorProvider.notifier).show(error.toString());
          });
      socket?.on('agent', (data) {
        if (data[0] == 'terminalWrite' && data[1].toString().contains(stackName)) {
          final text = data[2] as String; // [terminalWrite,terminalName, rawText]
          state.write(text);
        }
      });
    } catch (error) {
      log(error.toString(), name: 'StackTerminal');
      if (!ref.mounted) return;
      ref.read(errorProvider.notifier).show(error.toString());
    }
  }
}
