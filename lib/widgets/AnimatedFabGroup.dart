import 'package:flutter/material.dart';

class AnimatedFabGroup extends StatefulWidget {
  final Function onClickBtn1;
  final Function onClickBtn2;
  final Function teste;
  AnimatedFabGroup(this.onClickBtn1, this.onClickBtn2, this.teste);

  @override
  _AnimatedFabGroupState createState() => _AnimatedFabGroupState();
}

class _AnimatedFabGroupState extends State<AnimatedFabGroup> {

  var _show = false;
  var counter = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      width: 200,
      child: Stack (
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 350),
            curve: Curves.fastOutSlowIn,
            right: _show ? 130 : 0,
            child: FloatingActionButton(
                child: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: widget.onClickBtn1
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 350),
            curve: Curves.fastOutSlowIn,
            right: _show ? 65 : 0,
            child: FloatingActionButton(
                child: Icon(Icons.arrow_forward, color: Colors.white),
                onPressed: widget.onClickBtn2
            ),
          ),
          Positioned(
            right: 0,
            child: FloatingActionButton(
                child: Icon(Icons.more_horiz, color: Colors.white),
                onPressed: () {
                  counter++;
                  if (counter == 6) {
                    widget.teste();
                    counter = 0;
                  }
                  setState(() => _show = !_show);
                }
            ),
          ),
        ]
      ),
    );
  }


}
