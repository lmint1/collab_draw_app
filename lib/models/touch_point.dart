import 'package:flutter/cupertino.dart';

class TouchPoint {
  final Color color;
  final Offset offset;

  TouchPoint(this.color, this.offset);

  bool hasOffset() => offset != null;
  bool hasNotOffset() => offset == null;
}