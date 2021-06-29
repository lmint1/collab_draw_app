import 'package:collab_draw_app/models/touch_point.dart';
import 'package:collab_draw_app/utils/web_socket_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class HomeViewModel with WebSocketDelegate {
  Color color;
  List<TouchPoint> _current = [];

  List<List<TouchPoint>> _drawings = [];
  List<List<TouchPoint>> _forwards = [];

  BehaviorSubject<List<List<TouchPoint>>> _subject;
  BehaviorSubject<List<List<TouchPoint>>> _remoteSubject;

  WebSocketHelper _socket;

  TouchPoint get pointSeparator => TouchPoint(color, null);

  HomeViewModel(this.color) {
    _subject = BehaviorSubject.seeded(_drawings);
    _remoteSubject = BehaviorSubject.seeded([]);
    _socket = WebSocketHelper("wss://192.168.1.4", this);
  }

  Stream<List<List<TouchPoint>>> get offsets => CombineLatestStream.combine2(
      _subject, _remoteSubject,
      // Combines A and B in a single Stream of List<List<TouchPoint>>
      (a, b) => [...a, [pointSeparator], ...b, [pointSeparator]]
  );

  bool get hasPrevious => _drawings.isNotEmpty;
  bool get hasForwards => _forwards.isNotEmpty;

  void onPanChange(Object details) {
    Offset offset;
    if (details is DragStartDetails)
      offset = details.localPosition;
    if (details is DragUpdateDetails)
      offset = details.localPosition;
    _current.add(TouchPoint(color, offset));

    final currentDraw = [..._drawings, _current];
    _subject.add(currentDraw);
    _socket.add(currentDraw);
  }

  @override
  void onData(List<List<TouchPoint>> data) {
    _remoteSubject.add(data);
  }

  void onPanEnd(DragEndDetails details) {
    _current.add(TouchPoint(color, null));
    _subject.add(_drawings..add(_current));
    _current = [];
    _forwards = [];
  }

  void dispose() {
    _subject.close();
    _socket.dispose();
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