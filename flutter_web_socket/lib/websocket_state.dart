part of 'websocket_cubit.dart';

abstract class WebSocketState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WebSocketConnecting extends WebSocketState {}

class WebSocketConnected extends WebSocketState {}

class WebSocketDisconnected extends WebSocketState {}

class WebSocketMessageReceived extends WebSocketState {
  final String message;

  WebSocketMessageReceived(this.message);

  @override
  List<Object?> get props => [message];
}
