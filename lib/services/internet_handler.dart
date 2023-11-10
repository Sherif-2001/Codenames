import 'package:connectivity_plus/connectivity_plus.dart';

class InterntHandler {
  List<ConnectivityResult> neededConnections = [
    ConnectivityResult.mobile,
    ConnectivityResult.wifi
  ];

  /// Check if the device is connected to a wifi or mobile data
  Future<bool> checkConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return (neededConnections.contains(connectivityResult));
  }
}
