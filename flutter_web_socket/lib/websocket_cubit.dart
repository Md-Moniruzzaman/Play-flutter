import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:equatable/equatable.dart';

part 'websocket_state.dart';

class WebSocketCubit extends Cubit<WebSocketState> {
  WebSocketCubit() : super(WebSocketDisconnected());

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _reconnectTimer;

  final String _url = 'ws://10.168.115.14:4005/ws'; // Your server

  void connect() {
    if (_channel != null) return; // Already connected or connecting

    emit(WebSocketConnecting());

    try {
      _channel = WebSocketChannel.connect(Uri.parse(_url));
      _subscription = _channel!.stream.listen(
        (data) {
          emit(WebSocketMessageReceived(data.toString()));
        },
        onDone: () {
          _handleDisconnect();
        },
        onError: (error) {
          _handleDisconnect();
        },
      );
    } catch (e) {
      _handleDisconnect();
    }
  }

  void _handleDisconnect() {
    disconnect();
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: 5), () {
      connect();
    });
  }

  void disconnect() {
    _subscription?.cancel();
    _subscription = null;

    _channel?.sink.close();
    _channel = null;

    emit(WebSocketDisconnected());
  }

  void sendMessage(String message) {
    if (_channel != null) {
      _channel!.sink.add(message);
    }
  }

  @override
  Future<void> close() {
    _reconnectTimer?.cancel();
    disconnect();
    return super.close();
  }
}
