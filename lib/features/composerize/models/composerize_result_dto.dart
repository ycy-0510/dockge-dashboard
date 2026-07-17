import 'package:dockge_dashboard/app/services/models/wire_value.dart';

final class ComposerizeResultDto {
  const ComposerizeResultDto({
    required this.isSuccessful,
    this.composeTemplate,
    this.message,
  });

  factory ComposerizeResultDto.fromResponse(Object? rawResponse) {
    final response = WireObject.parse(
      rawResponse,
      context: 'composerize response',
    );
    return ComposerizeResultDto(
      isSuccessful: response.value('ok') == true,
      composeTemplate: switch (response.value('composeTemplate')) {
        final String template => template,
        _ => null,
      },
      message: switch (response.value('msg')) {
        final String message => message,
        _ => null,
      },
    );
  }

  final bool isSuccessful;
  final String? composeTemplate;
  final String? message;
}
