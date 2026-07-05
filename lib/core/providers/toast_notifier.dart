import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'toast_notifier.g.dart';

class ToastMsg {
  final String title;
  final String message;
  final IconData icon;
  ToastMsg({required this.title, required this.message, required this.icon});
}

@Riverpod(keepAlive: true)
class ToastNotifier extends _$ToastNotifier {
  @override
  ToastMsg? build() => null;

  void showError({String title = 'Error', required String message}) {
    state = ToastMsg(title: title, message: message, icon: FLucideIcons.circleX);
  }

  void showWarning({String title = 'Warning', required String message}) {
    state = ToastMsg(title: title, message: message, icon: FLucideIcons.triangleAlert);
  }

  void showInfo({String title = 'Notice', required String message}) {
    state = ToastMsg(title: title, message: message, icon: FLucideIcons.circleHelp);
  }

  void showSuccess({String title = 'Success', required String message}) {
    state = ToastMsg(title: title, message: message, icon: FLucideIcons.circleCheckBig);
  }
}
