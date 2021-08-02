import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class AvatarIcon extends StatelessWidget {
  final String? _imageData;

  AvatarIcon(this._imageData);

  AvatarIcon.fromUIntList(Uint8List? bytes)
      : this(bytes != null ? base64Encode(bytes) : "");

  @override
  Widget build(BuildContext context) {
    final imageData = _imageData;
    if (imageData != null && imageData.isNotEmpty) {
      final image = _buildAvatarImage(base64Decode(imageData));
      return CircleAvatar(radius: 16.0, backgroundImage: image);
    } else {
      return CircleAvatar(radius: 16.0, child: Icon(Icons.account_circle));
    }
  }

  MemoryImage? _buildAvatarImage(Uint8List? image) {
    return (image != null && image.isNotEmpty) ? MemoryImage(image) : null;
  }
}
