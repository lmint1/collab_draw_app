import 'package:flutter/cupertino.dart';

class TouchPoint {
  final Color color;
  final Offset offset;

  TouchPoint(this.color, this.offset);

  TouchPoint.fromJson(Map<String, dynamic> json):
        color = Color(json["color"]),
        offset = _fromValueList(json["off"]);

  Map<String, dynamic> toJson() => {
    'color': color.value,
    'offset': [offset.dx, offset.dy],
  };

  static Offset _fromValueList(List<double> array) {
    try { return Offset(array[0], array[1]); }
    on Exception { return null; }
  }

  bool hasOffset() => offset != null;
  bool hasNotOffset() => offset == null;
}