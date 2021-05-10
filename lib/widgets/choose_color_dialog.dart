import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChooseColorDialog extends StatefulWidget {
  @override
  _ChooseColorDialogState createState() => _ChooseColorDialogState();
}

class _ChooseColorDialogState extends State<ChooseColorDialog> {
  final colors = [...Colors.primaries, ...Colors.accents];
  int _selected = -1;

  @override
  Widget build(BuildContext context) {
    final title = Text(
      "Choose a color",
      style: TextStyle(color: Colors.black)
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () {_selected = -1; pop();},
        ), // Disables back button
        backgroundColor: Colors.white,
        title: Center(child: title),
        actions: [CupertinoButton(child: Text("Done"),onPressed: pop)],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10
        ),
        itemCount: colors.length,
        itemBuilder: _itemBuilder,
      ),
    );
  }

  void pop() => Navigator.of(context).pop(
      _selected < 0 ? null : colors[_selected]);

  Widget _itemBuilder(BuildContext context, int index) => GestureDetector(
      onTap: () => setState(() => _selected = index),
      child: _ColorItem(colors[index], _selected == index),
    );
}

class _CloseButton extends StatelessWidget {
  final Function _onPressed;

  const _CloseButton(this._onPressed);

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
          icon: Icon(Icons.clear, color: Colors.grey), onPressed: _onPressed));
}

class _ColorItem extends StatelessWidget {
  final Color color;
  final bool isSelected;

  _ColorItem(this.color, this.isSelected);

  @override
  Widget build(BuildContext context) {
    const size = 120.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? Colors.black45 : Colors.white,
          width: 5.0,
        ),
      ),
    );
  }
}
