import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstract contract
abstract class INetworkInfo {
  Future<bool> get isConnected;
}

/// Implementation
class NetworkInfo implements INetworkInfo {
  final Connectivity connectivity;

  NetworkInfo(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();

    // ignore: unrelated_type_equality_checks
    if (result == ConnectivityResult.none) {
      return false;
    }

    return true;
  }
}
