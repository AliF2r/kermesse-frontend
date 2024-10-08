import 'package:kermesse_frontend/api/api_constants.dart';
import 'package:kermesse_frontend/services/notification_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();

  factory WebSocketService() {
    return _instance;
  }

  WebSocketService._internal();

  WebSocketChannel? _channel;

  void connectWebSocket(int organizerId) {
    final url = 'ws://${ApiConstants.apiBaseUrl}/ws?organizerId=$organizerId';
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      print('WebSocket connection established');
      _channel!.stream.listen(
            (message) {
          print('Received from server: $message');
          NotificationService.showNotification(
            title: 'One Ticket Sold',
            body: message,
          );
        },
        onDone: () {
          print('WebSocket connection closed');
          _reconnectWebSocket(organizerId);
        },
        onError: (error) {
          print('WebSocket error: ${error.toString()}');
        },
        cancelOnError: true,
      );
    } catch (e) {
      print('Failed to connect to WebSocket: ${e.toString()}');
    }
  }

  void disconnectWebSocket() {
    if (_channel != null) {
      _channel?.sink.close();
      print('WebSocket connection closed manually');
    }
  }

  void _reconnectWebSocket(int organizerId) {
    print('Attempting to reconnect to WebSocket...');
    connectWebSocket(organizerId);
  }
}
