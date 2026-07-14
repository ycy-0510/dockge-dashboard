import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_state.freezed.dart';
part 'network_state.g.dart';

@freezed
abstract class PortState with _$PortState {
  const factory PortState({
    int? port,
    required String stackName,
    required String serviceName,
  }) = _PortState;

  factory PortState.fromJson(Map<String, dynamic> json) =>
      _$PortStateFromJson(json);
}

@freezed
abstract class GlobalNetworkState with _$GlobalNetworkState {
  const factory GlobalNetworkState({
    required String network,
    required List<String> stackNames,
  }) = _GlobalNetworkState;

  factory GlobalNetworkState.fromJson(Map<String, dynamic> json) =>
      _$GlobalNetworkStateFromJson(json);
}

@freezed
abstract class NetworkState with _$NetworkState {
  const factory NetworkState({
    required List<PortState> ports,
    required List<GlobalNetworkState> globalNetworks,
    required int serviceCount,
  }) = _NetworkState;

  factory NetworkState.fromJson(Map<String, dynamic> json) =>
      _$NetworkStateFromJson(json);
}
