import 'dart:async';
import 'dart:convert';
import 'package:udp/udp.dart';

class DiscoveryService {
  static const int udpPort = 9999;

  static Future<String?> discoverServer() async {
    final receiver = await UDP.bind(Endpoint.any(port: Port(udpPort)));

    print("Listening for discovery packets...");

    final completer = Completer<String?>();

    late StreamSubscription sub;

    sub = receiver.asStream().listen((datagram) {
      if (datagram == null) return;

      try {
        final raw = utf8.decode(datagram.data);
        final jsonData = jsonDecode(raw);

        print("FOUND SERVER:");
        print(jsonData);

        final ip = datagram.address.address;
        final port = jsonData["ws_port"];

        final url = "ws://$ip:$port";

        print("Resolved URL: $url");

        sub.cancel();
        receiver.close();

        if (!completer.isCompleted) {
          completer.complete(url);
        }
      } catch (e) {
        print("Discovery parse error: $e");
      }
    });

    return completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        sub.cancel();
        receiver.close();
        return null;
      },
    );
  }
}
