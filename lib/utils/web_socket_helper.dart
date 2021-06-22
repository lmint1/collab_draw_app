import 'dart:convert';
import 'dart:io';
import 'package:collab_draw_app/models/touch_point.dart';

class WebSocketHelper {
  WebSocket _socket;
  WebSocketDelegate delegate;
  WebSocketHelper(String uri, this.delegate) { _startListening(uri); }

  void _startListening(String uri) async {
    _socket = await WebSocket.connect(uri);
    _socket.listen(
      onData,
      onError: (error) => print('Error: $error'),
      onDone: () => print("Done"),
    );
  }

  void onData(dynamic event) {
    final data = (jsonDecode(event) as List<dynamic>)
        .map((d) {
          return (d as List<dynamic>)
              .map((e) => TouchPoint.fromJson(e as Map<String, dynamic>))
              .toList();
        })
        .toList();
    delegate.onData(data);
  }

  void add(List<List<TouchPoint>> data) => _socket.add(jsonEncode(data));
  void dispose() => _socket.close();
}

abstract class WebSocketDelegate {
  void onData(List<List<TouchPoint>> data);
}
