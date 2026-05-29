import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: DeckScreen());
  }
}

class DeckScreen extends StatefulWidget {
  @override
  State<DeckScreen> createState() => _DeckScreenState();
}

class _DeckScreenState extends State<DeckScreen> {
  late WebSocketChannel channel;

  @override
  void initState() {
    super.initState();

    channel = WebSocketChannel.connect(Uri.parse("ws://192.168.0.73:8765"));
  }

  void sendPlayPause() {
    final packet = {"action": "media_play_pause"};

    channel.sink.add(jsonEncode(packet));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Center(
        child: SizedBox(
          width: 220,
          height: 220,

          child: ElevatedButton(
            onPressed: sendPlayPause,

            child: const Text("PLAY", style: TextStyle(fontSize: 32)),
          ),
        ),
      ),
    );
  }
}
