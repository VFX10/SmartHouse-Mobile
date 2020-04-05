import 'package:connectivity/connectivity.dart';

enum ResultState {
  successful,
  error,
  loading
}
typedef OnResult = void Function(dynamic, ResultState);
typedef OnConnectivityChanged = Future<void> Function(ConnectivityResult result);