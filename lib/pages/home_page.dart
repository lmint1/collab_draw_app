import 'dart:ui';

import 'package:collab_draw_app/models/touch_point.dart';
import 'package:collab_draw_app/widgets/animated_fab_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'home_view_model.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  HomeViewModel _viewModel = HomeViewModel(Colors.blue);

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text(widget.title))),
      body: GestureDetector(
          onPanStart: _viewModel.onPanChange,
          onPanUpdate: _viewModel.onPanChange,
          onPanEnd: _viewModel.onPanEnd,
          child: _customPaint()
      ),
      floatingActionButton: AnimatedFabGroup(_viewModel),
    );
  }

  Widget _customPaint() {
    return StreamBuilder<List<List<TouchPoint>>>(
      stream: _viewModel.offsets,
      builder: (context, snap) {
        final flatData = (snap.data ?? [[]]).expand((element) => element)
            .toList();
        return CustomPaint(
          size: Size.infinite,
          painter: CollabPainter((flatData ?? []).asMap()),
        );
      },
    );
  }
}

class CollabPainter extends CustomPainter {
  final Map<int, TouchPoint> points;
  CollabPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    var paint = Paint()..strokeWidth = 5.0;

    points.forEach((index, current) {
      final next = points[index + 1];
      final isLine = current.hasOffset() && next.hasOffset();
      final isPoint = current.hasOffset() && next.hasNotOffset();

      paint.color = current.color;
      if (isLine) canvas.drawLine(current.offset, next.offset, paint);
      if (isPoint) canvas.drawPoints(PointMode.points, [current.offset], paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}