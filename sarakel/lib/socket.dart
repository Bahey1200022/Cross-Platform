// ignore_for_file: library_prefixes

import 'package:socket_io_client/socket_io_client.dart' as IO;

/// Socket service class to establish socket connection
class SocketService {
  static final SocketService _instance = SocketService._internal();
  static SocketService get instance => _instance;

  IO.Socket? socket;

  SocketService._internal();

  void connect(String url, String user) {
    socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {'userId': user}
    });
    socket!.connect();
  }

  void disconnect() {
    socket!.disconnect();
  }
}
