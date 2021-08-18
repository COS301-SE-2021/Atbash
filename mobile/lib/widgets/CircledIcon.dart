import 'package:flutter/material.dart';

class CircledIcon extends StatelessWidget {
  final Color _color;
  final IconData _icon;
  final double radius;

  CircledIcon(this._color, this._icon, {this.radius = 18.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1001),
        border: Border.all(width: 1, color: _color),
      ),
      padding: EdgeInsets.all(4.0),
      child: Icon(
        _icon,
        color: _color,
        size: radius,
      ),
    );
  }
}
