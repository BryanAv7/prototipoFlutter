import 'dart:io';
import 'dart:convert';

class ServerDiscoveryService {
  RawDatagramSocket? _socket;
  bool _isDiscovering = false;

  bool get isDiscovering => _isDiscovering;

  Future<void> startDiscovery({
    required void Function(String ip, int port) onServerFound,
  }) async {
    if (_isDiscovering) return;

    _isDiscovering = true;

    _socket = await RawDatagramSocket.bind(
      InternetAddress('0.0.0.0'),
      54545,
      reuseAddress: true,
      reusePort: false,
    );

    _socket!.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = _socket!.receive();
        if (datagram == null) return;

        try {
          final message = utf8.decode(datagram.data);
          final data = jsonDecode(message);

          if (data['service'] == 'MiBackendApp') {
            final ip = data['ip'];
            final port = data['port'];

            stopDiscovery();
            onServerFound(ip, port);
          }
        } catch (_) {
          // ignorar paquetes inválidos
        }
      }
    });
  }

  void stopDiscovery() {
    _isDiscovering = false;
    _socket?.close();
    _socket = null;
  }
}
