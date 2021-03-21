import 'package:collab_draw_app/models/touch_point.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:rxdart/rxdart.dart';

class HomeViewModel {

  final Color color;
  List<TouchPoint> _values = [];
  BehaviorSubject<List<TouchPoint>> _subject;

  HomeViewModel(this.color){
    _subject = BehaviorSubject.seeded(_values);
  }
  Stream get offsets => _subject.stream;

  void onPanChange(Object details) {
    Offset offset;
    if (details is DragStartDetails)
      offset = details.localPosition;
    if (details is DragUpdateDetails)
      offset = details.localPosition;
    _values.add(TouchPoint(color, offset));
    _subject.add(_values);
  }

  void dispose() => _subject.close();

  void clear() {
    _values = [];
    _subject.add(_values);
  }

}