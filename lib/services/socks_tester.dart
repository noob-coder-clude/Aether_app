import 'dart:async';
import 'dart:io';

class SocksTester {
  static Future<int?> measurePing({String host = '127.0.0.1', int port = 1819}) async {
    final stopwatch = Stopwatch()..start();
    try {
      final socket = await Socket.connect(host, port, timeout: const Duration(seconds: 3));
      stopwatch.stop();
      await socket.close();
      return stopwatch.elapsedMilliseconds;
    } catch (_) {
      return null;
    }
  }
}
