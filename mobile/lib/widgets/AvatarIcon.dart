import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobile/widgets/CircledIcon.dart';

class AvatarIcon extends StatelessWidget {
  final Uint8List? _imageData;
  final double radius;
  final void Function()? onTap;

  AvatarIcon(this._imageData, {this.radius = 18.0, this.onTap});

  AvatarIcon.fromString(
    String? base64String, {
    double radius = 18.0,
    void Function()? onTap,
  }) : this(
          base64String != null ? base64Decode(base64String) : null,
          radius: radius,
          onTap: onTap,
        );

  @override
  Widget build(BuildContext context) {
    final imageData = _imageData;
    if (imageData != null && imageData.isNotEmpty) {
      return GestureDetector(
        onTap: onTap,
        child: ClipOval(
          child: Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Image.memory(
              imageData,
              gaplessPlayback: true,
              fit: BoxFit.cover,
            ),
          ),
        ),
        // child: CircleAvatar(radius: radius, foregroundImage: image),
      );
    } else {
      return CircledIcon(Colors.black, Icons.person, radius: radius + 8);
    }
  }
}
