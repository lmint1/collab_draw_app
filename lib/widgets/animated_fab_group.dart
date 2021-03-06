import 'package:collab_draw_app/pages/home_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'choose_color_dialog.dart';

class AnimatedFabGroup extends StatefulWidget {
  final HomeViewModel viewModel;

  AnimatedFabGroup(this.viewModel);

  @override
  _AnimatedFabGroupState createState() => _AnimatedFabGroupState();
}

class _AnimatedFabGroupState extends State<AnimatedFabGroup> {
  var _show = false;
  var counter = 0;
  Color _color = Colors.blue;

  HomeViewModel get viewModel => widget.viewModel;

  @override
  Widget build(BuildContext context) {
    _color = viewModel.color;
    return SizedBox(
        height: 200,
        width: 200,
        child: StreamBuilder(
          stream: viewModel.offsets,
          builder: (_, __) => _stack(),
        ));
  }

  Widget _stack() => Stack(children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 350),
          curve: Curves.fastOutSlowIn,
          bottom: _show ? 65 : 0,
          right: 0,
          child: FloatingActionButton(
            backgroundColor: _color,
            child: Icon(Icons.color_lens, color: Colors.white),
            onPressed: () => _settingModalBottomSheet(context),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 350),
          curve: Curves.fastOutSlowIn,
          right: _show ? 130 : 0,
          bottom: 0,
          child: FloatingActionButton(
            backgroundColor: viewModel.hasPrevious ? _color : Colors.grey,
            child: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: viewModel.hasPrevious ? viewModel.onRevert : null,
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 350),
          curve: Curves.fastOutSlowIn,
          right: _show ? 65 : 0,
          bottom: 0,
          child: FloatingActionButton(
            backgroundColor: viewModel.hasForwards ? _color : Colors.grey,
            child: Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: viewModel.hasForwards ? viewModel.onForward : null,
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: FloatingActionButton(
            backgroundColor: _color,
            child: Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () => setState(() => _show = !_show),
          ),
        ),
      ]);

  void _settingModalBottomSheet(context) async {
    final color = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ChooseColorDialog()));
    if (color == null) return;
    viewModel.color = color;
    setState(() => _color = color);
  }
}
