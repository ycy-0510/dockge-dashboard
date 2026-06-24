import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'error_notifier.g.dart';

class AppError {
  final String message;
  AppError(this.message);
}

@Riverpod(keepAlive: true)
class ErrorNotifier extends _$ErrorNotifier {
  @override
  AppError? build() => null;

  void show(String message) {
    state = AppError(message);
  }
}
