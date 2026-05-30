import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'models/deck_button.dart';
import 'services/discovery_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DeckScreen(),
    );
  }
}

class DeckScreen extends StatefulWidget {
  const DeckScreen({super.key});

  @override
  State<DeckScreen> createState() => _DeckScreenState();
}

class _DeckScreenState extends State<DeckScreen> {
  WebSocketChannel? channel;

  bool connected = false;

  String status = "Searching for server...";

  final List<DeckButton> buttons = [
    DeckButton(title: "PLAY", action: "media_play_pause"),

    DeckButton(title: "VOL-", action: "volume_down"),

    DeckButton(title: "VOL+", action: "volume_up"),

    DeckButton(title: "MUTE", action: "discord_mute"),
  ];

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

  void sendAction(String action) {
    if (!connected || channel == null) {
      return;
    }

    final packet = {"action": action};

    channel!.sink.add(jsonEncode(packet));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(backgroundColor: Colors.black, title: Text(status)),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),

          child: GridView.builder(
            itemCount: buttons.length,

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,

              crossAxisSpacing: 12,
              mainAxisSpacing: 12,

              childAspectRatio: 1,
            ),

            itemBuilder: (context, index) {
              final button = buttons[index];

              return ElevatedButton(
                onPressed: connected ? () => sendAction(button.action) : null,

                child: Text(
                  button.title,
                  textAlign: TextAlign.center,

                  style: const TextStyle(fontSize: 20),
                ),
              );
            },
          ),
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
