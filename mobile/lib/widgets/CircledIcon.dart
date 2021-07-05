import 'package:flutter/material.dart';

class CircledIcon extends StatelessWidget {
  final Color _color;
  final IconData _icon;

  CircledIcon(this._color, this._icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(width: 1, color: _color),
      ),
      padding: EdgeInsets.all(4.0),
      child: Icon(
        _icon,
        color: _color,
      ),
    );
  }
}
