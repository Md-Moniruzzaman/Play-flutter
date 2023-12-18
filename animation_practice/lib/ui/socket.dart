import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class Socket extends StatefulWidget {
  const Socket({super.key});

  @override
  State<Socket> createState() => _SocketState();
}

class _SocketState extends State<Socket> {
  final TextEditingController messageController = TextEditingController();
  final myChannel =
      IOWebSocketChannel.connect(Uri.parse('wss://echo.websocket.events'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Socket Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Input Message'),
            Form(
              child: TextFormField(
                controller: messageController,
                decoration: const InputDecoration(hintText: 'Send Message'),
              ),
            ),
            const SizedBox(height: 20),
            StreamBuilder(
                stream: myChannel.stream,
                builder: (context, snapshot) {
                  return Text(snapshot.hasData ? snapshot.data : '');
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: sendMessage,
        tooltip: 'Send Message',
        child: const Icon(Icons.send),
      ),
    );
  }

// Sending message
  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      myChannel.sink.add(messageController.text);
    }
  }

  //Close the connection
  @override
  void dispose() {
    myChannel.sink.close(status.goingAway);
    messageController.dispose();
    super.dispose();
  }
}
