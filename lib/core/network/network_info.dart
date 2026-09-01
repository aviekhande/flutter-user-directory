import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstract contract for checking device network connectivity.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Concrete implementation of [NetworkInfo] using [Connectivity].
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}
