import 'package:collab_draw_app/models/touch_point.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:rxdart/rxdart.dart';

class HomeViewModel {

  final Color color;
  List<TouchPoint> _current = [];

  List<List<TouchPoint>> _drawings = [];
  List<List<TouchPoint>> _forwards = [];

  BehaviorSubject<List<List<TouchPoint>>> _subject;

  HomeViewModel(this.color){
    _subject = BehaviorSubject.seeded(_drawings);
  }

  Stream get offsets => _subject.stream;

  void onPanChange(Object details) {
    Offset offset;
    if (details is DragStartDetails)
      offset = details.localPosition;
    if (details is DragUpdateDetails)
      offset = details.localPosition;
    _current.add(TouchPoint(color, offset));
    _subject.add([..._drawings, _current]);
  }

  void onPanEnd(DragEndDetails details) {
    _subject.add(_drawings..add(_current..add(TouchPoint(null, null))));
    _current = [];
    _forwards = [];
  }

  void dispose() => _subject.close();

  void clear() {
    _drawings = [];
    _subject.add(_drawings);
  }

  onRevert() {
    // if (_drawings.isEmpty) return;
    print(">>> onRevert1 ${_drawings.length} \n");
    var last = _drawings.removeLast();
    _forwards.add(last);
    print(">>> onRevert2 ${_drawings.length} \n");
    _subject.add(_drawings);
  }

  onForward() {
    // if (_forwards.isEmpty) return;
    var forward = _forwards.removeLast();
    _subject.add(_drawings..add(forward));
  }
}