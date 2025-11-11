import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkStatusNotifier extends ChangeNotifier {
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  NetworkStatusNotifier() {
    Connectivity().onConnectivityChanged.listen((result) {
      bool newStatus =
          result.isNotEmpty &&
          (result.contains(ConnectivityResult.mobile) ||
              result.contains(ConnectivityResult.wifi) ||
              result.contains(ConnectivityResult.ethernet) ||
              result.contains(ConnectivityResult.other));

      if (newStatus != _isOnline) {
        _isOnline = newStatus;
        notifyListeners();
      }
    });
  }
}
