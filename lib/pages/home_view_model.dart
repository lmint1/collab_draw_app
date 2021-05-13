import 'package:collab_draw_app/models/touch_point.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:web_socket_channel/io.dart';

class HomeViewModel {

  Color color;
  List<TouchPoint> _current = [];

  List<List<TouchPoint>> _drawings = [];
  List<List<TouchPoint>> _forwards = [];

  BehaviorSubject<List<List<TouchPoint>>> _subject;
  BehaviorSubject<List<List<TouchPoint>>> _remoteSubject;

  IOWebSocketChannel _channel;

  HomeViewModel(this.color){
    _subject = BehaviorSubject.seeded(_drawings);
    _remoteSubject = BehaviorSubject.seeded(null);
    _channel = IOWebSocketChannel.connect(Uri.parse('ws://localhost:1234'));
    startListening();
  }

  void startListening() {
    _channel.stream.listen((message) {
      // TODO Check what is listening
      print(message);
    });
  }

  Stream get offsets => _subject.stream;
  bool get hasPrevious => _drawings.isNotEmpty;
  bool get hasForwards => _forwards.isNotEmpty;

  void onPanChange(Object details) {
    Offset offset;
    if (details is DragStartDetails)
      offset = details.localPosition;
    if (details is DragUpdateDetails)
      offset = details.localPosition;
    _current.add(TouchPoint(color, offset));
    _subject.add([..._drawings, _current]);
    // TODO Check that it is sending correctly
    _channel.sink.add([..._drawings, _current]);
  }

  void onPanEnd(DragEndDetails details) {
    _current.add(TouchPoint(color, null));
    _subject.add(_drawings..add(_current));
    _current = [];
    _forwards = [];
  }

  void dispose() {
    _subject.close();
    _channel.sink.close();
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
}