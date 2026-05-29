import 'dart:async';
import 'dart:convert';

import 'package:udp/udp.dart';

class DiscoveryService {
  static Future<String?> discoverServer() async {
    final receiver = await UDP.bind(Endpoint.any(port: Port(9999)));

    print("Listening for discovery packets...");

    try {
      final datagram = await receiver
          .asStream()
          .timeout(const Duration(seconds: 10))
          .first;

      final data = utf8.decode(datagram!.data);

      final json = jsonDecode(data);

      print("FOUND SERVER:");
      print(json);

      final ip = datagram.address.address;

      final port = json["ws_port"];

      receiver.close();

      return "ws://$ip:$port";
    } on TimeoutException {
      receiver.close();

      return null;
    }
  }
}
