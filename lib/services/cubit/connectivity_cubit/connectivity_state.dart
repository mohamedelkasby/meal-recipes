part of 'connectivity_cubit.dart';

sealed class ConnectivityState {}

class ConnectivityInitial extends ConnectivityState {}

class ConnectivityConnected extends ConnectivityState {}

class ConnectivityDisconnected extends ConnectivityState {}
