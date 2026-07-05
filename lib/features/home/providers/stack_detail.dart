import 'dart:convert';
import 'dart:developer';

import 'package:dockge_dashboard/core/network/dockge_client.dart';
import 'package:dockge_dashboard/core/providers/toast_notifier.dart';
import 'package:dockge_dashboard/core/extensions/socket_io_ext.dart';
import 'package:dockge_dashboard/features/auth/providers/auth_controller.dart';
import 'package:dockge_dashboard/features/home/model/stack_detail_info.dart';
import 'package:dockge_dashboard/features/home/model/stack_info.dart';
import 'package:dockge_dashboard/features/home/providers/stack_list.dart';
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

  Future<void> fetch([String? stackName]) async {
    try {
      if (stackName == null) {
        if (state?.name == null) {
          return;
        } else {
          stackName = state!.name;
        }
      }
      final socket = ref.read(dockgeClientProvider).socket;
      if (socket == null) {
        ref.read(toastProvider.notifier).showError(message: 'Not connected to server');
        state = null;
        return;
      }

      // Wait if authentication is in progress (e.g. reconnecting from background)
      while (ref.read(authControllerProvider).loginStatus == LoginStatus.loading) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      if (ref.read(authControllerProvider).loginStatus != LoginStatus.authenticated) {
        ref.read(toastProvider.notifier).showError(message: 'Not authenticated');
        state = null;
        return;
      }

      final statusRes = await socket.emitAgentAsync("", "serviceStatusList", [stackName]);
      if (!ref.mounted) return;
      if (statusRes['ok'] != true) {
        ref.read(toastProvider.notifier).showError(message: 'Failed to get service status');
        state = null;
        return;
      }
      final statuses = Map<String, String>.from(statusRes['serviceStatusList']);

      final stackRes = await socket.emitAgentAsync("", "getStack", [stackName]);
      if (!ref.mounted) return;
      if (stackRes['ok'] != true) {
        ref.read(toastProvider.notifier).showError(message: 'Failed to get stack info');
        state = null;
        return;
      }

      List<ServiceInfo> services = [];
      YamlMap yamlData = loadYaml(stackRes['stack']['composeYAML']);
      YamlMap servicesRaw = yamlData['services'];
      for (final entries in servicesRaw.entries) {
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
      StackItem? info = ref.read(stackListProvider)?.stackList[stackName];
      state = StackDetailInfo(name: stackName, info: info, services: services);
      ref.listen(stackListProvider, (prev, next) {
        state = state?.copyWith(info: next?.stackList[stackName]);
      });
    } catch (error) {
      log(error.toString(), name: 'StackDetail');
      if (!ref.mounted) return;
      ref.read(toastProvider.notifier).showError(message: 'Failed to load stack details');
      state = null;
    }
  }

  void update() async {
    try {
      final socket = ref.read(dockgeClientProvider).socket;
      final result = await socket?.emitAgentAsync(
        "",
        "updateStack",
        [state?.name],
        timeout: const Duration(minutes: 10),
      );
      if (!ref.mounted) return;
      if (result['ok'] == true) {
        ref.read(toastProvider.notifier).showSuccess(message: result['msg'] ?? 'Stack updated!');
      } else {
        ref
            .read(toastProvider.notifier)
            .showError(message: result['msg'] ?? 'Failed to update stack.');
      }
      fetch();
    } catch (error) {
      log(error.toString(), name: 'StackDetail');
      if (!ref.mounted) return;
      ref.read(toastProvider.notifier).showError(message: 'Failed to load stack details');
      state = null;
    }
  }
}

@riverpod
class StackTerminal extends _$StackTerminal {
  @override
  StackTerminalState? build() {
    return null;
  }

  void join(String stackName) async {
    final socket = ref.read(dockgeClientProvider).socket;
    void agentHandler(dynamic data) {
      if (data[0] == 'terminalWrite') {
        if (data[1] == 'combined--$stackName') {
          final text = data[2] as String; // [terminalWrite,terminalName, rawText]
          state?.combinedTerminal.write(text);
        } else if (data[1] == 'compose--$stackName') {
          if (state?.composeTerminal == null) {
            final composeTerminal = Terminal(
              maxLines: 10000,
              onBell: () => HapticFeedback.mediumImpact(),
              onResize: (width, height, pixelWidth, pixelHeight) {
                socket?.emitAgent('', 'terminalResize', ['compose--$stackName', height, width]);
              },
            );
            state = state?.copyWith(composeTerminal: composeTerminal);
          }
          final text = data[2] as String; // [terminalWrite,terminalName, rawText]
          state?.composeTerminal?.write(text);
        }
      }
    }

    ref.onDispose(() {
      socket?.off('agent', agentHandler);
      socket?.emitAgent('', 'leaveCombinedTerminal', [stackName]);
    });
    final combineTerminal = Terminal(
      maxLines: 10000,
      onBell: () => HapticFeedback.mediumImpact(),
      onResize: (width, height, pixelWidth, pixelHeight) {
        socket?.emitAgent('', 'terminalResize', ['combined--$stackName', height, width]);
      },
    );
    state = StackTerminalState(name: stackName, combinedTerminal: combineTerminal);
    try {
      state?.combinedTerminal.write('Terminal connected: $stackName\r\n');
      socket
          ?.emitAgentAsync('', 'terminalJoin', ['compose--$stackName'])
          .then((scrollBackData) {
            log(jsonEncode(scrollBackData), name: 'StackTerminal');
            if (scrollBackData['ok'] == true) {
              state?.combinedTerminal.write(scrollBackData['buffer']);
            }
          })
          .catchError((error) {
            log(error.toString(), name: 'StackTerminal');
            if (!ref.mounted) return;
            ref.read(toastProvider.notifier).showError(message: error.toString());
          });
      socket
          ?.emitAgentAsync('', 'terminalJoin', ['combined--$stackName'])
          .then((scrollBackData) {
            log(jsonEncode(scrollBackData), name: 'StackTerminal');
            if (scrollBackData['ok'] == true) {
              state?.combinedTerminal.write(scrollBackData['buffer']);
            }
          })
          .catchError((error) {
            log(error.toString(), name: 'StackTerminal');
            if (!ref.mounted) return;
            ref.read(toastProvider.notifier).showError(message: error.toString());
          });
      socket?.on('agent', agentHandler);
    } catch (error) {
      log(error.toString(), name: 'StackTerminal');
      if (!ref.mounted) return;
      ref.read(toastProvider.notifier).showError(message: error.toString());
    }
  }

  void closeComposeTerminal() {
    state = state?.copyWith(composeTerminal: null);
  }
}
