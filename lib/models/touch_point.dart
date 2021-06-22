import 'dart:ffi';

import 'package:flutter/cupertino.dart';

class TouchPoint {
  final Color color;
  final Offset offset;

  TouchPoint(this.color, this.offset);

  TouchPoint.fromJson(Map<String, dynamic> json):
        color = Color(json['color']),
        offset = _fromValueList(json['offset']);

  Map<String, dynamic> toJson() => {
    'color': color.value,
    'offset': offset == null ? null : [offset.dx, offset.dy],
  };

  static Offset _fromValueList(List<dynamic> array) {
    try { return Offset(array[0], array[1]); }
    on Error { return null; }
  }

  bool hasOffset() => offset != null;
  bool hasNotOffset() => offset == null;
}