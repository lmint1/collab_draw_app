import 'package:collab_draw_app/pages/home_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedFabGroup extends StatefulWidget {
  final HomeViewModel viewModel;

  AnimatedFabGroup(this.viewModel);

  @override
  _AnimatedFabGroupState createState() => _AnimatedFabGroupState();
}

class _AnimatedFabGroupState extends State<AnimatedFabGroup> {
  var _show = false;
  var counter = 0;

  HomeViewModel get viewModel => widget.viewModel;

  @override
  Widget build(BuildContext context) {
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
            backgroundColor: viewModel.hasPrevious ? Colors.blue : Colors.grey,
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
            backgroundColor: viewModel.hasForwards ? Colors.blue : Colors.grey,
            child: Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: viewModel.hasForwards ? viewModel.onForward : null,
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: FloatingActionButton(
            child: Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () => setState(() => _show = !_show),
          ),
        ),
      ]);

  void _settingModalBottomSheet(context){
    final colors = Colors.primaries;
    final controller = FixedExtentScrollController();
    showModalBottomSheet(context: context,
        builder: (BuildContext bc){
          return SizedBox(
            height: 400,
            child: Stack(
              children: <Widget>[
                Expanded(
                  child: ListWheelScrollView(
                    itemExtent: 100.0,
                    children: colors.map((e) => ListTile(tileColor: e)).toList(),
                  ),
                )
              ],
            ),
          );
        }
    );
  }
}
