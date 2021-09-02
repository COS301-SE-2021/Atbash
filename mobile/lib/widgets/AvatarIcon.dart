import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobile/widgets/CircledIcon.dart';

class AvatarIcon extends StatelessWidget {
  final Uint8List? _imageData;
  final double radius;

  AvatarIcon(this._imageData, {this.radius = 18.0});

  AvatarIcon.fromString(String? base64String, {double radius = 18.0})
      : this(
          base64String != null ? base64Decode(base64String) : null,
          radius: radius,
        );

  @override
  Widget build(BuildContext context) {
    final imageData = _imageData;
    if (imageData != null && imageData.isNotEmpty) {
      final image = MemoryImage(imageData);
      return CircleAvatar(radius: radius, backgroundImage: image);
    } else {
      return CircledIcon(Colors.black, Icons.person, radius: radius + 8);
    }
  }
}
