import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  // Singleton pattern
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller = StreamController<bool>.broadcast();
  bool _isConnectedState = true;
  bool _isInitialized = false;

  Stream<bool> get connectivityStream => _controller.stream;
  bool get isConnected => _isConnectedState;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;

    final results = await _connectivity.checkConnectivity();
    _isConnectedState = _hasConnection(results);
    _controller.add(_isConnectedState);

    _connectivity.onConnectivityChanged.listen((results) {
      _isConnectedState = _hasConnection(results);
      _controller.add(_isConnectedState);
    });
  }

  Future<bool> checkCurrentConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _isConnectedState = _hasConnection(results);
    _controller.add(_isConnectedState);
    return _isConnectedState;
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((r) =>
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.ethernet);
  }

  void dispose() {
    _controller.close();
  }
}
