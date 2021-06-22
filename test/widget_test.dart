// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:collab_draw_app/models/touch_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:collab_draw_app/main.dart';

void main() {
  test("Parse test", () {
    final event = '[[{"color":4280391411,"offset":[203.3333282470703,98.66665649414062]},{"color":4280391411,"offset":[203.66665649414062,99.33332824707031]},{"color":4280391411,"offset":[203.3333282470703,104.0]},{"color":4280391411,"offset":[202.0,110.0]},{"color":4280391411,"offset":[202.0,119.66665649414062]},{"color":4280391411,"offset":[201.0,127.0]},{"color":4280391411,"offset":[198.3333282470703,132.3333282470703]},{"color":4280391411,"offset":[195.3333282470703,137.3333282470703]},{"color":4280391411,"offset":[193.3333282470703,140.0]},{"color":4280391411,"offset":[184.66665649414062,147.3333282470703]},{"color":4280391411,"offset":[169.66665649414062,157.3333282470703]},{"color":4280391411,"offset":[145.66665649414062,168.66665649414062]},{"color":4280391411,"offset":[121.66665649414062,180.0]},{"color":4280391411,"offset":[112.66665649414062,185.0]},{"color":4280391411,"offset":[109.0,186.66665649414062]},{"color":4280391411,"offset":[109.33332824707031,178.3333282470703]},{"color":4280391411,"offset":[110.66665649414062,175.0]},{"color":4280391411,"offset":null}],[{"color":4280391411,"offset":[233.0,266.0]},{"color":4280391411,"offset":[233.0,268.0]},{"color":4280391411,"offset":[233.0,294.0]},{"color":4280391411,"offset":[230.0,332.3333282470703]},{"color":4280391411,"offset":[224.3333282470703,361.6666564941406]},{"color":4280391411,"offset":[213.0,399.6666564941406]},{"color":4280391411,"offset":[201.3333282470703,419.6666564941406]},{"color":4280391411,"offset":[183.3333282470703,438.6666564941406]},{"color":4280391411,"offset":[164.0,445.6666564941406]},{"color":4280391411,"offset":[144.3333282470703,450.3333282470703]},{"color":4280391411,"offset":[125.66665649414062,452.6666564941406]},{"color":4280391411,"offset":[99.66665649414062,456.3333282470703]},{"color":4280391411,"offset":[85.66665649414062,458.6666564941406]},{"color":4280391411,"offset":[85.0,458.6666564941406]},{"color":4280391411,"offset":[84.66665649414062,458.6666564941406]}]]';
    final data = jsonDecode(event) as List<dynamic>;
    final result = data.map((d) {
      final sublist = d as List<dynamic>;
      final map1 = sublist.map((e) => TouchPoint.fromJson(e as Map<String, dynamic>));
      List<TouchPoint> list = map1.toList();
      return list;
    }).toList();

    result;

  });
}
