import 'package:dockge_dashboard/app/services/models/wire_value.dart';

final class AuthResultDto {
  const AuthResultDto({required this.isSuccessful, this.token, this.message});

  factory AuthResultDto.fromResponse(Object? rawResponse) {
    final response = WireObject.parse(rawResponse, context: 'auth response');
    return AuthResultDto(
      isSuccessful: response.value('ok') == true,
      token: switch (response.value('token')) {
        final String token => token,
        _ => null,
      },
      message: switch (response.value('msg')) {
        final String message => message,
        _ => null,
      },
    );
  }

  final bool isSuccessful;
  final String? token;
  final String? message;
}
