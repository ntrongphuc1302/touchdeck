import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'services/discovery_service.dart';

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
  const DeckScreen({super.key});

  @override
  State<DeckScreen> createState() => _DeckScreenState();
}

class _DeckScreenState extends State<DeckScreen> {
  WebSocketChannel? channel;

  String status = "Searching for server...";

  bool connected = false;

  @override
  void initState() {
    super.initState();

    connectToServer();
  }

  Future<void> connectToServer() async {
    final wsUrl = await DiscoveryService.discoverServer();

    if (wsUrl == null) {
      setState(() {
        status = "No server found";
      });

      return;
    }

    setState(() {
      status = "Connecting...";
    });

    try {
      channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      setState(() {
        connected = true;
        status = "Connected";
      });

      print("Connected to: $wsUrl");
    } catch (e) {
      setState(() {
        status = "Connection failed";
      });

      print(e);
    }
  }

  void sendPlayPause() {
    if (!connected || channel == null) {
      return;
    }

    final packet = {"action": "media_play_pause"};

    channel!.sink.add(jsonEncode(packet));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text(
              status,
              style: const TextStyle(color: Colors.white, fontSize: 22),
            ),

            const SizedBox(height: 40),

            Center(
              child: SizedBox(
                width: 220,
                height: 220,

                child: ElevatedButton(
                  onPressed: connected ? sendPlayPause : null,

                  child: const Text("PLAY", style: TextStyle(fontSize: 32)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    channel?.sink.close();

    super.dispose();
  }
}
