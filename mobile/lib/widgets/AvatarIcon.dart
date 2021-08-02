import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobile/widgets/CircledIcon.dart';

class AvatarIcon extends StatelessWidget {
  final Uint8List? _imageData;

  AvatarIcon(this._imageData);

  AvatarIcon.fromString(String? base64String)
      : this(base64String != null ? base64Decode(base64String) : null);

  @override
  Widget build(BuildContext context) {
    final imageData = _imageData;
    if (imageData != null && imageData.isNotEmpty) {
      final image = MemoryImage(imageData);
      return CircleAvatar(radius: 16.0, backgroundImage: image);
    } else {
      return CircledIcon(Colors.black, Icons.person);
    }
  }
}
