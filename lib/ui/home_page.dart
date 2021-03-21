import 'dart:ui';

import 'package:collab_draw_app/models/touch_point.dart';
import 'package:collab_draw_app/ui/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
          onPanEnd: _viewModel.onPanChange,
          child: _customPaint()
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.autorenew_outlined, color: Colors.white),
        onPressed: _viewModel.clear,
      ),
    );
  }

  Widget _customPaint() {
    return StreamBuilder(
      stream: _viewModel.offsets,
      builder: (context, snap) {
        final data = (snap.data ?? []).asMap();
        return CustomPaint(
          size: Size.infinite,
          painter: CollabPainter(data),
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
    var paint = Paint()
      ..strokeWidth = 5.0;

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