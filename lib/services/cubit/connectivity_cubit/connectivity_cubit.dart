import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';

part 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _subscription;

  ConnectivityCubit() : super(ConnectivityInitial()) {
    _setupNetworkListener();
  }

  void _setupNetworkListener() {
    // Initial check
    _checkInternetConnection();

    // Listen for network state changes
    _subscription = _connectivity.onConnectivityChanged.listen((result) async {
      // Only check if there's some form of connection
      if (result != ConnectivityResult.none) {
        await _checkInternetConnection();
      } else {
        emit(ConnectivityDisconnected());
      }
    });
  }

  Future<void> _checkInternetConnection() async {
    try {
      // Use both DNS lookup and timeout for robust checking
      final response = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 3));

      if (response.isNotEmpty && response[0].rawAddress.isNotEmpty) {
        emit(ConnectivityConnected());
      } else {
        emit(ConnectivityDisconnected());
      }
    } on SocketException catch (_) {
      emit(ConnectivityDisconnected());
    } on TimeoutException catch (_) {
      emit(ConnectivityDisconnected());
    } catch (_) {
      emit(ConnectivityDisconnected());
    }
  }

  // Manual refresh method
  Future<void> checkConnectivity() async {
    await _checkInternetConnection();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
