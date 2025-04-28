import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'websocket_cubit.dart';

class WebSocketBlocPage extends StatelessWidget {
  const WebSocketBlocPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => WebSocketCubit(), child: WebSocketView());
  }
}

class WebSocketView extends StatelessWidget {
  const WebSocketView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WebSocketCubit>();

    return Scaffold(
      appBar: AppBar(title: Text('WebSocket BLoC Example')),
      body: BlocBuilder<WebSocketCubit, WebSocketState>(
        builder: (context, state) {
          String statusText = '';
          String messageText = '';

          if (state is WebSocketConnecting) {
            statusText = 'Connecting...';
          } else if (state is WebSocketDisconnected) {
            statusText = 'Disconnected';
          } else if (state is WebSocketMessageReceived) {
            statusText = 'Connected';
            messageText = state.message;
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Status: $statusText', style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                Expanded(
                  child: Center(
                    child: Text(
                      messageText.isNotEmpty ? 'Message: $messageText' : 'Waiting for messages...',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: cubit.connect, child: Text('Connect')),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: cubit.disconnect,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text('Disconnect'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
