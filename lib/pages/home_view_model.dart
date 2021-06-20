import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:collab_draw_app/models/touch_point.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
//https://medium.com/flutter-community/working-with-sockets-in-dart-15b443007bc9
class HomeViewModel {

  Color color;
  List<TouchPoint> _current = [];

  List<List<TouchPoint>> _drawings = [];
  List<List<TouchPoint>> _forwards = [];

  BehaviorSubject<List<List<TouchPoint>>> _subject;
  BehaviorSubject<List<List<TouchPoint>>> _remoteSubject;

  Socket _channel;

  HomeViewModel(this.color){
    _subject = BehaviorSubject.seeded(_drawings);
    _remoteSubject = BehaviorSubject.seeded(null);
    startListening();
  }

  void startListening() async {
    _channel = await connectSocket('echo.websocket.org', 443);
    print('Connected to: ${_channel.remoteAddress.address}:${_channel.remotePort}');
    _channel.listen(
      (Uint8List data) {
        final response = String.fromCharCodes(data);
        print(response);
        // final list = jsonDecode(response) as List<dynamic>;
        // final points = list.map((e) => TouchPoint.fromJson(e)).toList();
      },
      onError: (error) { print(error);_channel.destroy(); },
      onDone: () { print('Server left.'); _channel.destroy(); },
    );
    // // Parsing Uint8List data to a

        
    // _channel.stream.listen((message) {
    //
    //   // TODO Check what is listening
    //   _channel.sink.add('received!');
    //   print(message);
    // });
    // send some messages to the server
    await sendMessage(_channel, 'Knock, knock.');
    await sendMessage(_channel, 'Banana');
    await sendMessage(_channel, 'Banana');
    await sendMessage(_channel, 'Banana');
    await sendMessage(_channel, 'Banana');
    await sendMessage(_channel, 'Banana');
    await sendMessage(_channel, 'Orange');
    await sendMessage(_channel, "Orange you glad I didn't say banana again?");
  }

  Stream get offsets => _subject.stream;
  bool get hasPrevious => _drawings.isNotEmpty;
  bool get hasForwards => _forwards.isNotEmpty;

  var teste = 0;
  void onPanChange(Object details) {
    Offset offset;
    if (details is DragStartDetails)
      offset = details.localPosition;
    if (details is DragUpdateDetails)
      offset = details.localPosition;
    _current.add(TouchPoint(color, offset));
    _subject.add([..._drawings, _current]);
    // TODO Check that it is sending correctly
    teste++;
    String message = 'Hello Moto $teste';
    _channel.write(message);
    // _channel.sink.add([..._drawings, _current]);
  }

  void onPanEnd(DragEndDetails details) {
    _current.add(TouchPoint(color, null));
    _subject.add(_drawings..add(_current));
    _current = [];
    _forwards = [];
  }

  void dispose() {
    _subject.close();
    _channel.close();
    _remoteSubject.close();
  }

  void clear() {
    _drawings = [];
    _subject.add(_drawings);
  }

  void onRevert() {
    if (_drawings.isEmpty) return;
    var last = _drawings.removeLast();
    _forwards.add(last);
    _subject.add(_drawings);
  }

  void onForward() {
    if (_forwards.isEmpty) return;
    var forward = _forwards.removeLast();
    _subject.add(_drawings..add(forward));
  }


  //Extract to socket_helper
  bool badCert(X509Certificate cert) {
    //Do stuff here
    return true;
  }

  Future<Socket> connectSocket(String host, int port) async {
      return SecureSocket.connect(host, port, onBadCertificate: badCert);
  }

  Future<void> sendMessage(Socket socket, String message) async {
    print('Client: $message');
    socket.write(message);
    await Future.delayed(Duration(seconds: 2));
  }

}